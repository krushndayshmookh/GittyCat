# GittyCat - AI Coding Instructions

## Architecture Overview

GittyCat is a **macOS menu bar app** for automated Git synchronization, built with SwiftUI and following an MVVM pattern. The app runs as a status bar utility that periodically commits and pushes changes from configured local repositories.

### Core Components

- **`SyncManager`** (ObservableObject): Central coordinator managing config, timers, Git operations, and UI state
- **`AppDelegate`**: Handles menu bar icon and window management using NSStatusItem
- **`Bootstrap`**: Git repository initialization utility for first-time setup
- **`ConfigLoader`**: JSON-based configuration persistence in `~/Library/Application Support/GittyCat/`

### Data Flow

1. Config loaded from JSON → `SyncManager.config`
2. Timer triggers → `syncAll()` → `syncOne()` per repo → Git commands via `Process`
3. UI binds to `@Published` properties on `SyncManager` for reactive updates
4. Status/errors flow through `LogStore` for debugging

## Key Patterns & Conventions

### Git Operations

- **All Git commands use `Process` with `/usr/bin/env git`** - never shell out directly
- **Pull-rebase-then-push workflow** to avoid merge commits: `git pull --rebase origin branch`
- **LFS support** via `lfsPatterns` array in repo config, auto-tracks specified file patterns
- **Bootstrap pattern**: Initialize empty repos with first commit before syncing

### Error Handling

```swift
// Standard pattern for async Git operations with error propagation
do {
    let output = try await runGit(["-C", path, "status", "--porcelain"])
    // process output
} catch {
    lastError = "\(error)"
    logs.append("Failed: \(error)")
}
```

### Configuration Structure

- **`RepoConfig`**: Individual repo settings (path, remote, branch, lfsPatterns)
- **`AppConfig`**: Global settings (intervalMinutes, repos array, commitMessage, allowDirtyWorktrees)
- **Auto-creation**: Missing config.json gets default values via `createDefaultIfMissing()`

### UI State Management

- **`@MainActor`** on SyncManager ensures UI updates on main thread
- **`@Published`** properties: `isSyncing`, `lastStatus`, `lastError`, `config`
- **Environment injection**: SyncManager passed via `.environmentObject()` to all views

## Development Workflows

### Building & Running

```bash
# Open in Xcode
open GittyCat.xcodeproj

# Build via xcodebuild
xcodebuild -project GittyCat.xcodeproj -scheme GittyCat build
```

### Testing Git Operations

The app requires actual Git repositories for testing. Use `Bootstrap.run()` to create test repos:

```swift
try await Bootstrap.run(path: "/tmp/test-repo", remote: "git@github.com:user/repo.git", branch: "main")
```

### Debugging

- **LogStore** captures all Git commands and results
- **"Open Logs"** button in UI writes logs to `/tmp/gittycat.log`
- **Status messages** show in UI immediately, errors persist until next operation

## macOS Integration

### Sandboxing

- **App Sandbox enabled** with `com.apple.security.files.user-selected.read-only`
- **User must manually select directories** via `NSOpenPanel` in `RepoFormView`
- **No automatic file system access** outside user-selected paths

### Menu Bar App Pattern

- **`NSStatusItem`** in AppDelegate for persistent menu bar presence
- **Window shows/hides** on icon click rather than traditional app lifecycle
- **`NSHostingController`** bridges SwiftUI views to AppKit windows

### Process Execution

```swift
// Standard pattern for shell commands (used extensively for Git)
let task = Process()
task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
task.arguments = ["git"] + gitArgs
// Handle stdout/stderr via Pipe objects
```

## Common Gotchas

- **Timer invalidation**: Always call `timer?.invalidate()` before creating new timers
- **Main thread UI**: All `@Published` updates must happen on main thread
- **Git directory context**: Always use `-C path` flag for Git operations in specific directories
- **Config file location**: Stored in Application Support, not bundle - check `ConfigLoader.configURL`
- **LFS initialization**: Must run `git lfs install --skip-repo` before tracking patterns

## File Structure Navigation

- **Main app entry**: `GittyCatApp.swift` with `@main`
- **Core logic**: `SyncManager.swift` contains most business logic
- **Git utilities**: `Bootstrap.swift` for repo setup, Git operations in SyncManager
- **UI components**: `MainView` (primary), `ConfigWizard` (setup), `RepoFormView` (repo editing)
- **Data models**: `Config.swift` defines all Codable structs

When adding new features, follow the established pattern of updating `SyncManager` for logic and binding UI via `@Published` properties.
