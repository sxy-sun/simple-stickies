import AppKit

/// Large round controls for deleting or minimizing a note.
final class NoteControlButton: NSView {
    enum Kind { case close, minimize }
    static let size: CGFloat = 24
    private let kind: Kind
    var onClick: () -> Void = {}
    private var hovering = false

    init(kind: Kind = .close) {
        self.kind = kind
        super.init(frame: .zero)
        toolTip = kind == .close ? "Delete note" : "Minimize note (⌘M)"
        setAccessibilityElement(true)
        setAccessibilityRole(.button)
        setAccessibilityLabel(kind == .close ? "Delete note" : "Minimize note")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func accessibilityPerformPress() -> Bool {
        onClick()
        return true
    }

    override var intrinsicContentSize: NSSize { NSSize(width: Self.size, height: Self.size) }

    override func draw(_ dirtyRect: NSRect) {
        let circle = NSBezierPath(ovalIn: bounds)
        let hoverColor = kind == .close
            ? NSColor(srgbRed: 0.98, green: 0.36, blue: 0.34, alpha: 1)
            : NSColor(srgbRed: 0.95, green: 0.68, blue: 0.16, alpha: 1)
        (hovering ? hoverColor
                  : NSColor.black.withAlphaComponent(0.10)).setFill()
        circle.fill()

        let glyph = NSBezierPath()
        let inset = bounds.width * 0.32
        let r = bounds.insetBy(dx: inset, dy: inset)
        if kind == .close {
            glyph.move(to: NSPoint(x: r.minX, y: r.minY))
            glyph.line(to: NSPoint(x: r.maxX, y: r.maxY))
            glyph.move(to: NSPoint(x: r.minX, y: r.maxY))
            glyph.line(to: NSPoint(x: r.maxX, y: r.minY))
        } else {
            glyph.move(to: NSPoint(x: r.minX, y: r.midY))
            glyph.line(to: NSPoint(x: r.maxX, y: r.midY))
        }
        glyph.lineWidth = 1.8
        glyph.lineCapStyle = .round
        (hovering ? NSColor.white : NSColor.black.withAlphaComponent(0.55)).setStroke()
        glyph.stroke()
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)
        addTrackingArea(NSTrackingArea(rect: bounds,
                                       options: [.mouseEnteredAndExited, .activeAlways],
                                       owner: self))
    }

    override func mouseEntered(with event: NSEvent) { hovering = true; needsDisplay = true }
    override func mouseExited(with event: NSEvent) { hovering = false; needsDisplay = true }
    override func mouseDown(with event: NSEvent) {}
    override func mouseUp(with event: NSEvent) {
        if bounds.contains(convert(event.locationInWindow, from: nil)) { onClick() }
    }
}

/// Bottom-right resize grip, sized to be grabbable without aiming.
final class ResizeGrip: NSView {
    static let size: CGFloat = 22
    private var origin = NSPoint.zero
    private var startFrame = NSRect.zero

    override var intrinsicContentSize: NSSize { NSSize(width: Self.size, height: Self.size) }

    override func draw(_ dirtyRect: NSRect) {
        NSColor.black.withAlphaComponent(0.28).setStroke()
        for offset in stride(from: CGFloat(5), through: 15, by: 5) {
            let path = NSBezierPath()
            path.move(to: NSPoint(x: bounds.maxX - offset, y: bounds.minY + 3))
            path.line(to: NSPoint(x: bounds.maxX - 3, y: bounds.minY + offset))
            path.lineWidth = 1.5
            path.lineCapStyle = .round
            path.stroke()
        }
    }

    override func resetCursorRects() {
        addCursorRect(bounds, cursor: .crosshair)
    }

    override func mouseDown(with event: NSEvent) {
        origin = NSEvent.mouseLocation
        startFrame = window?.frame ?? .zero
    }

    override func mouseDragged(with event: NSEvent) {
        guard let window else { return }
        let now = NSEvent.mouseLocation
        var frame = startFrame
        frame.size.width = max(220, startFrame.width + now.x - origin.x)
        frame.size.height = max(160, startFrame.height - (now.y - origin.y))
        frame.origin.y = startFrame.maxY - frame.height
        window.setFrame(frame, display: true)
    }
}
