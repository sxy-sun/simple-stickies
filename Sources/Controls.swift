import AppKit

/// Big round close button — the whole point is that it's easy to hit.
final class CloseButton: NSView {
    static let size: CGFloat = 24
    var onClick: () -> Void = {}
    private var hovering = false

    override var intrinsicContentSize: NSSize { NSSize(width: Self.size, height: Self.size) }

    override func draw(_ dirtyRect: NSRect) {
        let circle = NSBezierPath(ovalIn: bounds)
        (hovering ? NSColor(srgbRed: 0.98, green: 0.36, blue: 0.34, alpha: 1)
                  : NSColor.black.withAlphaComponent(0.10)).setFill()
        circle.fill()

        let glyph = NSBezierPath()
        let inset = bounds.width * 0.32
        let r = bounds.insetBy(dx: inset, dy: inset)
        glyph.move(to: NSPoint(x: r.minX, y: r.minY))
        glyph.line(to: NSPoint(x: r.maxX, y: r.maxY))
        glyph.move(to: NSPoint(x: r.minX, y: r.maxY))
        glyph.line(to: NSPoint(x: r.maxX, y: r.minY))
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
