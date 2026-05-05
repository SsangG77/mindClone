import SwiftUI

struct TemplateGuideOverlay: View {
    let template: Template
    let size: CGSize

    private let guideColor = MCColor.pencilFallback.opacity(0.55)
    private let labelColor = MCColor.pencilFallback.opacity(0.8)
    private let labelFont = MCFont.caption

    var body: some View {
        Group {
            switch template.id {
            case "cornell":
                cornellGuide
            case "musk_timeblock":
                muskTimeBlockGuide
            case "feynman":
                feynmanGuide
            case "gtd":
                gtdGuide
            case "eisenhower":
                eisenhowerGuide
            case "davinci":
                davinciGuide
            case "franklin":
                franklinGuide
            case "buffett":
                buffettGuide
            case "thinkweek":
                thinkWeekGuide
            case "zettelkasten":
                zettelkastenGuide
            case "threecircle":
                threeCircleGuide
            case "bulletjournal":
                bulletJournalGuide
            case "para":
                paraGuide
            default:
                defaultGuide
            }
        }
        .allowsHitTesting(false)
    }

    // MARK: - Cornell (L자)
    private var cornellGuide: some View {
        let cueWidth = size.width * 0.3
        let summaryHeight = size.height * 0.2
        let s = template.sections
        return ZStack(alignment: .topLeading) {
            // 세로선 (Cue | Notes 구분)
            Path { p in
                p.move(to: CGPoint(x: cueWidth, y: 0))
                p.addLine(to: CGPoint(x: cueWidth, y: size.height - summaryHeight))
            }
            .stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

            // 가로선 (Summary 구분)
            Path { p in
                p.move(to: CGPoint(x: 0, y: size.height - summaryHeight))
                p.addLine(to: CGPoint(x: size.width, y: size.height - summaryHeight))
            }
            .stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

            // 레이블
            Text(s[0].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: cueWidth / 2, y: 16)
            Text(s[1].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: cueWidth + (size.width - cueWidth) / 2, y: 16)
            Text(s[2].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: size.width / 2, y: size.height - summaryHeight + 16)
        }
    }

    // MARK: - Musk Time Block
    private var muskTimeBlockGuide: some View {
        let divX = size.width * 0.4
        let labels = ["8","9","10","11","12","1","2","3","4","5"]
        let rightW = size.width - divX
        let timeColMid = divX + 30 + (rightW - 30) / 2
        let rowH = (size.height - 30) / CGFloat(labels.count)
        return ZStack(alignment: .topLeading) {
            // 좌우 분할
            Path { p in
                p.move(to: CGPoint(x: divX, y: 0))
                p.addLine(to: CGPoint(x: divX, y: size.height))
            }.stroke(guideColor, lineWidth: 1)

            // 왼쪽 레이블
            Text("Top Priorities").font(labelFont).foregroundStyle(labelColor)
                .position(x: divX / 2, y: 14)

            // Priority 줄 3개
            ForEach(0..<3) { i in
                let y = CGFloat(40 + i * 72)
                Path { p in
                    p.move(to: CGPoint(x: 16, y: y))
                    p.addLine(to: CGPoint(x: divX - 16, y: y))
                }.stroke(guideColor, style: StrokeStyle(lineWidth: 0.5, dash: [4, 3]))
            }

            Text("Brain Dump").font(labelFont).foregroundStyle(labelColor)
                .position(x: divX / 2, y: 268)

            // 오른쪽: :00 :30 헤더
            Text(":00").font(labelFont).foregroundStyle(labelColor)
                .position(x: divX + 30 + (rightW - 30) * 0.25, y: 10)
            Text(":30").font(labelFont).foregroundStyle(labelColor)
                .position(x: divX + 30 + (rightW - 30) * 0.75, y: 10)

            // :00/:30 세로 구분
            Path { p in
                p.move(to: CGPoint(x: timeColMid, y: 24))
                p.addLine(to: CGPoint(x: timeColMid, y: size.height))
            }.stroke(guideColor, style: StrokeStyle(lineWidth: 0.5, dash: [4, 3]))

            // 시간 행
            ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                let y = 24 + rowH * CGFloat(index)
                Path { p in
                    p.move(to: CGPoint(x: divX, y: y))
                    p.addLine(to: CGPoint(x: size.width, y: y))
                }.stroke(guideColor, lineWidth: 0.5)

                Text(label).font(labelFont).foregroundStyle(labelColor)
                    .position(x: divX + 15, y: y + rowH / 2)
            }
        }
    }

    // MARK: - Feynman (4단계)
    private var feynmanGuide: some View {
        let s = template.sections
        let stepH = size.height * 0.25
        return ZStack(alignment: .topLeading) {
            ForEach(0..<4) { i in
                let y = stepH * CGFloat(i)
                if i > 0 {
                    Path { p in
                        p.move(to: CGPoint(x: 0, y: y))
                        p.addLine(to: CGPoint(x: size.width, y: y))
                    }
                    .stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
                }
                Text("Step \(i+1): \(s[i].title)").font(labelFont).foregroundStyle(labelColor)
                    .position(x: size.width / 2, y: y + 14)
            }
            // 반복 화살표
            Image(systemName: "arrow.uturn.left")
                .font(.system(size: 14))
                .foregroundStyle(MCColor.eraserFallback.opacity(0.6))
                .position(x: size.width - 30, y: stepH * 3.5)
        }
    }

    // MARK: - GTD (4칸 가로)
    private var gtdGuide: some View {
        let s = template.sections
        let colW = size.width / 4
        return ZStack(alignment: .topLeading) {
            ForEach(1..<4) { i in
                Path { p in
                    p.move(to: CGPoint(x: colW * CGFloat(i), y: 0))
                    p.addLine(to: CGPoint(x: colW * CGFloat(i), y: size.height))
                }
                .stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
            }
            ForEach(0..<4) { i in
                Text(s[i].title).font(labelFont).foregroundStyle(labelColor)
                    .frame(width: colW - 8)
                    .position(x: colW * CGFloat(i) + colW / 2, y: 14)
            }
            // 화살표
            ForEach(0..<3) { i in
                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                    .foregroundStyle(guideColor)
                    .position(x: colW * CGFloat(i + 1), y: size.height / 2)
            }
        }
    }

    // MARK: - Eisenhower (2x2)
    private var eisenhowerGuide: some View {
        let s = template.sections
        let midX = size.width / 2
        let midY = size.height / 2
        return ZStack {
            // 십자선
            Path { p in
                p.move(to: CGPoint(x: midX, y: 0))
                p.addLine(to: CGPoint(x: midX, y: size.height))
            }.stroke(guideColor, lineWidth: 1.5)
            Path { p in
                p.move(to: CGPoint(x: 0, y: midY))
                p.addLine(to: CGPoint(x: size.width, y: midY))
            }.stroke(guideColor, lineWidth: 1.5)

            // 축 레이블
            Text("긴급").font(labelFont).foregroundStyle(MCColor.eraserFallback.opacity(0.75))
                .position(x: midX / 2, y: 12)
            Text("비긴급").font(labelFont).foregroundStyle(labelColor)
                .position(x: midX + midX / 2, y: 12)
            Text("중요").font(labelFont).foregroundStyle(MCColor.eraserFallback.opacity(0.75))
                .position(x: 16, y: midY / 2)
            Text("비중요").font(labelFont).foregroundStyle(labelColor)
                .position(x: 20, y: midY + midY / 2)

            // 사분면 레이블
            Text(s[0].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: midX / 2, y: 30)
            Text(s[1].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: midX + midX / 2, y: 30)
            Text(s[2].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: midX / 2, y: midY + 16)
            Text(s[3].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: midX + midX / 2, y: midY + 16)
        }
    }

    // MARK: - Da Vinci (2/3 + 1/3)
    private var davinciGuide: some View {
        let s = template.sections
        let divX = size.width * 0.65
        return ZStack(alignment: .topLeading) {
            Path { p in
                p.move(to: CGPoint(x: divX, y: 0))
                p.addLine(to: CGPoint(x: divX, y: size.height))
            }.stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

            Path { p in
                p.move(to: CGPoint(x: divX, y: size.height / 2))
                p.addLine(to: CGPoint(x: size.width, y: size.height / 2))
            }.stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

            Text(s[0].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: divX / 2, y: 14)
            Text(s[1].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: divX + (size.width - divX) / 2, y: 14)
            Text(s[2].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: divX + (size.width - divX) / 2, y: size.height / 2 + 14)
        }
    }


    // MARK: - Franklin (요일 그리드)
    private var franklinGuide: some View {
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        let headerH: CGFloat = 50
        let footerH: CGFloat = size.height * 0.15
        let gridH = size.height - headerH - footerH
        let colW = size.width / 7
        return ZStack(alignment: .topLeading) {
            // 헤더 구분
            Path { p in
                p.move(to: CGPoint(x: 0, y: headerH))
                p.addLine(to: CGPoint(x: size.width, y: headerH))
            }.stroke(guideColor, lineWidth: 1)

            Text("이번 주 덕목").font(labelFont).foregroundStyle(labelColor)
                .position(x: size.width / 2, y: headerH / 2)

            // 요일 칼럼
            ForEach(0..<7) { i in
                if i > 0 {
                    Path { p in
                        p.move(to: CGPoint(x: colW * CGFloat(i), y: headerH))
                        p.addLine(to: CGPoint(x: colW * CGFloat(i), y: headerH + gridH))
                    }.stroke(guideColor, style: StrokeStyle(lineWidth: 0.5, dash: [4, 3]))
                }
                Text(days[i]).font(labelFont).foregroundStyle(labelColor)
                    .position(x: colW * CGFloat(i) + colW / 2, y: headerH + 14)
            }

            // 푸터 구분
            Path { p in
                p.move(to: CGPoint(x: 0, y: headerH + gridH))
                p.addLine(to: CGPoint(x: size.width, y: headerH + gridH))
            }.stroke(guideColor, lineWidth: 1)

            Text("반성 & 개선").font(labelFont).foregroundStyle(labelColor)
                .position(x: size.width / 2, y: headerH + gridH + 14)
        }
    }

    // MARK: - Buffett (두 칼럼)
    private var buffettGuide: some View {
        let s = template.sections
        let midX = size.width / 2
        return ZStack(alignment: .topLeading) {
            Path { p in
                p.move(to: CGPoint(x: midX, y: 0))
                p.addLine(to: CGPoint(x: midX, y: size.height))
            }.stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

            Path { p in
                p.move(to: CGPoint(x: midX, y: size.height / 2))
                p.addLine(to: CGPoint(x: size.width, y: size.height / 2))
            }.stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

            Text(s[0].title).font(labelFont).foregroundStyle(labelColor)
                .position(x: midX / 2, y: 14)
            Text(s[1].title).font(labelFont).foregroundStyle(MCColor.highlightFallback.opacity(0.6))
                .position(x: midX + midX / 2, y: 14)
            Text(s[2].title).font(labelFont).foregroundStyle(MCColor.eraserFallback.opacity(0.75))
                .position(x: midX + midX / 2, y: size.height / 2 + 14)
        }
    }

    // MARK: - Think Week
    private var thinkWeekGuide: some View {
        let s = template.sections
        let midX = size.width / 2
        return ZStack(alignment: .topLeading) {
            Path { p in
                p.move(to: CGPoint(x: midX, y: 0))
                p.addLine(to: CGPoint(x: midX, y: size.height))
            }.stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

            Path { p in
                p.move(to: CGPoint(x: midX, y: size.height * 0.5))
                p.addLine(to: CGPoint(x: size.width, y: size.height * 0.5))
            }.stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

            Text(s[0].title).font(labelFont).foregroundStyle(labelColor).position(x: midX / 2, y: 14)
            Text(s[1].title).font(labelFont).foregroundStyle(labelColor).position(x: midX + midX / 2, y: 14)
            Text(s[2].title).font(labelFont).foregroundStyle(labelColor).position(x: midX + midX / 2, y: size.height * 0.5 + 14)
        }
    }

    // MARK: - Zettelkasten (카드)
    private var zettelkastenGuide: some View {
        let s = template.sections
        return ZStack(alignment: .topLeading) {
            let h1: CGFloat = 50
            let h2 = size.height * 0.2
            let h3 = size.height * 0.5
            let h4 = size.height * 0.75

            ForEach([h1, h2, h3, h4], id: \.self) { y in
                Path { p in
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: size.width, y: y))
                }.stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
            }

            Text(s[3].title).font(labelFont).foregroundStyle(labelColor).position(x: size.width / 2, y: h1 / 2)
            Text(s[0].title).font(labelFont).foregroundStyle(labelColor).position(x: size.width / 2, y: h1 + (h2 - h1) / 2)
            Text(s[1].title).font(labelFont).foregroundStyle(labelColor).position(x: size.width / 2, y: h2 + (h3 - h2) / 2)
            Text(s[2].title).font(labelFont).foregroundStyle(labelColor).position(x: size.width / 2, y: h3 + (h4 - h3) / 2)
        }
    }

    // MARK: - 3-Circle (벤 다이어그램)
    private var threeCircleGuide: some View {
        let cx = size.width / 2
        let cy = size.height * 0.4
        let r = min(size.width, size.height) * 0.22
        let s = template.sections
        return ZStack {
            Circle().stroke(Color.blue.opacity(0.5), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .frame(width: r * 2, height: r * 2).position(x: cx, y: cy - r * 0.5)
            Circle().stroke(Color.green.opacity(0.5), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .frame(width: r * 2, height: r * 2).position(x: cx - r * 0.7, y: cy + r * 0.5)
            Circle().stroke(MCColor.eraserFallback.opacity(0.5), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .frame(width: r * 2, height: r * 2).position(x: cx + r * 0.7, y: cy + r * 0.5)

            Text(s[0].title).font(labelFont).foregroundStyle(Color.blue.opacity(0.75)).position(x: cx, y: cy - r * 1.2)
            Text(s[1].title).font(labelFont).foregroundStyle(Color.green.opacity(0.75)).position(x: cx - r * 1.5, y: cy + r)
            Text(s[2].title).font(labelFont).foregroundStyle(MCColor.eraserFallback.opacity(0.75)).position(x: cx + r * 1.5, y: cy + r)
            Text(s[3].title).font(labelFont).foregroundStyle(MCColor.highlightFallback.opacity(0.75)).position(x: cx, y: cy)
        }
    }

    // MARK: - Bullet Journal (3칼럼)
    private var bulletJournalGuide: some View {
        let s = template.sections
        let colW = size.width / 3
        let footerH = size.height * 0.2
        return ZStack(alignment: .topLeading) {
            ForEach(1..<3) { i in
                Path { p in
                    p.move(to: CGPoint(x: colW * CGFloat(i), y: 0))
                    p.addLine(to: CGPoint(x: colW * CGFloat(i), y: size.height - footerH))
                }.stroke(guideColor, style: StrokeStyle(lineWidth: 0.5, dash: [4, 3]))
            }
            Path { p in
                p.move(to: CGPoint(x: 0, y: size.height - footerH))
                p.addLine(to: CGPoint(x: size.width, y: size.height - footerH))
            }.stroke(guideColor, lineWidth: 1)

            Text("· Tasks").font(labelFont).foregroundStyle(labelColor).position(x: colW / 2, y: 14)
            Text("○ Events").font(labelFont).foregroundStyle(labelColor).position(x: colW * 1.5, y: 14)
            Text("— Notes").font(labelFont).foregroundStyle(labelColor).position(x: colW * 2.5, y: 14)
            Text(s[3].title).font(labelFont).foregroundStyle(labelColor).position(x: size.width / 2, y: size.height - footerH + 14)
        }
    }

    // MARK: - PARA (2x2)
    private var paraGuide: some View {
        let s = template.sections
        let midX = size.width / 2
        let midY = size.height / 2
        return ZStack {
            Path { p in
                p.move(to: CGPoint(x: midX, y: 0)); p.addLine(to: CGPoint(x: midX, y: size.height))
            }.stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
            Path { p in
                p.move(to: CGPoint(x: 0, y: midY)); p.addLine(to: CGPoint(x: size.width, y: midY))
            }.stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

            Text(s[0].title).font(labelFont).foregroundStyle(Color.blue.opacity(0.75)).position(x: midX / 2, y: 14)
            Text(s[1].title).font(labelFont).foregroundStyle(Color.green.opacity(0.75)).position(x: midX + midX / 2, y: 14)
            Text(s[2].title).font(labelFont).foregroundStyle(Color.orange.opacity(0.75)).position(x: midX / 2, y: midY + 14)
            Text(s[3].title).font(labelFont).foregroundStyle(Color.gray.opacity(0.75)).position(x: midX + midX / 2, y: midY + 14)
        }
    }

    // MARK: - 기본 (가로 줄)
    private var defaultGuide: some View {
        let s = template.sections
        var offsets: [CGFloat] = []
        var y: CGFloat = 0
        return ZStack(alignment: .topLeading) {
            ForEach(Array(s.enumerated()), id: \.offset) { index, section in
                let sectionY = size.height * s.prefix(index).map(\.heightRatio).reduce(0, +)
                Group {
                    if index > 0 {
                        Path { p in
                            p.move(to: CGPoint(x: 0, y: sectionY))
                            p.addLine(to: CGPoint(x: size.width, y: sectionY))
                        }.stroke(guideColor, style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
                    }
                    Text(section.title).font(labelFont).foregroundStyle(labelColor)
                        .position(x: size.width / 2, y: sectionY + 14)
                }
            }
        }
    }
}
