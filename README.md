# 🐱 GittyCat

> A friendly macOS app that automatically commits and syncs your local folders (like configs, documents, or notes) to GitHub — just like Google Drive, but powered by Git.

![Platform](https://img.shields.io/badge/platform-macOS-blue)
![SwiftUI](https://img.shields.io/badge/SwiftUI-%E2%9D%A4-red)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-Beta-yellow)

---

## ✨ Overview

**GittyCat** is a lightweight, open-source menu-bar app for macOS that keeps your important folders in sync with GitHub.  
No more manual commits, `cd` into folders, or scripts — GittyCat quietly tracks your chosen directories and pushes updates automatically (or on demand) from your menu bar.

It’s perfect for:

- Backing up your `~/Documents`, `~/Notes`, or `.config` folders.
- Version-controlling personal setups (dotfiles, scripts, drafts).
- Keeping text or markdown notes safely versioned without CLI.

---

## 🚀 Features

- 🧠 **Smart Auto-Sync:** Periodic commits and pushes based on your schedule.  
- 💻 **Menu-Bar / Status-Icon Mode:** Click the cat to open your dashboard.  
- 🗂️ **Multi-Repo Support:** Sync any number of local folders.  
- 🧩 **One-Click Setup:** Built-in GUI to generate `config.json` and bootstrap new repos — no command line needed.  
- 🧱 **Git LFS Support:** Track large files automatically.  
- 🔒 **SSH-based Authentication:** Secure, passwordless Git pushes.  
- 🧾 **Logs & Notifications:** View sync logs, status, and errors in-app.  
- 🐾 **Cute + Minimal:** Because backup apps shouldn’t be boring.

---

## 🧰 Tech Stack

| Component | Technology |
|------------|-------------|
| Language | Swift 5.9+ |
| UI Framework | SwiftUI + AppKit |
| macOS APIs | `NSStatusItem`, `NSWindow`, `NSWorkspace` |
| Build Tool | Xcode 15+ |
| Git Integration | System `git` via `Process()` |
| Minimum macOS | macOS 13 (Ventura) |

---

## 🧑‍💻 Setup (Developers)

### 1. Clone the repo

```bash
git clone https://github.com/krushndayshmookh/GittyCat.git
cd GittyCat
open GittyCat.xcodeproj
```

### 2. Build & Run

- Open in **Xcode 15+**
- Run (⌘R) — the **🐱 cat icon** appears in your menu bar
- Click it to open the main window

### 3. Configure (First Launch)

1. Click **“Setup / Edit Configuration”**
2. Add repositories you want GittyCat to manage:
   - Local folder path  
   - Remote GitHub URL (SSH preferred)  
   - Branch name (default: `main`)
3. Optionally, enable **Bootstrap** to auto-init and push the first commit.

> Your configuration file is stored at:  
> `~/Library/Application Support/GittyCat/config.json`

---

## 🧩 Example `config.json`

```json
{
  "intervalMinutes": 15,
  "repos": [
    {
      "name": "HomeConfig",
      "path": "/Users/krushn/.config",
      "remote": "git@github.com:krushndayshmookh/home-config.git",
      "branch": "main",
      "ignoreFile": "/Users/krushn/.config/.gitignore",
      "lfsPatterns": []
    },
    {
      "name": "Documents",
      "path": "/Users/krushn/Documents",
      "remote": "git@github.com:krushndayshmookh/documents-archive.git",
      "branch": "main",
      "ignoreFile": "/Users/krushn/Documents/.gitignore",
      "lfsPatterns": ["*.pdf", "*.mp4"]
    }
  ],
  "commitMessage": "chore(sync): automatic backup",
  "allowDirtyWorktrees": false
}
```

---

## 🐾 Roadmap

- [ ] iCloud / remote config backup  
- [ ] Background daemon mode  
- [ ] Status notifications (success/fail)  
- [ ] Conflict resolution UI  
- [ ] Auto .gitignore editor  
- [ ] Secure bookmark access for Sandbox build  
- [ ] Signed release on GitHub

---

## 🤝 Contributing

Pull requests are welcome!  
If you’d like to fix bugs, improve the UI, or add features:

1. Fork the repo  
2. Create a feature branch (`git checkout -b feature/your-feature`)  
3. Commit and push  
4. Open a Pull Request

Please follow Swift style conventions and add clear commit messages.

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](./CODE_OF_CONDUCT.md).  
By participating, you agree to uphold this code.


---

## 🐙 License

Released under the **MIT License**.  
See [LICENSE](LICENSE) for details.

---

## 💬 Credits

Created by [**Krushn Dayshmookh**](https://github.com/krushndayshmookh)  
Made with 🐱 in India.

---

> “GittyCat keeps your files purring in sync — so you don’t have to.”
