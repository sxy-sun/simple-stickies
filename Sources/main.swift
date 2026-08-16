import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    private var statusItem: NSStatusItem!
    private var notes: [NoteWindow] = []
    private var cascade: CGFloat = 0

    func applicationDidFinishLaunching(_ notification: Notification) {
        buildMainMenu()

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.image = NSImage(systemSymbolName: "note.text",
                                           accessibilityDescription: "Simple Stickies")
        statusItem.button?.target = self
        statusItem.button?.action = #selector(statusItemClicked)
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }

    @objc private func statusItemClicked() {
        if NSApp.currentEvent?.type == .rightMouseUp {
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "New Note", action: #selector(newNote), keyEquivalent: ""))
            menu.addItem(.separator())
            menu.addItem(NSMenuItem(title: "Quit Simple Stickies", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
            menu.items.forEach { $0.target = $0.action == #selector(newNote) ? self : nil }
            statusItem.menu = menu
            statusItem.button?.performClick(nil)
            statusItem.menu = nil
        } else {
            newNote()
        }
    }

    @objc private func newNote() {
        // Centre on whichever screen the pointer is on, then cascade from there.
        let mouse = NSEvent.mouseLocation
        guard let screen = NSScreen.screens.first(where: { $0.frame.contains(mouse) }) ?? NSScreen.main
        else { return }
        let area = screen.visibleFrame
        let size = NoteWindow.defaultSize
        let origin = NSPoint(x: area.midX - size.width / 2 + cascade,
                             y: area.midY + size.height / 2 - cascade)
        cascade = cascade > 120 ? 0 : cascade + 26

        let note = NoteWindow(at: origin)
        note.delegate = self
        notes.append(note)
        NSApp.activate(ignoringOtherApps: true)
        note.makeKeyAndOrderFront(nil)
    }

    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NoteWindow else { return }
        notes.removeAll { $0 === window }
    }

    private func buildMainMenu() {
        let main = NSMenu()

        let appItem = NSMenuItem()
        let appMenu = NSMenu()
        appMenu.addItem(withTitle: "New Note", action: #selector(newNote), keyEquivalent: "n").target = self
        appMenu.addItem(withTitle: "Close Note", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
        appMenu.addItem(.separator())
        appMenu.addItem(withTitle: "Quit Simple Stickies", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
        appItem.submenu = appMenu
        main.addItem(appItem)

        let editItem = NSMenuItem()
        let editMenu = NSMenu(title: "Edit")
        editMenu.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
        editMenu.addItem(withTitle: "Redo", action: Selector(("redo:")), keyEquivalent: "Z")
        editMenu.addItem(.separator())
        editMenu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        editMenu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        editMenu.addItem(.separator())
        // Two entries for bigger: ⌘+ needs shift on most layouts, but people
        // press ⌘= just as often. Both land on the same action.
        let biggerShift = editMenu.addItem(withTitle: "Bigger",
                                           action: #selector(NoteWindow.makeTextBigger(_:)),
                                           keyEquivalent: "+")
        biggerShift.keyEquivalentModifierMask = [.command, .shift]
        let bigger = editMenu.addItem(withTitle: "Bigger",
                                      action: #selector(NoteWindow.makeTextBigger(_:)),
                                      keyEquivalent: "=")
        bigger.keyEquivalentModifierMask = [.command]
        editMenu.addItem(withTitle: "Smaller",
                         action: #selector(NoteWindow.makeTextSmaller(_:)),
                         keyEquivalent: "-")
        editItem.submenu = editMenu
        main.addItem(editItem)

        NSApp.mainMenu = main
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
