# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

GLEGram — a fork of Swiftgram (which is a fork of Telegram iOS). Base version: Telegram 12.5, Swiftgram 12.5. All GLEGram-specific code is marked with `// MARK: - GLEGram` and `// MARK: - End GLEGram` in Telegram source files.

## Build Commands

```bash
# Production IPA (release_arm64)
./scripts/buildprod.sh

# With custom build number
./scripts/buildprod.sh --buildNumber 100006

# Clean build
./scripts/buildprod.sh --clean

# Simulator build
./scripts/buildsim.sh
```

**Known issue:** Bazel 8.4.2 with embedded JDK 24 crashes on macOS 15.7.4+. The build system auto-applies `--server_javabase` pointing to system JDK 21 (configured in `build-system/Make/Make.py`).

**Build target:** `//Telegram:GLEGram` (alias `//Telegram:Swiftgram` for backwards compatibility).

**Build configuration:** `build-system/ipa-build-configuration.json` + `build-system/real-codesigning/` for production signing.

## Architecture

### Three-layer structure

1. **Telegram base** (`submodules/`) — Original Telegram iOS code. GLEGram patches are injected with `// MARK: - GLEGram` markers and wrapped in `#if canImport(SGSimpleSettings)` guards.

2. **Swiftgram layer** (`Swiftgram/`) — ~50 modules: settings UI, localization, config, badges, logging, requests, API, etc. Core module: `SGSimpleSettings` (UserDefaults-backed settings with 150+ keys). Settings controller: `SGSettingsUI/Sources/SGSettingsController.swift`.

3. **GLEGram layer** (`GLEGram/`) — 10 modules with GLEGram-exclusive features:
   - `SGSupporters` — Encrypted badge/subscription API (AES-256 + HMAC-SHA256 + SSL pinning)
   - `SGDeletedMessages` — AyuGram-style saved deleted messages (namespace 1338)
   - `SGFakeLocation` — CLLocationManager swizzling
   - `SGChatExport` — HTML/JSON/TXT export
   - `SGLocalPremium` — Local Premium emulation
   - `DoubleBottom` — Hidden accounts with secret passcode
   - `ChatPassword` — Per-chat password protection
   - `VoiceMorpher` — Voice preset engine
   - `GLESettingsUI` — 18 controllers (paywall, plugins, fonts, fake profile, etc.)

### Key modified Telegram files

The heaviest GLEGram patches are in:
- `AppDelegate.swift` — App icons, SGConfig.isBetaBuild, supporters init, ghost delay, deeplinks
- `ChatController.swift` — Ghost mode delay, saved deleted hooks
- `AccountStateManagementUtils.swift` — Deleted message saving, edit history
- `PendingMessageManager.swift` — Ghost delay timer (GhostDelayedSendAttribute)
- `ManagedAccountPresence.swift` — Periodic offline timer for ghost mode
- `ManagedLocalInputActivities.swift` — Hide typing/recording/uploading statuses
- `DeleteMessages.swift` — SavedDeleted namespace handling
- `PeerInfoScreen.swift` — GLEGram settings tab, badges, export
- `Font.swift` (Display) — A-Font style font replacement with cache
- `MTTcpConnection.m` — Custom TLS ClientHello fingerprint

### Settings system

- `SGSimpleSettings` (`Swiftgram/SGSimpleSettings/Sources/SimpleSettings.swift`) — All settings keys, defaults, UserDefault properties. GLEGram added 80+ keys (ghost mode, deleted messages, font replacement, fake profile, plugins, gated features, etc.)
- `SGUISettings` (`submodules/TelegramUIPreferences/Sources/Swiftgram/SGUISettings.swift`) — Postbox-backed UI settings
- GLEGram settings controller: `Swiftgram/SGSettingsUI/Sources/GLEGramSettingsController.swift`

### EnqueueMessage.forward

GLEGram added `asCopy: Bool` as 6th parameter to `EnqueueMessage.forward`. All `.forward` constructors need `asCopy:` and all destructuring patterns need 6 wildcards. When adding new `.forward` calls, always include `asCopy: false`.

### BUILD file conventions

GLEGram modules use `//GLEGram/ModuleName:ModuleName` paths. Swiftgram modules use `//Swiftgram/ModuleName:ModuleName`. When adding GLEGram deps to submodule BUILD files, add to the `deps` array (not `sgdeps` which is used for `srcs` in some modules like TelegramUI).

## Code Style

- **Naming**: PascalCase for types, camelCase for variables/methods
- **Imports**: Group and sort; use `#if canImport(SGSimpleSettings)` guards for GLEGram imports in Telegram source files
- **GLEGram markers**: Always wrap GLEGram code in `// MARK: - GLEGram` / `// MARK: - End GLEGram`
- **No tests** are used

## Localization

Strings in `Swiftgram/SGStrings/Strings/` (110 language files, 386 strings). Use `i18n("KEY", lang)` for GLEGram-specific strings. Inline Russian/English with `lang == "ru" ? "..." : "..."` is acceptable for GLEGram-only UI.

## Config

`Swiftgram/SGConfig/Sources/File.swift` — API URLs, supporters API keys, demo login config, `isBetaBuild` flag. Parsed from `BuildConfig.sgConfig` which comes from `variables.bzl` via the build system.
