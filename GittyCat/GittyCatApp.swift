//
//  GittyCatApp.swift
//  GittyCat
//
//  Created by Krushn Dayshmookh on 07/10/25.
//

import SwiftUI

@main
struct GittyCatApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var syncManager = SyncManager()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(syncManager)
                .onAppear {
                    appDelegate.syncManager = syncManager
                }
        }
        .defaultSize(width: 800, height: 520)
    }
}
