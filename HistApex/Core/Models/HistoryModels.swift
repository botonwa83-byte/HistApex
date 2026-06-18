import Foundation

enum ImportanceGrade: String, Codable, CaseIterable, Identifiable, Comparable {
    case s = "S"
    case a = "A"
    case b = "B"
    case c = "C"

    var id: String { rawValue }

    var scoreRange: String {
        switch self {
        case .s: return "90-100"
        case .a: return "75-89"
        case .b: return "55-74"
        case .c: return "0-54"
        }
    }

    var reviewIntervals: [Int] {
        switch self {
        case .s: return [1, 2, 4, 7, 15, 30]
        case .a: return [1, 3, 7, 15, 30, 60]
        case .b: return [2, 7, 15, 30, 60]
        case .c: return [7, 30, 60]
        }
    }

    static func < (lhs: ImportanceGrade, rhs: ImportanceGrade) -> Bool {
        lhs.rank < rhs.rank
    }

    private var rank: Int {
        switch self {
        case .s: return 3
        case .a: return 2
        case .b: return 1
        case .c: return 0
        }
    }
}

enum MemoryCardType: String, Codable, CaseIterable, Identifiable {
    case original = "史实卡"
    case boundary = "时空卡"
    case subject = "主体卡"
    case scene = "史料卡"
    case template = "论证卡"

    var id: String { rawValue }
}

enum RecallMode: String, Codable, CaseIterable, Identifiable {
    case recognize = "认得出"
    case recite = "背得出"
    case distinguish = "分得清"
    case apply = "用得上"

    var id: String { rawValue }
}

enum SubjectiveQuestionType: String, Codable, CaseIterable, Identifiable {
    case materialAnalysis = "史料分析题"
    case measure = "原因背景题"
    case significance = "影响意义题"
    case evaluation = "观点评析题"
    case openInquiry = "历史小论文"

    var id: String { rawValue }

    var shortName: String {
        switch self {
        case .materialAnalysis: return "分析"
        case .measure: return "措施"
        case .significance: return "意义"
        case .evaluation: return "评析"
        case .openInquiry: return "探究"
        }
    }
}

enum HistoryTopic: String, Codable, CaseIterable, Identifiable {
    case juniorAncient
    case juniorModern
    case juniorWorld
    case ancientChina
    case modernChina
    case worldHistory
    case stateSystem
    case economySociety
    case culturalExchange
    case historicalMethod
    case sprint

    var id: String { rawValue }

    var name: String {
        switch self {
        case .juniorAncient: return "初中中国古代史"
        case .juniorModern: return "初中中国近现代史"
        case .juniorWorld: return "初中世界史"
        case .ancientChina: return "中国古代史"
        case .modernChina: return "中国近现代史"
        case .worldHistory: return "世界史"
        case .stateSystem: return "国家制度与治理"
        case .economySociety: return "经济与社会生活"
        case .culturalExchange: return "文化交流与传播"
        case .historicalMethod: return "史学方法"
        case .sprint: return "冲刺综合"
        }
    }

    var stage: Stage {
        switch self {
        case .juniorAncient, .juniorModern, .juniorWorld: return .junior
        case .ancientChina, .modernChina, .worldHistory: return .required
        case .stateSystem, .economySociety, .culturalExchange, .historicalMethod: return .elective
        case .sprint: return .sprint
        }
    }

    var icon: String {
        switch self {
        case .juniorAncient: return "building.columns"
        case .juniorModern: return "flag"
        case .juniorWorld: return "globe.europe.africa"
        case .ancientChina: return "seal"
        case .modernChina: return "person.3.sequence"
        case .worldHistory: return "globe"
        case .stateSystem: return "scroll"
        case .economySociety: return "chart.line.uptrend.xyaxis"
        case .culturalExchange: return "books.vertical"
        case .historicalMethod: return "magnifyingglass"
        case .sprint: return "target"
        }
    }
}

enum HistoryWeapon: String, Codable, CaseIterable, Identifiable {
    case timelineAnchor
    case stageFeature
    case materialEvidence
    case causalityChain
    case comparisonMatrix
    case continuityChange
    case conceptBoundary
    case mapSpace
    case institutionEvolution
    case economyStructure
    case cultureExchange
    case worldSystem
    case historiographyView
    case choiceTrapFilter
    case essayArgument
    case openEssaySixSteps

    var id: String { rawValue }

    var name: String {
        switch self {
        case .timelineAnchor: return "时间轴锚点"
        case .stageFeature: return "阶段特征定位"
        case .materialEvidence: return "史料实证四问"
        case .causalityChain: return "因果链三层"
        case .comparisonMatrix: return "比较题矩阵"
        case .continuityChange: return "延续与变迁"
        case .conceptBoundary: return "概念边界排雷"
        case .mapSpace: return "地图空间定位"
        case .institutionEvolution: return "制度演变线"
        case .economyStructure: return "经济结构链"
        case .cultureExchange: return "文明交流模板"
        case .worldSystem: return "世界体系视角"
        case .historiographyView: return "史观转换器"
        case .choiceTrapFilter: return "选择题五排雷"
        case .essayArgument: return "论点论据法"
        case .openEssaySixSteps: return "小论文六步法"
        }
    }

    var icon: String {
        switch self {
        case .timelineAnchor: return "timeline.selection"
        case .stageFeature: return "tag"
        case .materialEvidence: return "doc.text.magnifyingglass"
        case .causalityChain: return "link"
        case .comparisonMatrix: return "tablecells"
        case .continuityChange: return "arrow.left.arrow.right"
        case .conceptBoundary: return "rectangle.expand.vertical"
        case .mapSpace: return "map"
        case .institutionEvolution: return "building.columns"
        case .economyStructure: return "arrow.triangle.branch"
        case .cultureExchange: return "books.vertical"
        case .worldSystem: return "globe"
        case .historiographyView: return "eye"
        case .choiceTrapFilter: return "exclamationmark.triangle"
        case .essayArgument: return "quote.bubble"
        case .openEssaySixSteps: return "text.append"
        }
    }
}

struct KnowledgePoint: Codable, Identifiable {
    let id: String
    let title: String
    let detail: String
    let grade: ImportanceGrade
    let cardType: MemoryCardType
    var pitfall: String? = nil
    var keywords: [String] = []
    var explanation: KnowledgeExplanation = KnowledgeExplanation()

    var hasDeepExplanation: Bool { explanation.hasDepth }
    var mustReciteLines: [String] { explanation.mustRecite.isEmpty ? [detail] : explanation.mustRecite }
    var sampleAnswerSentences: [String] {
        explanation.sampleAnswerSentences.isEmpty ? [detail] : explanation.sampleAnswerSentences
    }
    var commonTrapLines: [String] {
        var lines = explanation.commonTraps
        if let pitfall, !pitfall.isEmpty {
            lines.insert(pitfall, at: 0)
        }
        return lines
    }
}

struct KnowledgeExplanation: Codable, Equatable {
    var mustRecite: [String] = []
    var plainExplanation: String = ""
    var answerTemplate: [String] = []
    var triggerScenes: [String] = []
    var confusions: [String] = []
    var commonTraps: [String] = []
    var sampleAnswerSentences: [String] = []
    var reciteChecklist: [String] = []

    var hasDepth: Bool {
        !mustRecite.isEmpty ||
        !plainExplanation.isEmpty ||
        !answerTemplate.isEmpty ||
        !triggerScenes.isEmpty ||
        !confusions.isEmpty ||
        !commonTraps.isEmpty ||
        !sampleAnswerSentences.isEmpty ||
        !reciteChecklist.isEmpty
    }
}

struct LearningNode: Codable, Identifiable {
    let id: String
    var order: Int
    let stage: Stage
    let topic: HistoryTopic
    let title: String
    let tagline: String
    let knowledgePoints: [KnowledgePoint]
    let practiceIds: [String]
    var bossCaseId: String? = nil
    var weaponUnlocked: HistoryWeapon? = nil

    var allPracticeIds: [String] {
        MainLineData.coveragePoints(for: self).flatMap { point in
            (0..<QuestionBank.questionCount(for: point.grade)).map { variant in
                "q_\(id)_\(point.id)_\(variant)"
            }
        }
    }
}

enum NodeState {
    case locked
    case current
    case completed
}

struct HistoryQuestion: Codable, Identifiable {
    let id: String
    let nodeId: String
    let knowledgeId: String
    let topic: HistoryTopic
    let stage: Stage
    let prompt: String
    let options: [String]
    let answerIndex: Int
    let explanation: String
    var trapTags: [String] = []
    var weapon: HistoryWeapon? = nil
}

struct SubjectiveQuestion: Identifiable {
    let id: String
    let nodeId: String
    let knowledgeId: String
    let grade: ImportanceGrade
    let questionType: SubjectiveQuestionType
    let score: Int
    let material: String
    let prompt: String
    let answerPoints: [String]
    let diagnostics: [String]

    init(id: String,
         nodeId: String,
         knowledgeId: String,
         grade: ImportanceGrade,
         questionType: SubjectiveQuestionType = .materialAnalysis,
         score: Int = 13,
         material: String,
         prompt: String,
         answerPoints: [String],
         diagnostics: [String]) {
        self.id = id
        self.nodeId = nodeId
        self.knowledgeId = knowledgeId
        self.grade = grade
        self.questionType = questionType
        self.score = score
        self.material = material
        self.prompt = prompt
        self.answerPoints = answerPoints
        self.diagnostics = diagnostics
    }
}

struct SolutionPath: Codable {
    let title: String
    let steps: [String]
    let timeMinutes: Double
}

struct BossDuel: Codable, Identifiable {
    let id: String
    let nodeId: String
    let title: String
    let material: String
    let question: String
    let standard: SolutionPath
    let weaponPath: SolutionPath
    let weapon: HistoryWeapon
    let keyInsight: String
    let sampleAnswer: [String]

    var timeRatio: Double { max(standard.timeMinutes / max(weaponPath.timeMinutes, 0.1), 1) }
}

enum TrapCategory: String, Codable, CaseIterable, Identifiable {
    case subjectMismatch = "主体错配"
    case absoluteTerm = "绝对化"
    case causalityReversed = "因果倒置"
    case scopeOverreach = "范围越界"
    case invented = "无中生有"
    case irrelevant = "正确无关"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .subjectMismatch: return "person.crop.rectangle.badge.xmark"
        case .absoluteTerm: return "exclamationmark.octagon"
        case .causalityReversed: return "arrow.uturn.left"
        case .scopeOverreach: return "rectangle.expand.vertical"
        case .invented: return "questionmark.app"
        case .irrelevant: return "link.badge.plus"
        }
    }
}

struct TrapDrill: Identifiable {
    let id: String
    let category: TrapCategory
    let knowledgeId: String
    let stem: String
    let trapOption: String
    let verdict: String
    let correction: String
    let explanation: String
}

struct SubjectResponsibility: Identifiable {
    let id: String
    let title: String
    let role: String
    let canDo: [String]
    let cannotDo: [String]
    let triggerWords: [String]
    let knowledgeIds: [String]
}

struct AnswerTemplate: Identifiable {
    let id: String
    let title: String
    let promptType: String
    let structure: [String]
    let sentenceStarters: [String]
    let diagnostics: [String]
    let sample: String
}

struct ReviewCardState: Codable, Equatable {
    var level: Int = 0
    var nextDue: Date = .distantPast
    var correctCount: Int = 0
    var wrongCount: Int = 0
    var lastReviewed: Date? = nil
}

struct WeaponGuide: Identifiable {
    let weapon: HistoryWeapon
    let tagline: String
    let whenToUse: [String]
    let steps: [String]
    let exampleCaseId: String?

    var id: String { weapon.rawValue }
}

struct MemoryCard: Identifiable {
    let id: String
    let knowledgeId: String
    let type: MemoryCardType
    let grade: ImportanceGrade
    let front: String
    let back: String
    let mode: RecallMode
}

struct MaterialCase: Codable, Identifiable {
    let id: String
    let title: String
    let material: String
    let question: String
    let subject: String
    let action: String
    let object: String
    let goal: String
    let knowledgeIds: [String]
    let answerSentences: [String]
    let diagnostics: [String]
}

struct TimeMuseumExhibit: Identifiable {
    let id: String
    let title: String
    let era: String
    let artifact: String
    let scene: String
    let curatorNote: String
    let miniMission: String
    let hiddenExamPoint: String
    let wrongTurn: String
    let stampTitle: String
    let knowledgeIds: [String]
    let rewardSentences: [String]
}

struct HistoryEncounter: Identifiable {
    let id: String
    let person: String
    let event: String
    let era: String
    let roleTag: String
    let setting: String
    let openingLine: String
    let turningPoint: String
    let examFocus: String
    let studentMission: String
    let wrongMemory: String
    let timelineClue: String
    let knowledgeIds: [String]
    let answerLines: [String]
}

struct HistoryPatternCard: Identifiable {
    let id: String
    let title: String
    let law: String
    let whyItWorks: String
    let examSignals: [String]
    let applySteps: [String]
    let transferCases: [String]
    let wrongCounterExample: String
    let premiumHook: String
    let knowledgeIds: [String]
    let answerLines: [String]
}

struct ConceptNode: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let grade: ImportanceGrade
    let topic: HistoryTopic
    let triggerWords: [String]
}

struct ConceptEdge: Identifiable {
    let id: String
    let from: String
    let to: String
    let relation: String
}

struct KnowledgeBridge {
    let point: KnowledgePoint
    let node: LearningNode
    let previousPoint: KnowledgePoint?
    let nextPoint: KnowledgePoint?
    let specialModules: [HistoricalSpecialModule]
    let weaponGuide: WeaponGuide?
    let answerTemplates: [AnswerTemplate]
    let materialCases: [MaterialCase]
    let choiceQuestions: [HistoryQuestion]
    let subjectiveQuestions: [SubjectiveQuestion]
    let bossDuel: BossDuel?

    var hasAnyPractice: Bool {
        !choiceQuestions.isEmpty || !subjectiveQuestions.isEmpty
    }
}
