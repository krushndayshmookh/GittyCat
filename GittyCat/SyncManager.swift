//
//  SyncManager.swift
//  GittyCat
//
//  Created by Krushn Dayshmookh on 07/10/25.
//

import Foundation
import SwiftUI
import AppKit

@MainActor
final class SyncManager: ObservableObject {
    @Published var config: AppConfig?
    @Published var isAutoSyncEnabled: Bool = true
    @Published var isSyncing: Bool = false
    @Published var lastStatus: String = "Idle"
    @Published var lastError: String?
    let logs = LogStore()

    private var timer: Timer?
    var menuIcon: String { isSyncing ? "arrow.triangle.2.circlepath" : "externaldrive.fill" }

    func loadConfig() {
        do {
            ConfigLoader.createDefaultIfMissing()
            config = try ConfigLoader.load()
            lastStatus = "Config loaded"
        } catch {
            lastError = "Config load failed: \(error)"
            lastStatus = "Config error"
        }
    }

    func startTimerIfNeeded() {
        guard let cfg = config else { return }
        timer?.invalidate()
        guard isAutoSyncEnabled else { return }
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(cfg.intervalMinutes * 60), repeats: true) { [weak self] _ in
            Task { await self?.syncAll() }
        }
    }

    func toggleAutoSync() {
        isAutoSyncEnabled.toggle()
        startTimerIfNeeded()
    }

    func openConfigInFinder() {
        NSWorkspace.shared.activateFileViewerSelecting([ConfigLoader.configURL])
    }

    func openLogs() {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("gittycat.log")
        let joined = logs.lines.joined(separator: "\n")
        try? joined.data(using: .utf8)?.write(to: url)
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }

    func syncAll() async {
        guard !isSyncing else { return }
        guard let cfg = config else { return }
        isSyncing = true
        lastError = nil

        do {
            for repo in cfg.repos {
                try await syncOne(repo: repo, commitMessage: cfg.commitMessage, allowDirty: cfg.allowDirtyWorktrees)
            }
            let ts = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
            lastStatus = "Synced at \(ts)"
            logs.append("Sync OK")
        } catch {
            lastError = "\(error)"
            lastStatus = "Sync failed"
            logs.append("Sync failed: \(error)")
        }

        isSyncing = false
    }

    private func syncOne(repo: RepoConfig, commitMessage: String, allowDirty: Bool) async throws {
        let fm = FileManager.default
        guard fm.fileExists(atPath: repo.path) else {
            throw NSError(domain: "GittyCat", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing path \(repo.path)"])
        }

        // Ensure remote + branch exist
        do {
            _ = try await runGit(["-C", repo.path, "remote", "set-url", "origin", repo.remote])
            _ = try await runGit(["-C", repo.path, "rev-parse", "--abbrev-ref", "HEAD"])
        } catch {
            _ = try await runGit(["-C", repo.path, "checkout", "-B", repo.branch])
        }

        // Pull rebase to avoid diverging histories
        _ = try? await runGit(["-C", repo.path, "pull", "--rebase", "origin", repo.branch])

        // Add LFS patterns if any
        if !repo.lfsPatterns.isEmpty {
            _ = try? await runGit(["lfs", "install", "--skip-repo"])
            for p in repo.lfsPatterns {
                _ = try? await runGit(["-C", repo.path, "lfs", "track", p])
            }
            _ = try? await runGit(["-C", repo.path, "add", ".gitattributes"])
        }

        // Stage/commit/push
        _ = try await runGit(["-C", repo.path, "add", "-A"])

        let status = try await runGit(["-C", repo.path, "status", "--porcelain"]).trimmingCharacters(in: .whitespacesAndNewlines)
        if !status.isEmpty {
            _ = try await runGit(["-C", repo.path, "commit", "-m", commitMessage])
        } else if !allowDirty {
            logs.append("[\(repo.name)] clean, skipping commit")
        }

        _ = try await runGit(["-C", repo.path, "push", "origin", repo.branch])
        logs.append("[\(repo.name)] pushed")
    }

    @discardableResult
    private func runGit(_ args: [String]) async throws -> String {
        logs.append("git " + args.joined(separator: " "))
        return try await withCheckedThrowingContinuation { cont in
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            task.arguments = ["git"] + args

            let outPipe = Pipe(); let errPipe = Pipe()
            task.standardOutput = outPipe; task.standardError = errPipe

            task.terminationHandler = { proc in
                let outData = outPipe.fileHandleForReading.readDataToEndOfFile()
                let errData = errPipe.fileHandleForReading.readDataToEndOfFile()
                let out = String(data: outData, encoding: .utf8) ?? ""
                let err = String(data: errData, encoding: .utf8) ?? ""
                if proc.terminationStatus == 0 {
                    cont.resume(returning: out)
                } else {
                    let msg = err.isEmpty ? out : err
                    cont.resume(throwing: NSError(domain: "GittyCat", code: Int(proc.terminationStatus), userInfo: [NSLocalizedDescriptionKey: msg]))
                }
            }

            do { try task.run() } catch { cont.resume(throwing: error) }
        }
    }
}
