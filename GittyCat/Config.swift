//
//  Config.swift
//  GittyCat
//
//  Created by Krushn Dayshmookh on 07/10/25.
//

import Foundation

struct RepoConfig: Codable, Identifiable {
    var id: String { name }
    let name: String
    let path: String
    let remote: String
    let branch: String
    let ignoreFile: String?
    let lfsPatterns: [String]
}

struct AppConfig: Codable {
    let intervalMinutes: Int
    let repos: [RepoConfig]
    let commitMessage: String
    let allowDirtyWorktrees: Bool
}

enum ConfigLoader {
    static var configURL: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("GittyCat", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("config.json")
    }

    static func load() throws -> AppConfig {
        let data = try Data(contentsOf: configURL)
        return try JSONDecoder().decode(AppConfig.self, from: data)
    }
}

extension ConfigLoader {
    static func write(_ config: AppConfig) throws {
        let data = try JSONEncoder().encode(config)
        try data.write(to: configURL, options: [.atomic])
    }

    static func createDefaultIfMissing() {
        let fm = FileManager.default
        if !fm.fileExists(atPath: configURL.path) {
            let empty = AppConfig(
                intervalMinutes: 15,
                repos: [],
                commitMessage: "chore(sync): automatic backup",
                allowDirtyWorktrees: false
            )
            try? write(empty)
        }
    }
}
