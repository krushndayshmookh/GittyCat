//
//  AppDelegate.swift
//  GittyCat
//
//  Created by Krushn Dayshmookh on 07/10/25.
//


import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    weak var syncManager: SyncManager?
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            // Prefer a template asset named "StatusBarIcon" (added to Assets.xcassets)
            // Fallback to SF Symbol. Ensure the image is rendered as a template so it
            // adapts to light/dark system appearances in the menu bar.
            if let assetImage = NSImage(named: "StatusBarIcon") {
                assetImage.isTemplate = true
                button.image = assetImage
            } else if let symbol = NSImage(systemSymbolName: "cat.fill", accessibilityDescription: "GittyCat") {
                // Use a small symbol configuration for proper sizing in the status bar
                if #available(macOS 11.0, *) {
                    let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .regular)
                    let configured = symbol.withSymbolConfiguration(config) ?? symbol
                    configured.isTemplate = true
                    button.image = configured
                } else {
                    symbol.isTemplate = true
                    button.image = symbol
                }
            }
            button.action = #selector(toggleMainWindow)
            button.target = self
        }
    }

    @objc private func toggleMainWindow() {
        if let window = window, window.isVisible {
            // bring to front if already visible
            NSApp.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(nil)
            return
        }
        showMainWindow()
    }

    private func showMainWindow() {
        let content = MainView().environmentObject(syncManager!)
        let hosting = NSHostingController(rootView: content)

        let win = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 520),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false
        )
        win.title = "GittyCat"
        win.contentViewController = hosting
        win.center()

        // Keep a strong reference so it isn't deallocated
        self.window = win

        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
    }
}