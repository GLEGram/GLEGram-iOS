# GLEGram iOS

GLEGram — privacy-focused Telegram iOS client based on [Swiftgram](https://github.com/nicegram/nicegram-ios) and [Telegram iOS](https://github.com/nicegram/nicegram-ios).

**Base version:** Telegram 12.5 / Swiftgram 12.5

## Features

### Privacy & Ghost Mode
- Hide online status with periodic offline packets
- Message send delay (12/30/45 sec)
- Hide typing, recording, uploading, and all activity statuses (20+ toggles)
- Disable read receipts for messages and stories (with peer whitelist)
- Disable screenshot detection in secret chats

### Saved Deleted Messages
- Auto-save messages deleted by others (AyuGram-style)
- Save media, reactions, bot messages
- Edit history tracking with inline display
- Search across saved deleted messages

### Content Protection Bypass
- Save copy-protected media (photos, videos)
- Save self-destructing (view-once) messages
- Bypass forward restrictions
- Allow screenshots in secret chats without notification
- Share button for protected content

### Appearance
- Custom font replacement (A-Font style) with size control
- Fake profile (local name, username, phone, badges)
- Custom profile cover (image/video)
- GLEGram app badges (7 color variants)
- Gift ID display

### Other Features
- Chat export (HTML/JSON/TXT)
- Fake location (CLLocationManager swizzling)
- Local Premium emulation
- Telescope (video circles from gallery)
- Plugin system (JS-based)
- Voice morpher (6 presets)
- Double bottom (hidden accounts)
- Chat password protection
- Per-account notification mute
- Local stars balance
- Custom TLS ClientHello fingerprint

## Project Structure

```
GLEGram/          — GLEGram-exclusive modules
├── SGSupporters/     Badges, subscriptions, encrypted API
├── SGDeletedMessages/ Saved deleted messages (namespace 1338)
├── SGFakeLocation/   Location spoofing
├── SGChatExport/     Chat export
├── SGLocalPremium/   Premium emulation
├── DoubleBottom/     Hidden accounts
├── ChatPassword/     Per-chat password
├── VoiceMorpher/     Voice effects
├── GLESettingsUI/    Settings controllers
└── TorEmbedded/      Tor stub

Swiftgram/        — Shared Swiftgram modules (50+)
submodules/       — Telegram iOS base (patched with // MARK: - GLEGram)
Telegram/         — App target and extensions
```

## Build

### Requirements
- macOS 15.7+
- Xcode 26.2+
- JDK 21 (for Bazel)
- Bazel 8.4.2

### Setup

1. Get Telegram API credentials at https://my.telegram.org/apps

2. Create build configuration:
   ```bash
   cp build-system/ipa-build-configuration.json build-system/my-build-configuration.json
   # Edit my-build-configuration.json with your API ID, API Hash, Team ID, Bundle ID
   ```

3. Set up code signing:
   ```bash
   # Place your .mobileprovision files in build-system/real-codesigning/profiles/
   # Place your .p12 certificate in build-system/real-codesigning/certs/
   ```

4. Build:
   ```bash
   # Production IPA (device)
   ./scripts/buildprod.sh

   # With custom build number
   ./scripts/buildprod.sh --buildNumber 100006

   # Clean build
   ./scripts/buildprod.sh --clean
   ```

### Known Issues
- Bazel 8.4.2 with embedded JDK 24 may crash on macOS 15.7.4+. The build system auto-applies `--server_javabase` with system JDK 21.
- First build takes ~15 minutes (opus, webrtc compilation). Subsequent builds use disk cache.

## Contributing

GLEGram code is organized in `GLEGram/` folder. All patches to Telegram source files are marked with:
```swift
// MARK: - GLEGram
<code>
// MARK: - End GLEGram
```

## Credits

- [Telegram iOS](https://github.com/nicegram/nicegram-ios) — Original Telegram client
- [Swiftgram](https://github.com/nicegram/nicegram-ios) — Base fork with additional features

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.
