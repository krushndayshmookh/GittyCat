//
//  ConfigWizard.swift
//  GittyCat
//
//  Created by Krushn Dayshmookh on 07/10/25.
//

import SwiftUI

struct ConfigWizard: View {
    @Environment(\.dismiss) private var dismiss
    @State private var intervalMinutes: Int = 15
    @State private var commitMessage: String = "chore(sync): automatic backup"
    @State private var allowDirty: Bool = false

    @State private var repos: [RepoDraft] = []
    @State private var selectedRepo: RepoDraft.ID?

    @State private var isSaving = false
    @State private var lastError: String?
    @State private var runBootstrapAfterSave = true

    let onSaved: (AppConfig) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("GittyCat Setup").font(.title2).bold()

            Form {
                Section("Schedule & Commit") {
                    Stepper(value: $intervalMinutes, in: 1...720) {
                        HStack {
                            Text("Auto-sync every")
                            Spacer()
                            Text("\(intervalMinutes) min")
                        }
                    }
                    TextField("Commit message", text: $commitMessage)
                    Toggle("Allow empty commits when clean", isOn: $allowDirty)
                        .help("If OFF, GittyCat skips commit when there are no changes (recommended).")
                }

                Section("Repositories") {
                    HStack {
                        Button(role: .none) {
                            let draft = RepoDraft()
                            repos.append(draft)
                            selectedRepo = draft.id
                        } label: { Label("Add Repo", systemImage: "plus") }

                        Button(role: .destructive) {
                            if let sel = selectedRepo, let idx = repos.firstIndex(where: {$0.id == sel}) {
                                repos.remove(at: idx); selectedRepo = nil
                            }
                        } label: { Label("Remove Selected", systemImage: "minus.circle") }
                        .disabled(selectedRepo == nil)
                    }

                    HStack(alignment: .top) {
                        List(selection: $selectedRepo) {
                            ForEach(repos) { r in
                                Text(r.name.isEmpty ? "Untitled Repo" : r.name)
                                    .tag(r.id)
                            }
                        }
                        .frame(width: 200, height: 220)

                        if let sel = selectedRepo, let idx = repos.firstIndex(where: {$0.id == sel}) {
                            RepoFormView(repo: $repos[idx])
                                .frame(minWidth: 380)
                        } else {
                            Text("Select a repo to edit")
                                .foregroundColor(.secondary)
                                .frame(minWidth: 380, maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }

                Section {
                    Toggle("Run bootstrap after saving (init + first push)", isOn: $runBootstrapAfterSave)
                }
            }

            if let err = lastError {
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

            HStack {
                Spacer()
                Button("Cancel") { dismiss() }
                Button(isSaving ? "Saving…" : "Save") { Task { await saveConfig() } }
                    .keyboardShortcut(.defaultAction)
                    .disabled(isSaving || repos.contains(where: {$0.path.isEmpty || $0.remote.isEmpty || $0.name.isEmpty}))
            }
        }
        .padding(16)
        .frame(width: 720, height: 560)
    }

    private func saveConfig() async {
        isSaving = true; defer { isSaving = false }
        do {
            let cfg = AppConfig(
                intervalMinutes: intervalMinutes,
                repos: repos.map { $0.toConfig() },
                commitMessage: commitMessage,
                allowDirtyWorktrees: allowDirty
            )
            try ConfigLoader.write(cfg)

            if runBootstrapAfterSave {
                for r in cfg.repos {
                    do {
                        _ = try await Bootstrap.run(path: r.path, remote: r.remote, branch: r.branch)
                    } catch {
                        lastError = "Bootstrap failed for \(r.name): \(error)"
                        // continue bootstrapping others
                    }
                }
            }

            onSaved(cfg)
            dismiss()
        } catch {
            lastError = "Save failed: \(error)"
        }
    }
}
