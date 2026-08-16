import AppKit

/// Live markdown styling applied directly to the editor's text storage.
/// Markers stay in the text but fade out, so there is no edit/preview mode.
enum MD {
    static let base = NSFont.systemFont(ofSize: 14)
    static let ink = NSColor.black.withAlphaComponent(0.86)
    static let soft = NSColor.black.withAlphaComponent(0.5)
    static let faint = NSColor.black.withAlphaComponent(0.22)
    static let accent = NSColor(srgbRed: 0.85, green: 0.44, blue: 0.16, alpha: 1)
    static let linkColor = NSColor(srgbRed: 0.13, green: 0.42, blue: 0.85, alpha: 1)

    static var paragraph: NSParagraphStyle = {
        let p = NSMutableParagraphStyle()
        p.lineSpacing = 3
        p.paragraphSpacing = 3
        return p
    }()

    static var defaults: [NSAttributedString.Key: Any] {
        [.font: base, .foregroundColor: ink, .paragraphStyle: paragraph]
    }

    private static func rx(_ pattern: String) -> NSRegularExpression {
        try! NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines])
    }

    private static let heading = rx("^(#{1,3})[ \t]+(.+)$")
    private static let bullet = rx("^([ \t]*)([-*+]|\\d+\\.)[ \t]+")
    private static let quote = rx("^([ \t]*>[ \t]?)(.*)$")
    private static let rule = rx("^(-{3,}|\\*{3,})[ \t]*$")
    private static let bold = rx("\\*\\*([^*\n]+)\\*\\*")
    private static let italic = rx("(?<![*\\w])\\*([^*\n]+)\\*(?![*\\w])")
    private static let strike = rx("~~([^~\n]+)~~")
    private static let code = rx("`([^`\n]+)`")
    private static let link = rx("\\[([^\\]\n]+)\\]\\(([^)\n]+)\\)")

    static func apply(to ts: NSTextStorage) {
        let text = ts.string
        let full = NSRange(location: 0, length: ts.length)
        ts.beginEditing()
        ts.setAttributes(defaults, range: full)

        heading.enumerateMatches(in: text, range: full) { m, _, _ in
            guard let m else { return }
            let sizes: [CGFloat] = [22, 18, 16]
            let font = NSFont.systemFont(ofSize: sizes[m.range(at: 1).length - 1], weight: .semibold)
            ts.addAttribute(.font, value: font, range: m.range)
            ts.addAttribute(.foregroundColor, value: faint, range: m.range(at: 1))
        }

        bullet.enumerateMatches(in: text, range: full) { m, _, _ in
            guard let m else { return }
            ts.addAttribute(.foregroundColor, value: accent, range: m.range(at: 2))
        }

        quote.enumerateMatches(in: text, range: full) { m, _, _ in
            guard let m else { return }
            ts.addAttribute(.foregroundColor, value: soft, range: m.range)
            ts.addAttribute(.foregroundColor, value: faint, range: m.range(at: 1))
            addTrait(.italicFontMask, ts, m.range(at: 2))
        }

        rule.enumerateMatches(in: text, range: full) { m, _, _ in
            guard let m else { return }
            ts.addAttribute(.foregroundColor, value: faint, range: m.range)
        }

        bold.enumerateMatches(in: text, range: full) { m, _, _ in
            guard let m else { return }
            addTrait(.boldFontMask, ts, m.range(at: 1))
            dimMarkers(ts, m.range, m.range(at: 1))
        }

        italic.enumerateMatches(in: text, range: full) { m, _, _ in
            guard let m else { return }
            addTrait(.italicFontMask, ts, m.range(at: 1))
            dimMarkers(ts, m.range, m.range(at: 1))
        }

        strike.enumerateMatches(in: text, range: full) { m, _, _ in
            guard let m else { return }
            ts.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: m.range(at: 1))
            ts.addAttribute(.foregroundColor, value: soft, range: m.range(at: 1))
            dimMarkers(ts, m.range, m.range(at: 1))
        }

        code.enumerateMatches(in: text, range: full) { m, _, _ in
            guard let m else { return }
            let inner = m.range(at: 1)
            ts.addAttribute(.font, value: NSFont.monospacedSystemFont(ofSize: 13, weight: .regular), range: inner)
            ts.addAttribute(.foregroundColor, value: accent, range: inner)
            ts.addAttribute(.backgroundColor, value: NSColor.black.withAlphaComponent(0.05), range: inner)
            dimMarkers(ts, m.range, inner)
        }

        link.enumerateMatches(in: text, range: full) { m, _, _ in
            guard let m else { return }
            ts.addAttribute(.foregroundColor, value: faint, range: m.range)
            ts.addAttribute(.foregroundColor, value: linkColor, range: m.range(at: 1))
        }

        ts.endEditing()
    }

    private static func addTrait(_ trait: NSFontTraitMask, _ ts: NSTextStorage, _ range: NSRange) {
        ts.enumerateAttribute(.font, in: range) { value, sub, _ in
            let font = (value as? NSFont) ?? base
            ts.addAttribute(.font, value: NSFontManager.shared.convert(font, toHaveTrait: trait), range: sub)
        }
    }

    /// Fade the syntax characters surrounding `inner` inside `whole`.
    private static func dimMarkers(_ ts: NSTextStorage, _ whole: NSRange, _ inner: NSRange) {
        let lead = NSRange(location: whole.location, length: inner.location - whole.location)
        let trail = NSRange(location: inner.upperBound, length: whole.upperBound - inner.upperBound)
        ts.addAttribute(.foregroundColor, value: faint, range: lead)
        ts.addAttribute(.foregroundColor, value: faint, range: trail)
    }
}
