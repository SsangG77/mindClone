import SwiftUI

enum TemplateCategory: String, CaseIterable, Identifiable {
    case thinking = "사고력"
    case productivity = "생산성"
    case creativity = "창의력"
    case selfDevelopment = "자기계발"
    case learning = "학습"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .thinking: return "brain.head.profile"
        case .productivity: return "chart.bar.fill"
        case .creativity: return "paintpalette.fill"
        case .selfDevelopment: return "person.fill.checkmark"
        case .learning: return "book.fill"
        }
    }
}

struct Template: Identifiable {
    let id: String
    let name: String
    let person: String
    let personDescription: String
    let category: TemplateCategory
    let isFree: Bool
    let benefit: String
    let sections: [TemplateSection]
    let systemImageName: String
}

struct TemplateSection: Identifiable {
    let id = UUID()
    let title: String
    let placeholder: String
    let heightRatio: CGFloat
}

extension Template {
    static let all: [Template] = [
        Template(
            id: "cornell",
            name: "Cornell Note",
            person: "Cornell 대학",
            personDescription: "하버드·MIT 표준 필기법",
            category: .learning,
            isFree: true,
            benefit: "노트를 '기록 → 핵심 키워드 → 요약'으로 구조화하여 복습 효율을 극대화합니다. 단순히 적는 것이 아니라, 적은 뒤 되짚는 습관을 만들어줍니다.",
            sections: [
                TemplateSection(title: "Cue (키워드/질문)", placeholder: "핵심 키워드나 질문을 적으세요", heightRatio: 0.6),
                TemplateSection(title: "Notes (노트)", placeholder: "수업/회의 내용을 자유롭게 기록하세요", heightRatio: 0.6),
                TemplateSection(title: "Summary (요약)", placeholder: "핵심 내용을 2~3줄로 요약하세요", heightRatio: 0.2),
            ],
            systemImageName: "text.book.closed.fill"
        ),
        Template(
            id: "musk_timeblock",
            name: "Musk Time Block",
            person: "Elon Musk",
            personDescription: "Tesla·SpaceX CEO의 5분 단위 시간 관리법",
            category: .productivity,
            isFree: true,
            benefit: "하루를 30분 단위로 나누고, 가장 중요한 3가지를 먼저 정합니다. 나머지 생각은 Brain Dump에 쏟아낸 뒤 시간표에 배치합니다. 일론 머스크가 실제로 사용하는 플래너 방식입니다.",
            sections: [
                TemplateSection(title: "Top Priorities", placeholder: "오늘 반드시 해야 할 일", heightRatio: 0.15),
                TemplateSection(title: "Brain Dump", placeholder: "머릿속 모든 생각을 쏟아내세요", heightRatio: 0.4),
                TemplateSection(title: "Time Block", placeholder: "", heightRatio: 0.45),
            ],
            systemImageName: "clock.fill"
        ),
        Template(
            id: "feynman",
            name: "Feynman Technique",
            person: "Richard Feynman",
            personDescription: "노벨 물리학상 수상자",
            category: .learning,
            isFree: true,
            benefit: "어떤 개념이든 초등학생에게 설명할 수 있을 때까지 단순화합니다. 설명 못하는 부분이 바로 당신이 모르는 부분입니다.",
            sections: [
                TemplateSection(title: "1. 개념 선택", placeholder: "배우고 싶은 개념을 적으세요", heightRatio: 0.1),
                TemplateSection(title: "2. 쉽게 설명하기", placeholder: "초등학생도 이해할 수 있게 설명하세요", heightRatio: 0.3),
                TemplateSection(title: "3. 막히는 부분", placeholder: "설명이 안 되는 부분 = 모르는 부분을 적으세요", heightRatio: 0.25),
                TemplateSection(title: "4. 다시 단순화", placeholder: "돌아가서 다시 공부한 뒤, 더 쉽게 설명하세요", heightRatio: 0.25),
            ],
            systemImageName: "lightbulb.fill"
        ),
        Template(
            id: "gtd",
            name: "GTD",
            person: "David Allen",
            personDescription: "실리콘밸리 생산성 바이블",
            category: .productivity,
            isFree: false,
            benefit: "머릿속의 모든 할 일을 외부 시스템에 쏟아낸 뒤, '지금 할 수 있는 다음 행동'에만 집중합니다. 걱정 대신 실행이 남습니다.",
            sections: [
                TemplateSection(title: "Capture (수집)", placeholder: "머릿속 모든 것을 쏟아내세요", heightRatio: 0.2),
                TemplateSection(title: "Clarify (명확화)", placeholder: "각 항목이 실행 가능한가? 다음 행동은?", heightRatio: 0.2),
                TemplateSection(title: "Organize (정리)", placeholder: "프로젝트 / 대기 / 언젠가로 분류하세요", heightRatio: 0.2),
                TemplateSection(title: "Next Actions (다음 행동)", placeholder: "지금 바로 할 수 있는 행동만 적으세요", heightRatio: 0.2),
            ],
            systemImageName: "checklist"
        ),
        Template(
            id: "eisenhower",
            name: "Eisenhower Matrix",
            person: "Dwight D. Eisenhower",
            personDescription: "스티브 잡스가 즐겨 쓴 우선순위 프레임",
            category: .productivity,
            isFree: false,
            benefit: "모든 일을 긴급/중요 2축으로 나눕니다. 정말 중요한 일에 시간을 쓰고, 긴급하기만 한 일은 위임하거나 제거합니다.",
            sections: [
                TemplateSection(title: "긴급 + 중요 (즉시 실행)", placeholder: "지금 당장 해야 하는 일", heightRatio: 0.22),
                TemplateSection(title: "중요 + 비긴급 (계획)", placeholder: "장기적으로 가치 있는 일 — 여기에 집중!", heightRatio: 0.22),
                TemplateSection(title: "긴급 + 비중요 (위임)", placeholder: "다른 사람에게 맡길 수 있는 일", heightRatio: 0.22),
                TemplateSection(title: "비긴급 + 비중요 (제거)", placeholder: "과감히 하지 않을 일", heightRatio: 0.22),
            ],
            systemImageName: "square.grid.2x2.fill"
        ),
        Template(
            id: "davinci",
            name: "Da Vinci Sketchnote",
            person: "Leonardo da Vinci",
            personDescription: "르네상스 노트 방식",
            category: .creativity,
            isFree: false,
            benefit: "글과 그림을 자유롭게 섞어 기록합니다. 다빈치처럼 관찰하고, 스케치하고, 메모를 남기세요. 정형화된 틀이 없는 것이 곧 형식입니다.",
            sections: [
                TemplateSection(title: "관찰 스케치", placeholder: "보이는 것을 그리세요 — 완벽하지 않아도 됩니다", heightRatio: 0.4),
                TemplateSection(title: "메모 & 질문", placeholder: "스케치 옆에 떠오르는 생각, 질문, 아이디어를 적으세요", heightRatio: 0.3),
                TemplateSection(title: "연결 & 발견", placeholder: "관찰들 사이의 패턴이나 새로운 발견을 기록하세요", heightRatio: 0.2),
            ],
            systemImageName: "paintbrush.pointed.fill"
        ),
        Template(
            id: "franklin",
            name: "Benjamin Franklin 덕목 일지",
            person: "Benjamin Franklin",
            personDescription: "자서전에 직접 기록한 자기계발법",
            category: .selfDevelopment,
            isFree: false,
            benefit: "매주 하나의 덕목에 집중하고, 매일 밤 스스로를 돌아봅니다. 프랭클린이 평생 실천한 자기 개선의 원형입니다.",
            sections: [
                TemplateSection(title: "이번 주 덕목", placeholder: "이번 주 집중할 덕목 하나를 적으세요", heightRatio: 0.1),
                TemplateSection(title: "오늘의 실천 기록", placeholder: "이 덕목을 위해 오늘 무엇을 했나요?", heightRatio: 0.3),
                TemplateSection(title: "반성 & 개선", placeholder: "잘한 점과 내일 개선할 점을 적으세요", heightRatio: 0.3),
            ],
            systemImageName: "star.fill"
        ),
        Template(
            id: "buffett",
            name: "Warren Buffett 2-List",
            person: "Warren Buffett",
            personDescription: "세계 최고 투자자의 목표 설정법",
            category: .productivity,
            isFree: false,
            benefit: "목표 25개를 적고, 상위 5개만 남깁니다. 나머지 20개는 '절대 하지 않을 것 목록'이 됩니다. 진짜 중요한 것에만 집중하는 극단적 우선순위 설정법.",
            sections: [
                TemplateSection(title: "목표 25개 나열", placeholder: "달성하고 싶은 목표를 25개 적으세요", heightRatio: 0.35),
                TemplateSection(title: "TOP 5 선택", placeholder: "가장 중요한 5개를 고르세요 — 이것만 한다", heightRatio: 0.25),
                TemplateSection(title: "절대 안 할 것 (나머지 20개)", placeholder: "TOP 5 이외는 모두 여기 — 끝날 때까지 손대지 않는다", heightRatio: 0.25),
            ],
            systemImageName: "list.number"
        ),
        Template(
            id: "thinkweek",
            name: "Think Week",
            person: "Bill Gates",
            personDescription: "마이크로소프트 성장기 루틴",
            category: .thinking,
            isFree: false,
            benefit: "일주일간 외부와 단절하고 오직 읽고, 생각하고, 기록합니다. 빌 게이츠의 가장 중요한 전략적 결정들이 Think Week에서 나왔습니다.",
            sections: [
                TemplateSection(title: "읽을 자료 목록", placeholder: "이번 주 읽을 논문, 책, 아티클을 적으세요", heightRatio: 0.2),
                TemplateSection(title: "핵심 인사이트", placeholder: "읽으면서 떠오른 핵심 생각들", heightRatio: 0.3),
                TemplateSection(title: "전략적 결정/행동", placeholder: "인사이트에서 도출된 구체적 액션", heightRatio: 0.25),
            ],
            systemImageName: "brain"
        ),
        Template(
            id: "zettelkasten",
            name: "Zettelkasten",
            person: "Niklas Luhmann",
            personDescription: "논문 70편 저술한 사회학자",
            category: .learning,
            isFree: false,
            benefit: "하나의 메모에 하나의 생각만 적고, 메모들을 서로 연결합니다. 생각의 네트워크가 쌓이면, 글과 아이디어가 자연스럽게 만들어집니다.",
            sections: [
                TemplateSection(title: "원자적 메모 (하나의 생각)", placeholder: "하나의 명확한 생각을 한 문장으로 적으세요", heightRatio: 0.15),
                TemplateSection(title: "설명 & 근거", placeholder: "왜 이렇게 생각하는지 자세히 적으세요", heightRatio: 0.3),
                TemplateSection(title: "연결 메모", placeholder: "이 생각과 연결되는 다른 생각이나 메모 번호를 적으세요", heightRatio: 0.2),
                TemplateSection(title: "출처", placeholder: "이 생각의 출처 (책, 강의, 대화 등)", heightRatio: 0.1),
            ],
            systemImageName: "link"
        ),
        Template(
            id: "threecircle",
            name: "3-Circle Framework",
            person: "Steve Jobs",
            personDescription: "애플 제품 기획 방식에서 추출",
            category: .thinking,
            isFree: false,
            benefit: "기술·사용자·비즈니스 세 원이 겹치는 교차점에서 최고의 결정이 나옵니다. 잡스가 애플 제품을 기획하던 방식의 핵심입니다.",
            sections: [
                TemplateSection(title: "기술 (Technology)", placeholder: "우리가 만들 수 있는 것은?", heightRatio: 0.22),
                TemplateSection(title: "사용자 (User)", placeholder: "사용자가 진짜 원하는 것은?", heightRatio: 0.22),
                TemplateSection(title: "비즈니스 (Business)", placeholder: "지속 가능한 수익 모델은?", heightRatio: 0.22),
                TemplateSection(title: "교차점 = 답", placeholder: "세 원이 겹치는 곳 — 이것이 우리가 해야 할 일", heightRatio: 0.22),
            ],
            systemImageName: "circle.grid.cross.fill"
        ),
        Template(
            id: "bulletjournal",
            name: "Bullet Journal",
            person: "Ryder Carroll",
            personDescription: "전 세계 600만 명 사용",
            category: .selfDevelopment,
            isFree: false,
            benefit: "빠른 기호(·, ○, -)로 할일, 이벤트, 메모를 구분합니다. 하루를 기록하고, 한 달을 돌아보고, 일 년을 설계합니다.",
            sections: [
                TemplateSection(title: "· 할 일 (Tasks)", placeholder: "· 오늘 해야 할 일들", heightRatio: 0.25),
                TemplateSection(title: "○ 이벤트 (Events)", placeholder: "○ 오늘의 일정과 약속", heightRatio: 0.2),
                TemplateSection(title: "- 메모 (Notes)", placeholder: "- 떠오른 생각, 아이디어, 관찰", heightRatio: 0.2),
                TemplateSection(title: "돌아보기 (Reflection)", placeholder: "오늘 하루는 어땠나요?", heightRatio: 0.2),
            ],
            systemImageName: "list.bullet"
        ),
        Template(
            id: "para",
            name: "PARA Method",
            person: "Tiago Forte",
            personDescription: "Second Brain 창시자",
            category: .productivity,
            isFree: false,
            benefit: "모든 정보를 Projects, Areas, Resources, Archives 네 폴더로 정리합니다. 어떤 정보든 4초 안에 제자리를 찾습니다.",
            sections: [
                TemplateSection(title: "Projects (진행 중 프로젝트)", placeholder: "기한이 있는 현재 진행 중인 일", heightRatio: 0.22),
                TemplateSection(title: "Areas (관리 영역)", placeholder: "기한 없이 지속적으로 관리하는 영역 (건강, 재정 등)", heightRatio: 0.22),
                TemplateSection(title: "Resources (자료)", placeholder: "관심 분야의 참고 자료", heightRatio: 0.22),
                TemplateSection(title: "Archives (보관)", placeholder: "완료되었거나 더 이상 활성화되지 않은 항목", heightRatio: 0.22),
            ],
            systemImageName: "folder.fill"
        ),
    ]

    static let free: [Template] = all.filter { $0.isFree }
    static let paid: [Template] = all.filter { !$0.isFree }

    static func template(for id: String) -> Template? {
        all.first { $0.id == id }
    }
}
