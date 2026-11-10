# Simple Stickies

Simple sticky notes for your Mac. Click the note icon in the menu bar to write something down. Notes stay above your other windows.

Minimize a note to keep it in the menu bar. Close it to delete it forever. Notes are kept in memory only. Quitting the app deletes all notes, including minimized ones.

Requires an Apple silicon Mac and macOS 13 or newer.

## Install

Download **SimpleStickies.zip** from the [latest release](https://github.com/sxy-sun/simple-stickies/releases/latest), unzip it, and drag **Simple Stickies** into **Applications**.

If macOS blocks the app, open **System Settings → Privacy & Security** and choose **Open Anyway**.

Or install with Homebrew:

```bash
brew tap sxy-sun/simple-stickies https://github.com/sxy-sun/simple-stickies
brew install --cask sxy-sun/simple-stickies/simple-stickies
```

## Use

The app lives in the menu bar at the top of your screen. It has no Dock icon.

| Action | How |
| --- | --- |
| Create a note | Click the note icon, or press **⌘N** while a note is active |
| Minimize a note | Click **−** on the note, or press **⌘M** |
| Restore a note | Click its colored dot in the menu bar |
| Delete a note forever | Click **×**, or press **⌘W** or **Esc** |
| Move a note | Drag the blank space along its top edge |
| Resize a note | Drag an edge or the bottom-right grip |
| Make text bigger | Press **⌘=** or **⌘+** |
| Make text smaller | Press **⌘−** |
| Quit | Right-click the note icon and choose **Quit Simple Stickies** |

Each note has its own color. Its dot appears when you first minimize it and stays in the menu bar when you open it again. Deleting the note removes its dot and makes that color available for a new note. Click inside a note before using keyboard shortcuts.

Type Markdown for headings, bold, italic, code, strikethrough, lists, and quotes. Text styles update as you type.

## Build and run

Install Xcode Command Line Tools, then run these commands from the project folder:

```bash
./build.sh
open -n "build/Simple Stickies.app"
```

To install a local build, quit Simple Stickies first. Copy **build/Simple Stickies.app** into **Applications**, replace the old copy, and open it.

To uninstall, quit the app and move it from **Applications** to the Trash. For a Homebrew install, run `brew uninstall --cask simple-stickies`.

## License

[MIT](LICENSE).
