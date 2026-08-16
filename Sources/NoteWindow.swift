import AppKit

final class NoteTextView: NSTextView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard string.isEmpty else { return }
        let attrs: [NSAttributedString.Key: Any] = [
            .font: MD.base,
            .foregroundColor: NSColor.black.withAlphaComponent(0.22),
        ]
        ("Write something…" as NSString).draw(
            at: NSPoint(x: textContainerInset.width + 5, y: textContainerInset.height),
            withAttributes: attrs)
    }
}

/// A translucent, borderless, always-on-top sticky note. Text lives only in
/// memory: closing the window throws it away.
final class NoteWindow: NSWindow, NSTextViewDelegate {
    static let defaultSize = NSSize(width: 320, height: 300)

    private let textView = NoteTextView()

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    init(at topLeft: NSPoint) {
        super.init(contentRect: NSRect(origin: .zero, size: Self.defaultSize),
                   styleMask: [.borderless, .resizable],
                   backing: .buffered, defer: false)

        appearance = NSAppearance(named: .aqua)
        isOpaque = false
        isReleasedWhenClosed = false
        backgroundColor = .clear
        hasShadow = true
        level = .floating
        isMovableByWindowBackground = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

        let root = NSView(frame: contentRect(forFrameRect: frame))
        root.wantsLayer = true
        root.layer?.cornerRadius = 14
        root.layer?.masksToBounds = true
        contentView = root

        let blur = NSVisualEffectView()
        blur.material = .popover
        blur.blendingMode = .behindWindow
        blur.state = .active
        blur.autoresizingMask = [.width, .height]
        blur.frame = root.bounds
        root.addSubview(blur)

        let tint = NSView(frame: root.bounds)
        tint.autoresizingMask = [.width, .height]
        tint.wantsLayer = true
        tint.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.55).cgColor
        tint.layer?.borderWidth = 1
        tint.layer?.borderColor = NSColor.white.withAlphaComponent(0.6).cgColor
        tint.layer?.cornerRadius = 14
        root.addSubview(tint)

        textView.delegate = self
        textView.isRichText = false
        textView.allowsUndo = true
        textView.drawsBackground = false
        textView.textContainerInset = NSSize(width: 14, height: 10)
        textView.typingAttributes = MD.defaults
        textView.insertionPointColor = MD.ink
        textView.autoresizingMask = [.width]
        textView.isVerticallyResizable = true
        textView.textContainer?.widthTracksTextView = true

        let scroll = NSScrollView()
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.scrollerStyle = .overlay
        scroll.autoresizingMask = [.width, .height]
        scroll.documentView = textView
        root.addSubview(scroll)

        let close = CloseButton()
        close.onClick = { [weak self] in self?.close() }
        root.addSubview(close)

        let grip = ResizeGrip()
        root.addSubview(grip)

        // Header strip is empty space so dragging it moves the window.
        let header: CGFloat = 36
        scroll.frame = NSRect(x: 0, y: 0, width: root.bounds.width, height: root.bounds.height - header)
        close.frame = NSRect(x: 12, y: root.bounds.height - header + 6,
                             width: CloseButton.size, height: CloseButton.size)
        close.autoresizingMask = [.minYMargin]
        grip.frame = NSRect(x: root.bounds.width - ResizeGrip.size, y: 0,
                            width: ResizeGrip.size, height: ResizeGrip.size)
        grip.autoresizingMask = [.minXMargin, .maxYMargin]

        setFrameTopLeftPoint(topLeft)
        makeFirstResponder(textView)
    }

    func textDidChange(_ notification: Notification) {
        guard let storage = textView.textStorage else { return }
        MD.apply(to: storage)
        textView.typingAttributes = MD.defaults
    }

    override func cancelOperation(_ sender: Any?) {
        close()
    }
}
