# Privacy Overlay

A native macOS utility built with Swift and SwiftUI that provides a privacy-focused floating overlay for use during screen presentations and client meetings.

## Features

- **Privacy Protection API**: Uses Apple's documented `NSWindow.sharingType = .none` to exclude the overlay from standard macOS screenshots, QuickTime screen recordings, and modern ScreenCaptureKit screen shares.
- **"Write-Through" (Click-Through) Mode**: Toggle click-through from the menu bar to make the overlay completely transparent to your mouse, allowing you to click and type into the application behind it (like VS Code or Xcode) while keeping your notes visible.
- **Markdown Syntax Highlighting**: A custom-built, lightweight syntax highlighter that colorizes your code blocks (supports Rust, Swift, etc.) in a dark theme when you toggle "Preview Mode".
- **Floating & Resizable**: Drag the window from anywhere on its background. Resize it from any edge. Always stays on top of other windows.
- **Global Hotkey**: Press `Cmd + Shift + O` from anywhere in macOS to instantly show or hide your notes.
- **Real-Time Collaboration**: Generate a 4-digit room code to sync keystrokes instantly via Firestore REST APIs.

## Collaboration (Web Portal)

Your colleague can join the session here: 
👉 [https://pratikjuspay.github.io/PrivacyOverlay/](https://pratikjuspay.github.io/PrivacyOverlay/)

*(Note: If the repository is set to private, you can simply send your colleague the `index.html` file to open in their browser).*

## How to Launch the App

You don't need Xcode to run this application!

1. Open the main project folder (`PrivacyOverlay`).
2. Double-click the **`PrivacyOverlay.app`** file located directly in the root of this folder.
3. You will see a small **eye-with-a-slash icon** appear in your Mac's top-right menu bar.
4. From that menu bar icon, you can:
   - Toggle the overlay visibility.
   - Toggle Click-Through mode.
   - Open Settings.
   - Quit the app completely.

*(Note: If you want to put the app in your Applications folder, just drag `PrivacyOverlay.app` into `/Applications`!)*

## Keyboard Shortcuts

- **Show/Hide Overlay**: `Cmd + Shift + O`
  > **Note**: For this shortcut to work while you are using other apps, you must go to **System Settings -> Privacy & Security -> Accessibility** and grant permissions to the application.

## Testing the Privacy Features

Always test the privacy exclusion before relying on it in a sensitive client meeting, as third-party software (like older versions of Zoom or Teams) may bypass macOS privacy flags by using aggressive screen-scraping techniques.

1. **Screenshot Test**: Press `Cmd + Shift + 3`. The resulting image will completely omit the overlay.
2. **Meeting Test**: Start a meeting on your Mac, share your "Entire Screen", and join the meeting from your phone. Verify on your phone that the overlay is invisible.

## Development

If you wish to modify the code, you can use the provided `project.yml` with [XcodeGen](https://github.com/yonaskolb/XcodeGen) to generate the Xcode project, or simply compile the Swift files manually:

```bash
swiftc Sources/*.swift -o PrivacyOverlay
```
