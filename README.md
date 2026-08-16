# Simple Stickies

Sticky notes that live in your menu bar. Click the icon, a note appears. Close it, the note is gone.

No accounts, no sync, no save button, no settings. It is Apple's Stickies with the annoying parts removed, starting with buttons big enough to actually click.

<!-- TODO: replace VIDEO_ID below (it appears twice) with your YouTube video ID.
     A URL like https://www.youtube.com/watch?v=abc123XYZ means the ID is abc123XYZ.
     GitHub strips <iframe>, so a thumbnail linking to YouTube is the standard
     way to do this. -->
[![Watch the demo](https://img.youtube.com/vi/VIDEO_ID/maxresdefault.jpg)](https://www.youtube.com/watch?v=VIDEO_ID)

Runs on Mac with an M chip only. [Check yours](#will-it-run-on-my-mac)

## Download

### [⬇ Download Simple Stickies](https://github.com/sxy-sun/simple-stickies/releases/latest)

1. Click the link above and download **SimpleStickies.zip**.
2. Double click the downloaded file to unzip it.
3. Drag **Simple Stickies** into your **Applications** folder.
4. Open it. The first time only, macOS shows a warning. Clear it with the steps below.

**The first time you open it**

macOS blocks apps that are not signed with a paid Apple certificate. Simple Stickies is free and unsigned, so this warning appears once and never again.

1. Double click **Simple Stickies**. A warning appears. Click **Done**.
2. Open  → **System Settings** → **Privacy & Security**.
3. Scroll down until you see *"Simple Stickies was blocked to protect your Mac."*
4. Click **Open Anyway**. Enter your Mac password if asked.
5. Open the app again. It works from now on.

**Uninstall**

Drag **Simple Stickies** from your Applications folder to the Trash. It leaves nothing behind.

## Install with Homebrew

This way skips the security warning.

```bash
brew tap sxy-sun/simple-stickies https://github.com/sxy-sun/simple-stickies
brew install --cask simple-stickies
```

**Uninstall**

```bash
brew uninstall --cask simple-stickies
```

**No Homebrew?** Run this first, then the two commands above.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Will it run on my Mac?

Click  in the top left corner, then **About This Mac**, and look at the **Chip** line.

| It says | Result |
| --- | --- |
| Apple M1, M2, M3, M4 or M5 (any Pro, Max, Ultra) | ✅ Works |
| Intel Core i5, i7, i9 | ❌ Won't run |

You also need **macOS 13 Ventura or newer**, released in 2022.

## How to use it

> **Nothing appears in the Dock.** This app lives in the menu bar at the *top* of your screen. Look for the 📝 icon near the clock.

| Action | How |
| --- | --- |
| New note | Click the 📝 icon in the menu bar |
| Move a note | Drag the blank strip along its top edge |
| Resize | Drag the grip in the bottom right corner, or any edge |
| Close and delete | Click the big **×** |
| Quit | Right click the 📝 icon, then **Quit** |

**Nothing is ever saved.** Text exists only while the note is on screen. Closing a note or quitting the app throws the text away on purpose. This is for things you don't want to keep, so copy anything you need somewhere else first.

To start it automatically when your Mac turns on: **System Settings → General → Login Items → +** and pick Simple Stickies.

## Formatting

Type Markdown and it styles itself as you go. There is no preview button to press.

| Type this | Get |
| --- | --- |
| `# Big heading` | Large bold text |
| `## Smaller heading` | Medium bold text |
| `**bold**` | **bold** |
| `*italic*` | *italic* |
| `` `code` `` | `code` |
| `~~strikethrough~~` | ~~strikethrough~~ |
| `- item` | Bulleted list |
| `1. item` | Numbered list |
| `> quote` | Indented grey quote |

## License

MIT, see [LICENSE](LICENSE).
