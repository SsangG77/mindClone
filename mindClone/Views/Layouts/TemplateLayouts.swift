import SwiftUI

// MARK: - 공통 섹션 입력 뷰
struct SectionEditor: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(MCFont.caption)
                .fontWeight(.bold)
                .foregroundStyle(MCColor.inkFallback)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .font(MCFont.body)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(MCColor.paperDarkFallback.opacity(0.4))
                    .clipShape(SketchyRoundedRect(cornerRadius: 8, wobble: 1))
                    .overlay(
                        SketchyRoundedRect(cornerRadius: 8, wobble: 1)
                            .stroke(MCColor.inkFallback.opacity(0.12), lineWidth: 1)
                    )

                if text.isEmpty {
                    Text(placeholder)
                        .font(MCFont.body)
                        .foregroundStyle(MCColor.pencilFallback.opacity(0.7))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }
            }
        }
    }
}

// MARK: - 화살표 구분선
struct ArrowDivider: View {
    var direction: Direction = .down

    enum Direction {
        case down, right
    }

    var body: some View {
        switch direction {
        case .down:
            VStack(spacing: 0) {
                Rectangle()
                    .fill(MCColor.pencilFallback.opacity(0.3))
                    .frame(width: 2, height: 16)
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(MCColor.pencilFallback.opacity(0.7))
            }
        case .right:
            HStack(spacing: 0) {
                Rectangle()
                    .fill(MCColor.pencilFallback.opacity(0.3))
                    .frame(width: 16, height: 2)
                Image(systemName: "arrowtriangle.right.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(MCColor.pencilFallback.opacity(0.7))
            }
        }
    }
}

// MARK: - 레이아웃 디스패처
struct TemplateTypingLayout: View {
    let template: Template
    @Binding var textContents: [String: String]

    private func binding(_ key: String) -> Binding<String> {
        Binding(
            get: { textContents[key, default: ""] },
            set: { textContents[key] = $0 }
        )
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                Group {
                    switch template.id {
                    case "cornell":
                        cornellLayout(geo: geo)
                    case "musk_timeblock":
                        muskTimeBlockLayout(geo: geo)
                    case "feynman":
                        feynmanLayout(geo: geo)
                    case "gtd":
                        gtdFlowLayout(geo: geo)
                    case "eisenhower":
                        matrixLayout(geo: geo)
                    case "davinci":
                        davinciLayout(geo: geo)
                    case "franklin":
                        franklinLayout(geo: geo)
                    case "buffett":
                        buffettLayout(geo: geo)
                    case "thinkweek":
                        thinkWeekLayout(geo: geo)
                    case "zettelkasten":
                        zettelkastenLayout(geo: geo)
                    case "threecircle":
                        threeCircleLayout(geo: geo)
                    case "bulletjournal":
                        bulletJournalLayout(geo: geo)
                    case "para":
                        paraLayout(geo: geo)
                    default:
                        defaultLayout(geo: geo)
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Cornell Note (L자 레이아웃)
    // ┌─────────┬────────────────┐
    // │  Cue    │   Notes        │
    // │  (30%)  │   (70%)        │
    // ├─────────┴────────────────┤
    // │  Summary                 │
    // └──────────────────────────┘
    private func cornellLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        return VStack(spacing: 0) {
            HStack(spacing: 0) {
                SectionEditor(title: s[0].title, placeholder: s[0].placeholder, text: binding("0"))
                    .frame(width: geo.size.width * 0.3 - 16)
                    .padding(8)

                Rectangle().fill(MCColor.inkFallback.opacity(0.15)).frame(width: 1.5)

                SectionEditor(title: s[1].title, placeholder: s[1].placeholder, text: binding("1"))
                    .padding(8)
            }
            .frame(minHeight: geo.size.height * 0.65)
            .sketchyCard(wobble: 1.5)

            Rectangle().fill(MCColor.inkFallback.opacity(0.15)).frame(height: 1.5)

            SectionEditor(title: s[2].title, placeholder: s[2].placeholder, text: binding("2"))
                .frame(minHeight: 120)
                .padding(8)
                .sketchyCard(wobble: 1.5)
        }
    }

    // MARK: - Musk Time Block
    // ┌──────────────┬──────────────────┐
    // │ Top Priorities│  :00   :30      │
    // │ [____]       │ 5 |____|____|   │
    // │ [____]       │ 6 |____|____|   │
    // │ [____]       │ ...             │
    // │              │ 11|____|____|   │
    // │ Brain Dump   │                  │
    // │ ____________ │                  │
    // │ ____________ │                  │
    // └──────────────┴──────────────────┘
    private func muskTimeBlockLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        return HStack(alignment: .top, spacing: 0) {
            // 왼쪽: Top Priorities + Brain Dump
            leftPanel(s: s, geo: geo)

            Rectangle().fill(MCColor.inkFallback.opacity(0.15)).frame(width: 1.5)

            // 오른쪽: Time Block 스케줄
            timeBlockPanel(geo: geo)
        }
    }

    private func leftPanel(s: [TemplateSection], geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Top Priorities
            VStack(alignment: .leading, spacing: 8) {
                Text("Top Priorities")
                    .font(MCFont.headline)
                    .foregroundStyle(MCColor.inkFallback)

                ForEach(0..<3) { i in
                    ZStack(alignment: .leading) {
                        TextEditor(text: binding("priority_\(i)"))
                            .font(MCFont.body)
                            .scrollContentBackground(.hidden)
                            .frame(height: 40)
                            .padding(.horizontal, 8)

                        if textContents["priority_\(i)", default: ""].isEmpty {
                            Text("\(i + 1).")
                                .font(MCFont.body)
                                .foregroundStyle(MCColor.pencilFallback.opacity(0.7))
                                .padding(.horizontal, 12)
                                .allowsHitTesting(false)
                        }
                    }
                    .background(MCColor.paperDarkFallback.opacity(0.3))
                    .clipShape(SketchyRoundedRect(cornerRadius: 6, wobble: 1))
                    .overlay(SketchyRoundedRect(cornerRadius: 6, wobble: 1).stroke(MCColor.inkFallback.opacity(0.15), lineWidth: 1))
                }
            }

            // Brain Dump
            SectionEditor(title: s[1].title, placeholder: s[1].placeholder, text: binding("1"))
                .frame(maxHeight: .infinity)
                .padding(8)
                .sketchyCard(wobble: 1.5)
        }
        .padding(10)
        .frame(width: geo.size.width * 0.4 - 16)
    }

    private func timeBlockPanel(geo: GeometryProxy) -> some View {
        let hours = [5,6,7,8,9,10,11,12,1,2,3,4,5,6,7,8,9,10,11]
        let labels = ["5","6","7","8","9","10","11","12","1","2","3","4","5","6","7","8","9","10","11"]
        return ScrollView {
            VStack(spacing: 0) {
                // 헤더
                HStack(spacing: 0) {
                    Text("")
                        .frame(width: 30)
                    Text(":00")
                        .font(MCFont.caption2)
                        .foregroundStyle(MCColor.inkFallback)
                        .frame(maxWidth: .infinity)
                    Text(":30")
                        .font(MCFont.caption2)
                        .foregroundStyle(MCColor.inkFallback)
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 4)

                // 시간 행
                ForEach(Array(labels.enumerated()), id: \.offset) { index, label in
                    HStack(spacing: 0) {
                        Text(label)
                            .font(MCFont.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(MCColor.inkFallback)
                            .frame(width: 30)

                        ZStack(alignment: .leading) {
                            TextEditor(text: binding("time_\(index)_00"))
                                .font(MCFont.caption)
                                .scrollContentBackground(.hidden)
                                .frame(height: 32)
                                .padding(.horizontal, 4)
                        }
                        .background(MCColor.paperDarkFallback.opacity(0.2))
                        .overlay(
                            Rectangle().stroke(MCColor.inkFallback.opacity(0.1), lineWidth: 0.5)
                        )

                        ZStack(alignment: .leading) {
                            TextEditor(text: binding("time_\(index)_30"))
                                .font(MCFont.caption)
                                .scrollContentBackground(.hidden)
                                .frame(height: 32)
                                .padding(.horizontal, 4)
                        }
                        .background(MCColor.paperDarkFallback.opacity(0.2))
                        .overlay(
                            Rectangle().stroke(MCColor.inkFallback.opacity(0.1), lineWidth: 0.5)
                        )
                    }
                }
            }
            .padding(10)
        }
    }

    // MARK: - Feynman (순환 단계)
    // 1 → 2 → 3 ↔ 4 (반복)
    private func feynmanLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        return VStack(spacing: 0) {
            // Step 1: 개념 선택 (상단 배너)
            SectionEditor(title: "① " + s[0].title, placeholder: s[0].placeholder, text: binding("0"))
                .frame(minHeight: 70)
                .padding(10)
                .sketchyCard(wobble: 1.5)

            ArrowDivider(direction: .down).padding(.vertical, 4)

            // Step 2: 쉽게 설명하기 (큰 영역)
            SectionEditor(title: "② " + s[1].title, placeholder: s[1].placeholder, text: binding("1"))
                .frame(minHeight: geo.size.height * 0.3)
                .padding(10)
                .sketchyCard(wobble: 1.5)

            ArrowDivider(direction: .down).padding(.vertical, 4)

            // Step 3 & 4: 나란히 (순환 표시)
            HStack(spacing: 12) {
                VStack(spacing: 0) {
                    SectionEditor(title: "③ " + s[2].title, placeholder: s[2].placeholder, text: binding("2"))
                        .frame(minHeight: geo.size.height * 0.25)
                        .padding(10)
                        .sketchyCard(wobble: 1.5)
                }

                VStack(spacing: 4) {
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundStyle(MCColor.eraserFallback)
                    Text("반복")
                        .font(MCFont.caption2)
                        .foregroundStyle(MCColor.eraserFallback)
                    Image(systemName: "arrow.left")
                        .font(.caption)
                        .foregroundStyle(MCColor.eraserFallback)
                }

                VStack(spacing: 0) {
                    SectionEditor(title: "④ " + s[3].title, placeholder: s[3].placeholder, text: binding("3"))
                        .frame(minHeight: geo.size.height * 0.25)
                        .padding(10)
                        .sketchyCard(wobble: 1.5)
                }
            }
        }
    }

    // MARK: - GTD (가로 플로우)
    // Capture → Clarify → Organize → Next Actions
    private func gtdFlowLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        let isWide = geo.size.width > 700

        return Group {
            if isWide {
                // iPad 가로: 수평 흐름
                HStack(spacing: 0) {
                    ForEach(Array(s.enumerated()), id: \.offset) { index, section in
                        SectionEditor(title: section.title, placeholder: section.placeholder, text: binding("\(index)"))
                            .padding(10)
                            .sketchyCard(wobble: 1.5)

                        if index < s.count - 1 {
                            ArrowDivider(direction: .right)
                                .padding(.horizontal, 4)
                        }
                    }
                }
                .frame(minHeight: geo.size.height * 0.7)
            } else {
                // 세로: 수직 흐름
                VStack(spacing: 0) {
                    ForEach(Array(s.enumerated()), id: \.offset) { index, section in
                        SectionEditor(title: section.title, placeholder: section.placeholder, text: binding("\(index)"))
                            .frame(minHeight: 120)
                            .padding(10)
                            .sketchyCard(wobble: 1.5)

                        if index < s.count - 1 {
                            ArrowDivider(direction: .down)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Eisenhower Matrix (2x2 격자)
    //          긴급        비긴급
    // 중요   [DO]        [PLAN]
    // 비중요 [DELEGATE]  [ELIMINATE]
    private func matrixLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        let cellH = max(160, (geo.size.height - 100) * 0.45)
        return VStack(spacing: 0) {
            // 축 레이블
            HStack {
                Spacer()
                Text("긴급")
                    .font(MCFont.caption)
                    .foregroundStyle(MCColor.eraserFallback)
                    .frame(maxWidth: .infinity)
                Text("비긴급")
                    .font(MCFont.caption)
                    .foregroundStyle(MCColor.pencilFallback)
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 4)

            HStack(spacing: 0) {
                // 왼쪽 축 레이블
                VStack {
                    Text("중\n요")
                        .font(MCFont.caption)
                        .foregroundStyle(MCColor.eraserFallback)
                        .frame(maxHeight: .infinity)
                    Text("비\n중\n요")
                        .font(MCFont.caption)
                        .foregroundStyle(MCColor.pencilFallback)
                        .frame(maxHeight: .infinity)
                }
                .frame(width: 20)

                // 2x2 격자
                VStack(spacing: 2) {
                    HStack(spacing: 2) {
                        SectionEditor(title: s[0].title, placeholder: s[0].placeholder, text: binding("0"))
                            .padding(8)
                            .frame(minHeight: cellH)
                            .background(MCColor.eraserFallback.opacity(0.08))
                            .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5))
                            .overlay(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5).stroke(MCColor.eraserFallback.opacity(0.3), lineWidth: 1))

                        SectionEditor(title: s[1].title, placeholder: s[1].placeholder, text: binding("1"))
                            .padding(8)
                            .frame(minHeight: cellH)
                            .background(MCColor.highlightFallback.opacity(0.1))
                            .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5))
                            .overlay(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5).stroke(MCColor.highlightFallback.opacity(0.3), lineWidth: 1))
                    }
                    HStack(spacing: 2) {
                        SectionEditor(title: s[2].title, placeholder: s[2].placeholder, text: binding("2"))
                            .padding(8)
                            .frame(minHeight: cellH)
                            .background(MCColor.pencilFallback.opacity(0.06))
                            .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5))
                            .overlay(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5).stroke(MCColor.pencilFallback.opacity(0.2), lineWidth: 1))

                        SectionEditor(title: s[3].title, placeholder: s[3].placeholder, text: binding("3"))
                            .padding(8)
                            .frame(minHeight: cellH)
                            .background(MCColor.inkFallback.opacity(0.04))
                            .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5))
                            .overlay(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5).stroke(MCColor.inkFallback.opacity(0.15), lineWidth: 1))
                    }
                }
            }
        }
    }

    // MARK: - Da Vinci (큰 스케치 + 사이드 메모)
    // ┌────────────────┬─────────┐
    // │  스케치 (2/3)  │ 메모    │
    // │                ├─────────┤
    // │                │ 발견    │
    // └────────────────┴─────────┘
    private func davinciLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        return HStack(spacing: 0) {
            SectionEditor(title: s[0].title, placeholder: s[0].placeholder, text: binding("0"))
                .padding(10)
                .frame(minHeight: geo.size.height * 0.75)
                .sketchyCard(wobble: 2)

            Rectangle().fill(MCColor.inkFallback.opacity(0.12)).frame(width: 1.5)

            VStack(spacing: 0) {
                SectionEditor(title: s[1].title, placeholder: s[1].placeholder, text: binding("1"))
                    .padding(10)
                    .sketchyCard(wobble: 1.5)

                Rectangle().fill(MCColor.inkFallback.opacity(0.12)).frame(height: 1.5)

                SectionEditor(title: s[2].title, placeholder: s[2].placeholder, text: binding("2"))
                    .padding(10)
                    .sketchyCard(wobble: 1.5)
            }
            .frame(width: geo.size.width * 0.35 - 16)
        }
    }


    // MARK: - Franklin (덕목 + 요일 그리드)
    // [이번 주 덕목]
    // [월][화][수][목][금][토][일]
    // [반성 & 개선]
    private func franklinLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        let days = ["월", "화", "수", "목", "금", "토", "일"]
        return VStack(spacing: 12) {
            // 덕목 헤더
            SectionEditor(title: s[0].title, placeholder: s[0].placeholder, text: binding("0"))
                .frame(minHeight: 60)
                .padding(10)
                .background(MCColor.highlightFallback.opacity(0.15))
                .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5))
                .overlay(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5).stroke(MCColor.highlightFallback.opacity(0.3), lineWidth: 1))

            // 7일 그리드
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: min(7, Int(geo.size.width / 90))), spacing: 4) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                    VStack(spacing: 4) {
                        Text(day)
                            .font(MCFont.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(MCColor.inkFallback)

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: binding("day_\(index)"))
                                .font(MCFont.caption)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 100)
                                .padding(6)

                            if textContents["day_\(index)", default: ""].isEmpty {
                                Text("실천 기록")
                                    .font(MCFont.caption2)
                                    .foregroundStyle(MCColor.pencilFallback.opacity(0.7))
                                    .padding(10)
                                    .allowsHitTesting(false)
                            }
                        }
                        .background(MCColor.paperDarkFallback.opacity(0.3))
                        .clipShape(SketchyRoundedRect(cornerRadius: 6, wobble: 1))
                        .overlay(SketchyRoundedRect(cornerRadius: 6, wobble: 1).stroke(MCColor.inkFallback.opacity(0.1), lineWidth: 1))
                    }
                }
            }

            // 반성
            SectionEditor(title: s[2].title, placeholder: s[2].placeholder, text: binding("2"))
                .frame(minHeight: 100)
                .padding(10)
                .sketchyCard(wobble: 1.5)
        }
    }

    // MARK: - Buffett 2-List (두 칼럼)
    // ┌──────────┬──────────┐
    // │ 25개 목표│  TOP 5   │
    // │          ├──────────┤
    // │          │ 안할 것  │
    // └──────────┴──────────┘
    private func buffettLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        return HStack(spacing: 0) {
            SectionEditor(title: s[0].title, placeholder: s[0].placeholder, text: binding("0"))
                .padding(10)
                .frame(minHeight: geo.size.height * 0.7)
                .sketchyCard(wobble: 1.5)

            Rectangle().fill(MCColor.inkFallback.opacity(0.12)).frame(width: 1.5)

            VStack(spacing: 0) {
                SectionEditor(title: s[1].title, placeholder: s[1].placeholder, text: binding("1"))
                    .padding(10)
                    .background(MCColor.highlightFallback.opacity(0.08))
                    .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5))
                    .overlay(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5).stroke(MCColor.highlightFallback.opacity(0.3), lineWidth: 1))

                SketchyUnderline().stroke(MCColor.inkFallback.opacity(0.15), lineWidth: 1).frame(height: 4)

                SectionEditor(title: s[2].title, placeholder: s[2].placeholder, text: binding("2"))
                    .padding(10)
                    .background(MCColor.eraserFallback.opacity(0.06))
                    .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5))
                    .overlay(SketchyRoundedRect(cornerRadius: 10, wobble: 1.5).stroke(MCColor.eraserFallback.opacity(0.2), lineWidth: 1))
            }
        }
    }

    // MARK: - Think Week (두 칼럼: 읽기 | 인사이트+행동)
    private func thinkWeekLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        return HStack(spacing: 0) {
            SectionEditor(title: s[0].title, placeholder: s[0].placeholder, text: binding("0"))
                .padding(10)
                .frame(minHeight: geo.size.height * 0.7)
                .sketchyCard(wobble: 1.5)

            Rectangle().fill(MCColor.inkFallback.opacity(0.12)).frame(width: 1.5)

            VStack(spacing: 0) {
                SectionEditor(title: s[1].title, placeholder: s[1].placeholder, text: binding("1"))
                    .padding(10)
                    .sketchyCard(wobble: 1.5)

                ArrowDivider(direction: .down).padding(.vertical, 4)

                SectionEditor(title: s[2].title, placeholder: s[2].placeholder, text: binding("2"))
                    .padding(10)
                    .sketchyCard(wobble: 1.5)
            }
        }
    }

    // MARK: - Zettelkasten (카드형)
    // ┌──────────────────────────┐
    // │ #ID  │  출처: ___       │
    // ├──────┴──────────────────┤
    // │  원자적 메모 (핵심)      │
    // ├─────────────────────────┤
    // │  설명 & 근거             │
    // ├─────────────────────────┤
    // │  → 연결: #___  #___     │
    // └─────────────────────────┘
    private func zettelkastenLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        return VStack(spacing: 0) {
            // 상단: 출처 (메타데이터)
            HStack {
                Image(systemName: "number")
                    .font(MCFont.caption)
                    .foregroundStyle(MCColor.eraserFallback)
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .font(MCFont.caption)
                    .foregroundStyle(MCColor.pencilFallback)
                Spacer()
                SectionEditor(title: s[3].title, placeholder: s[3].placeholder, text: binding("3"))
                    .frame(maxWidth: geo.size.width * 0.5)
            }
            .padding(10)
            .background(MCColor.paperDarkFallback.opacity(0.5))
            .clipShape(SketchyRoundedRect(cornerRadius: 10, wobble: 1))

            Rectangle().fill(MCColor.inkFallback.opacity(0.15)).frame(height: 1.5)

            // 핵심 메모 (강조)
            SectionEditor(title: s[0].title, placeholder: s[0].placeholder, text: binding("0"))
                .frame(minHeight: 80)
                .padding(12)
                .background(MCColor.highlightFallback.opacity(0.08))

            Rectangle().fill(MCColor.inkFallback.opacity(0.15)).frame(height: 1.5)

            // 설명
            SectionEditor(title: s[1].title, placeholder: s[1].placeholder, text: binding("1"))
                .frame(minHeight: geo.size.height * 0.3)
                .padding(12)

            Rectangle().fill(MCColor.inkFallback.opacity(0.15)).frame(height: 1.5)

            // 연결 메모
            HStack(spacing: 6) {
                Image(systemName: "link")
                    .foregroundStyle(MCColor.eraserFallback)
                SectionEditor(title: s[2].title, placeholder: s[2].placeholder, text: binding("2"))
            }
            .frame(minHeight: 70)
            .padding(10)
            .background(MCColor.eraserFallback.opacity(0.05))
        }
        .clipShape(SketchyRoundedRect(cornerRadius: 12, wobble: 2))
        .overlay(SketchyRoundedRect(cornerRadius: 12, wobble: 2).stroke(MCColor.inkFallback.opacity(0.25), lineWidth: 2))
        .shadow(color: MCColor.inkFallback.opacity(0.08), radius: 6, y: 4)
    }

    // MARK: - 3-Circle Framework (벤 다이어그램형)
    //     [기술]
    // [사용자] [비즈니스]
    //     [교차점]
    private func threeCircleLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        let circleSize = min(geo.size.width * 0.42, 280)
        return VStack(spacing: -circleSize * 0.15) {
            // 상단 원: 기술
            SectionEditor(title: s[0].title, placeholder: s[0].placeholder, text: binding("0"))
                .frame(width: circleSize, height: circleSize)
                .padding(10)
                .background(Color.blue.opacity(0.06))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.blue.opacity(0.25), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])))

            // 중간: 사용자 + 비즈니스
            HStack(spacing: -circleSize * 0.2) {
                SectionEditor(title: s[1].title, placeholder: s[1].placeholder, text: binding("1"))
                    .frame(width: circleSize, height: circleSize)
                    .padding(10)
                    .background(Color.green.opacity(0.06))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.green.opacity(0.25), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])))

                SectionEditor(title: s[2].title, placeholder: s[2].placeholder, text: binding("2"))
                    .frame(width: circleSize, height: circleSize)
                    .padding(10)
                    .background(MCColor.eraserFallback.opacity(0.06))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(MCColor.eraserFallback.opacity(0.25), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])))
            }

            // 교차점
            SectionEditor(title: s[3].title, placeholder: s[3].placeholder, text: binding("3"))
                .frame(minHeight: 100)
                .padding(12)
                .background(MCColor.highlightFallback.opacity(0.15))
                .clipShape(SketchyRoundedRect(cornerRadius: 12, wobble: 2))
                .overlay(SketchyRoundedRect(cornerRadius: 12, wobble: 2).stroke(MCColor.highlightFallback.opacity(0.4), lineWidth: 2))
                .padding(.top, 16)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Bullet Journal (3칼럼 + 하단)
    // [· Tasks] [○ Events] [- Notes]
    // [        Reflection             ]
    private func bulletJournalLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        let symbols = ["·", "○", "—"]
        let colors = [MCColor.inkFallback, MCColor.eraserFallback, MCColor.pencilFallback]

        return VStack(spacing: 12) {
            // 날짜 헤더
            HStack {
                Text(Date().formatted(date: .complete, time: .omitted))
                    .font(MCFont.headline)
                    .foregroundStyle(MCColor.inkFallback)
                Spacer()
            }

            // 3칼럼
            HStack(spacing: 8) {
                ForEach(0..<3) { i in
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Text(symbols[i])
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(colors[i])
                            Text(s[i].title.components(separatedBy: "(").last?.replacingOccurrences(of: ")", with: "") ?? s[i].title)
                                .font(MCFont.caption2)
                                .foregroundStyle(colors[i])
                        }

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: binding("\(i)"))
                                .font(MCFont.body)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: geo.size.height * 0.4)
                                .padding(8)

                            if textContents["\(i)", default: ""].isEmpty {
                                Text(s[i].placeholder)
                                    .font(MCFont.caption)
                                    .foregroundStyle(MCColor.pencilFallback.opacity(0.7))
                                    .padding(12)
                                    .allowsHitTesting(false)
                            }
                        }
                        .background(colors[i].opacity(0.04))
                        .clipShape(SketchyRoundedRect(cornerRadius: 8, wobble: 1))
                        .overlay(SketchyRoundedRect(cornerRadius: 8, wobble: 1).stroke(colors[i].opacity(0.15), lineWidth: 1))
                    }
                }
            }

            // Reflection
            SectionEditor(title: s[3].title, placeholder: s[3].placeholder, text: binding("3"))
                .frame(minHeight: 100)
                .padding(10)
                .sketchyCard(wobble: 1.5)
        }
    }

    // MARK: - PARA (2x2 폴더형)
    // [Projects] [Areas]
    // [Resources] [Archives]
    private func paraLayout(geo: GeometryProxy) -> some View {
        let s = template.sections
        let icons = ["folder.fill", "square.stack.fill", "books.vertical.fill", "archivebox.fill"]
        let colors: [Color] = [.blue, .green, .orange, .gray]
        let cellH = max(160, (geo.size.height - 60) * 0.45)

        return LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            ForEach(Array(s.enumerated()), id: \.offset) { index, section in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: icons[index])
                            .font(MCFont.subheadline)
                            .foregroundStyle(colors[index])
                        Text(section.title)
                            .font(MCFont.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(MCColor.inkFallback)
                    }

                    ZStack(alignment: .topLeading) {
                        TextEditor(text: binding("\(index)"))
                            .font(MCFont.body)
                            .scrollContentBackground(.hidden)
                            .padding(8)

                        if textContents["\(index)", default: ""].isEmpty {
                            Text(section.placeholder)
                                .font(MCFont.caption)
                                .foregroundStyle(MCColor.pencilFallback.opacity(0.7))
                                .padding(12)
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(minHeight: cellH)
                    .background(colors[index].opacity(0.04))
                    .clipShape(SketchyRoundedRect(cornerRadius: 8, wobble: 1))
                    .overlay(SketchyRoundedRect(cornerRadius: 8, wobble: 1).stroke(colors[index].opacity(0.2), lineWidth: 1))
                }
            }
        }
    }

    // MARK: - 기본 (세로 나열)
    private func defaultLayout(geo: GeometryProxy) -> some View {
        VStack(spacing: 16) {
            ForEach(Array(template.sections.enumerated()), id: \.offset) { index, section in
                SectionEditor(title: section.title, placeholder: section.placeholder, text: binding("\(index)"))
                    .frame(minHeight: max(100, geo.size.height * section.heightRatio))
                    .padding(10)
                    .sketchyCard(wobble: 1.5)
            }
        }
    }
}
