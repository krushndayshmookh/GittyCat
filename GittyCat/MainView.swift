//
//  MainView.swift
//  GittyCat
//
//  Created by Krushn Dayshmookh on 07/10/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var sync: SyncManager

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("GittyCat").font(.title3).bold()
                Spacer()
                if sync.isSyncing { ProgressView().controlSize(.small) }
            }

            Text(sync.lastStatus).font(.caption)
            if let err = sync.lastError {
                HStack {
                    Text(err).font(.caption2).foregroundColor(.red)
                    Spacer()
                    Button("Copy Error Details") {
                        let pasteboard = NSPasteboard.general
                        pasteboard.clearContents()
                        pasteboard.setString(err, forType: .string)
                    }
                    .buttonStyle(.borderless)
                    .font(.caption2)
                }
            }

            Divider()

            HStack(spacing: 8) {
                Button("Sync Now") { Task { await sync.syncAll() } }
                    .disabled(sync.isSyncing)

                Toggle("Auto Sync", isOn: Binding(
                    get: { sync.isAutoSyncEnabled },
                    set: { _ in sync.toggleAutoSync() }
                ))
                .toggleStyle(.switch)

                Spacer()

                Button("Open Config File") { sync.openConfigInFinder() }
                Button("Open Logs") { sync.openLogs() }
            }

            Divider()

            if let cfg = sync.config, !cfg.repos.isEmpty {
                Text("Repositories").font(.headline)
                ForEach(cfg.repos) { r in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(r.name).font(.subheadline).bold()
                            Text(r.path).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Button("Bootstrap") {
                            Task {
                                do {
                                    _ = try await Bootstrap.run(path: r.path, remote: r.remote, branch: r.branch)
                                    sync.lastStatus = "Bootstrapped \(r.name)"
                                } catch { sync.lastError = "\(error)" }
                            }
                        }
                    }
                }
            } else {
                Text("No repositories configured yet.")
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .frame(minWidth: 640, minHeight: 420)
        .task {
            // ensure config/timer are ready when the window shows
            sync.loadConfig()
            sync.startTimerIfNeeded()
        }
    }
}
