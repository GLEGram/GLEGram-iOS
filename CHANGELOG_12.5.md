# GLEGram 12.5 — Changelog

**Base:** Swiftgram 12.5 (Telegram iOS 12.5)
**Build:** 100005
**Date:** 2026-04-05

---

## Migration from 12.3 to 12.5

Full port of all GLEGram features onto the Swiftgram 12.5 codebase.
166 files changed, 8211 insertions, 77 new files.
All GLEGram code organized in `GLEGram/` folder and marked with `// MARK: - GLEGram` in Telegram source files.

---

## New Features

### Double Bottom
- Secret passcode unlocks a single hidden account
- Keychain-based passcode storage
- Settings controller with enable/disable toggle
- Module: `GLEGram/DoubleBottom/`

### Chat Password Protection
- Lock individual chats/folders with device passcode or custom password
- Keychain-based per-peer password storage
- Settings controller with peer selection
- Module: `GLEGram/ChatPassword/`

### Voice Morpher
- 6 voice presets: Disabled, Anonymous, Female, Male, Child, Robot
- OGG processing engine (ready for OpusBinding integration)
- UserDefaults persistence with change notifications
- Module: `GLEGram/VoiceMorpher/`

### SGLocalPremium
- Full local Premium emulation without subscription
- Unlimited pinned chats, folders, chats per folder
- Saved Message Tags support
- Server sync disabling for pinned/folders/folder order
- Module: `GLEGram/SGLocalPremium/`

### Plugin System (Extended)
- Inline JS plugin code editor
- Plugin metadata parsing and file management
- GLEGramFeatures global feature flags
- Module: `GLEGram/GLESettingsUI/`, `Swiftgram/SGSimpleSettings/`

### Video Wallpapers
- Video file picker (Files app + Gallery)
- Looping video playback as chat background
- Power saving mode support
- Intensity/dimming controls
- Preview controller with Cancel/Done
- Module: integrated in `WallpaperBackgroundNode`, `ThemeGridController`

---

## Ported Features (from 12.3)

### Ghost Mode (20+ toggles)
- Message send delay (0/12/30/45 sec)
- Hide online status with periodic offline timer
- Hide typing, recording, uploading, choosing, playing, speaking statuses
- Disable read receipts (messages + stories) with peer whitelist
- Files: `ManagedAccountPresence.swift`, `ManagedLocalInputActivities.swift`, `PendingMessageManager.swift`

### Saved Deleted Messages (AyuGram-style)
- Auto-save deleted messages to SavedDeleted namespace (1338)
- Save media, reactions, bot messages
- Edit history tracking with inline display
- Search in saved deleted messages
- Storage management and clear action
- Files: `AccountStateManagementUtils.swift`, `DeleteMessages.swift`, `SearchMessages.swift`

### Fake Profile
- Custom first/last name, username, phone, ID
- Premium/verified/scam/fake/support/bot badges
- Per-user targeting
- Module: `Swiftgram/SGSettingsUI/`

### Font Replacement (A-Font style)
- Custom font from system or imported file
- Separate regular and bold font selection
- Size multiplier (50-150%)
- Font cache with clearCache() support
- Files: `Display/Source/Font.swift`

### Profile Cover
- Custom image/video cover on profile
- AVPlayer looping playback
- Module: `Swiftgram/SGSettingsUI/`

### Chat Export
- Export as JSON, TXT, HTML
- AyuGram-style HTML export with CSS/JS
- Context menu in profile "More" button
- Module: `GLEGram/SGChatExport/`

### Fake Location
- CLLocationManager swizzling
- Map picker controller
- Persistent coordinates
- Module: `GLEGram/SGFakeLocation/`

### Supporters/Badges System
- Encrypted API with AES-256 + HMAC-SHA256
- SSL certificate pinning
- Badge image cache
- Server badges with custom colors/images
- Subscription/trial tracking with expiry date display
- Module: `GLEGram/SGSupporters/`

### Demo Login (App Store Review)
- Backend-driven phone number interception
- Auto code polling and entry
- Auto 2FA password entry
- Files: `AuthorizationSequenceController.swift`, `GLEDemoLoginService.swift`

### Protected Content Override
- Save protected/copy-protected media
- Save self-destructing messages
- Disable screenshot detection
- Disable secret chat blur on screenshot
- Files: `SyncCore_AutoremoveTimeoutMessageAttribute.swift`, `ChatMessageInteractiveMediaNode.swift`

### Online Status Recording
- Track peer online/offline timestamps
- Emulate Premium "Last seen" for hidden users
- Module: `Swiftgram/SGSettingsUI/`

### Other Ported Features
- Hide proxy sponsor
- Disable all ads
- Local Premium toggle
- Scroll to top button
- Telescope (video circles/voice from gallery)
- Unlimited favorite stickers
- Compact numbers disable
- Zalgo text removal
- Gift ID display in gift info
- Local stars balance (feelRich)
- Per-account notification mute
- Gated features with deeplink unlock
- Plugin system with PythonKit bridge

---

## UI/Branding Changes

- App name: **GLEGram**
- Default icon: **GLEGramDarkPurple**
- 7 alternate icons: DarkPurple, Black, Green, Pink, Purple, Red, Duck
- App badges: GLEGram-branded (Sky, Night, Pro, Titanium, Day, Sparkling, Ducky)
- Settings icons: GLEGram-branded Swiftgram/SwiftgramPro icons
- Composer icon: GLEGram.icon with GLEGramDarkPurple.png
- Intro sphere: GLEGram-branded telegram_sphere@2x.png
- CFBundleDisplayName: GLEGram (all extensions)
- URL scheme: `glegram://` added
- Notification service: processDeletedMessages
- GLEGram tab in Settings with subscription expiry date label

---

## Build System Changes

- Bazel JDK fix: `--server_javabase` for JDK 21 (fixes SIGBUS on macOS 15.7.4)
- Prebuilt opus: instant build instead of 10min genrule
- GLEGram BUILD target with Swiftgram alias
- 15 build scripts ported (buildprod, buildsim, deploy, sign, etc.)
- Real codesigning profiles
- Provisioning profile fallback logic
- Extension disabling support

---

## TLS ClientHello Improvements (Desktop-like fingerprint)

| # | Change | Detail |
|---|--------|--------|
| 4 | Cipher suites | 15 suites, Desktop order, removed c00a/c009 |
| 5 | Session Ticket | Extension 0x0023 added |
| 6 | ALPS | Extension 0x44cd added (h2) |
| 7 | Supported groups | Removed P-521, kept x25519/P-256/P-384 |
| 8 | Signature algorithms | 8 algos, removed SHA-1 (0x0201) |
| 9 | Record size limit | 0x0002 instead of 0x0001 |
| 10 | GREASE padding | 2 bytes instead of 4 |

---

## Localization

- 110 language files with 386 strings each (107 GLEGram-specific strings added)
- Full Russian and English translations for all GLEGram features
- 5 new 12.5 strings preserved (ChatList.Lines, CompactMessagePreview)

---

## File Structure

```
GLEGram/
├── ChatPassword/        (chat lock)
├── DoubleBottom/        (hidden accounts)
├── GLESettingsUI/       (18 controllers + plugins)
├── SGChatExport/        (HTML/JSON/TXT export)
├── SGDeletedMessages/   (saved deleted messages)
├── SGFakeLocation/      (location spoofing)
├── SGLocalPremium/      (premium emulation)
├── SGSupporters/        (badges, subscriptions)
└── VoiceMorpher/        (voice effects)
```
