//
//  Bootstrap.swift
//  GittyCat
//
//  Created by Krushn Dayshmookh on 07/10/25.
//

import Foundation

enum Bootstrap {
    struct Result { let output: String }

    @discardableResult
    static func run(path: String, remote: String, branch: String) async throws -> Result {
        // Ensure folder exists
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)

        // 1) git init (if needed)
        do {
            _ = try await git(["-C", path, "rev-parse", "--git-dir"])
        } catch {
            _ = try await git(["-C", path, "init"])
        }

        // 2) set/add remote
        _ = try? await git(["-C", path, "remote", "set-url", "origin", remote])
        _ = try? await git(["-C", path, "remote", "add", "origin", remote])

        // 3) first commit if repo empty
        let hasHead = (try? await git(["-C", path, "rev-parse", "--verify", "HEAD"])) != nil
        if !hasHead {
            _ = try await git(["-C", path, "add", "-A"])
            _ = try await git(["-C", path, "commit", "-m", "chore(init): bootstrap"])
            _ = try await git(["-C", path, "branch", "-M", branch])
        }

        // 4) push upstream
        _ = try? await git(["-C", path, "pull", "--rebase", "origin", branch])
        let pushOut = try await git(["-C", path, "push", "-u", "origin", branch])

        return .init(output: pushOut)
    }

    @discardableResult
    static func git(_ args: [String]) async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            task.arguments = ["git"] + args

            let outPipe = Pipe(), errPipe = Pipe()
            task.standardOutput = outPipe; task.standardError = errPipe
            task.terminationHandler = { proc in
                let out = String(data: outPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
                let err = String(data: errPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
                if proc.terminationStatus == 0 { cont.resume(returning: out) }
                else { cont.resume(throwing: NSError(domain: "Bootstrap", code: Int(proc.terminationStatus),
                                                     userInfo: [NSLocalizedDescriptionKey: err.isEmpty ? out : err])) }
            }
            do { try task.run() } catch { cont.resume(throwing: error) }
        }
    }
}
