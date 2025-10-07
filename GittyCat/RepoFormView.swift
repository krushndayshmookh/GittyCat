//
//  RepoFormView.swift
//  GittyCat
//
//  Created by Krushn Dayshmookh on 07/10/25.
//

import SwiftUI
import AppKit

struct RepoDraft: Identifiable, Hashable {
    var id = UUID()
    var name: String = ""
    var path: String = ""
    var remote: String = ""
    var branch: String = "main"
    var lfsPatterns: String = "" // comma-separated
}

struct RepoFormView: View {
    @Binding var repo: RepoDraft

    var body: some View {
        VStack(spacing: 8) {
            TextField("Name", text: $repo.name)
            HStack {
                TextField("Local folder path", text: $repo.path)
                Button("Choose…") { pickFolder() }
            }
            TextField("Git remote (SSH recommended)", text: $repo.remote)
            TextField("Branch", text: $repo.branch)
            TextField("LFS patterns (comma-separated, e.g. *.pdf, *.mp4)", text: $repo.lfsPatterns)
        }
    }

    private func pickFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.begin { resp in
            if resp == .OK, let url = panel.url {
                repo.path = url.path
            }
        }
    }
}

extension RepoDraft {
    func toConfig() -> RepoConfig {
        let patterns = lfsPatterns.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        return RepoConfig(
            name: name,
            path: path,
            remote: remote,
            branch: branch,
            ignoreFile: nil,
            lfsPatterns: patterns
        )
    }
}
