import SwiftUI

enum MCFont {
    static func hand(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        // 커스텀 손글씨 폰트가 번들에 있으면 사용, 없으면 시스템 rounded
        if let _ = UIFont(name: "NanumSonGulSsi-Regular", size: size) {
            return .custom("NanumSonGulSsi-Regular", size: size)
        }
        return .system(size: size, weight: weight, design: .rounded)
    }

    static let largeTitle = hand(34, weight: .bold)
    static let title = hand(28, weight: .bold)
    static let title2 = hand(22, weight: .bold)
    static let title3 = hand(20, weight: .semibold)
    static let headline = hand(17, weight: .semibold)
    static let body = hand(17)
    static let subheadline = hand(15)
    static let caption = hand(13)
    static let caption2 = hand(11)
}

enum MCColor {
    static let paper = Color("Paper", bundle: nil)
    static let paperDark = Color("PaperDark", bundle: nil)
    static let ink = Color("Ink", bundle: nil)
    static let inkLight = Color("InkLight", bundle: nil)
    static let pencil = Color("Pencil", bundle: nil)
    static let highlight = Color("Highlight", bundle: nil)
    static let eraser = Color("Eraser", bundle: nil)

    // 폴백 색상 (Color Set 미생성 시)
    static let paperFallback = Color(red: 0.98, green: 0.96, blue: 0.91)        // 크림색 종이
    static let paperDarkFallback = Color(red: 0.94, green: 0.91, blue: 0.85)    // 진한 종이
    static let inkFallback = Color(red: 0.20, green: 0.18, blue: 0.15)          // 잉크 검정
    static let inkLightFallback = Color(red: 0.45, green: 0.42, blue: 0.38)     // 연한 잉크
    static let pencilFallback = Color(red: 0.55, green: 0.50, blue: 0.45)       // 연필색
    static let highlightFallback = Color(red: 0.95, green: 0.80, blue: 0.35)    // 형광펜 노랑
    static let eraserFallback = Color(red: 0.85, green: 0.55, blue: 0.50)       // 지우개 빨강
}

// MARK: - 손으로 그린 듯한 테두리 Shape
struct SketchyRoundedRect: Shape {
    var cornerRadius: CGFloat
    var wobble: CGFloat

    init(cornerRadius: CGFloat = 12, wobble: CGFloat = 2) {
        self.cornerRadius = cornerRadius
        self.wobble = wobble
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = wobble
        let cr = cornerRadius

        path.move(to: CGPoint(x: rect.minX + cr, y: rect.minY + w * 0.5))

        // Top edge
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY - w * 0.3))
        path.addLine(to: CGPoint(x: rect.maxX - cr, y: rect.minY + w * 0.4))

        // Top-right corner
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - w * 0.3, y: rect.minY + cr),
            control: CGPoint(x: rect.maxX + w * 0.2, y: rect.minY - w * 0.2)
        )

        // Right edge
        path.addLine(to: CGPoint(x: rect.maxX + w * 0.2, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - w * 0.3, y: rect.maxY - cr))

        // Bottom-right corner
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - cr, y: rect.maxY - w * 0.4),
            control: CGPoint(x: rect.maxX + w * 0.1, y: rect.maxY + w * 0.2)
        )

        // Bottom edge
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY + w * 0.3))
        path.addLine(to: CGPoint(x: rect.minX + cr, y: rect.maxY - w * 0.5))

        // Bottom-left corner
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + w * 0.3, y: rect.maxY - cr),
            control: CGPoint(x: rect.minX - w * 0.2, y: rect.maxY + w * 0.1)
        )

        // Left edge
        path.addLine(to: CGPoint(x: rect.minX - w * 0.2, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX + w * 0.4, y: rect.minY + cr))

        // Top-left corner
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + cr, y: rect.minY + w * 0.5),
            control: CGPoint(x: rect.minX - w * 0.1, y: rect.minY - w * 0.2)
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - 손그림 밑줄
struct SketchyUnderline: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let y = rect.maxY
        path.move(to: CGPoint(x: rect.minX, y: y))
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: y - 1),
            control1: CGPoint(x: rect.width * 0.3, y: y - 3),
            control2: CGPoint(x: rect.width * 0.7, y: y + 2)
        )
        return path
    }
}

// MARK: - View Modifiers
struct PaperBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(MCColor.paperFallback)
    }
}

struct SketchyCard: ViewModifier {
    var wobble: CGFloat = 2

    func body(content: Content) -> some View {
        content
            .background(MCColor.paperFallback)
            .clipShape(SketchyRoundedRect(cornerRadius: 12, wobble: wobble))
            .overlay(
                SketchyRoundedRect(cornerRadius: 12, wobble: wobble)
                    .stroke(MCColor.inkFallback.opacity(0.3), lineWidth: 1.5)
            )
    }
}

struct SketchyButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(MCFont.headline)
            .foregroundStyle(MCColor.paperFallback)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(MCColor.inkFallback)
            .clipShape(SketchyRoundedRect(cornerRadius: 14, wobble: 3))
    }
}

extension View {
    func paperBackground() -> some View {
        modifier(PaperBackground())
    }

    func sketchyCard(wobble: CGFloat = 2) -> some View {
        modifier(SketchyCard(wobble: wobble))
    }

    func sketchyButton() -> some View {
        modifier(SketchyButton())
    }
}

// MARK: - 종이 패턴 배경
struct PaperPatternBackground: View {
    var body: some View {
        Canvas { context, size in
            // 종이 기본 색
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(MCColor.paperFallback)
            )
            // 약간의 노이즈 점 (종이 질감)
            for _ in 0..<Int(size.width * size.height / 800) {
                let x = CGFloat.random(in: 0...size.width)
                let y = CGFloat.random(in: 0...size.height)
                let dotSize = CGFloat.random(in: 0.5...1.5)
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: dotSize, height: dotSize)),
                    with: .color(MCColor.inkFallback.opacity(Double.random(in: 0.02...0.06)))
                )
            }
            // 가로 줄 (노트 줄)
            let lineSpacing: CGFloat = 32
            var y: CGFloat = lineSpacing
            while y < size.height {
                var linePath = Path()
                linePath.move(to: CGPoint(x: 20, y: y))
                // 약간 흔들리는 직선
                let segments = 8
                let segWidth = (size.width - 40) / CGFloat(segments)
                for i in 1...segments {
                    let px = 20 + segWidth * CGFloat(i)
                    let py = y + CGFloat.random(in: -0.5...0.5)
                    linePath.addLine(to: CGPoint(x: px, y: py))
                }
                context.stroke(linePath, with: .color(MCColor.inkFallback.opacity(0.08)), lineWidth: 0.5)
                y += lineSpacing
            }
        }
        .ignoresSafeArea()
    }
}
