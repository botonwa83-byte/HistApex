import Foundation

enum ExamPracticeBlueprint {
    static let sourceNote = "按新高考历史常见结构校准：单项选择题约48分，非选择题约52分。非选择题通常由中国古代史、中国近现代史、世界史史料题和开放论述/选做题构成，各省会有小幅差异。"

    static let choiceQuestionCount = 16
    static let choiceScore = 48
    static let subjectiveQuestionCount = 4
    static let subjectiveScore = 52
    static let totalScore = 100

    static var choiceScoreRatio: Double { Double(choiceScore) / Double(totalScore) }
    static var subjectiveScoreRatio: Double { Double(subjectiveScore) / Double(totalScore) }
    static var choiceCountRatio: Double { Double(choiceQuestionCount) / Double(choiceQuestionCount + subjectiveQuestionCount) }
    static var subjectiveCountRatio: Double { Double(subjectiveQuestionCount) / Double(choiceQuestionCount + subjectiveQuestionCount) }

    static let choiceTopicSlots: [(topic: HistoryTopic, count: Int)] = [
        (.ancientChina, 4),
        (.modernChina, 4),
        (.worldHistory, 4),
        (.stateSystem, 1),
        (.economySociety, 1),
        (.culturalExchange, 1),
        (.historicalMethod, 1)
    ]

    static let subjectiveTopicSlots: [HistoryTopic] = [
        .ancientChina,
        .modernChina,
        .worldHistory,
        .sprint
    ]

    static let subjectiveQuestionSlots: [(topic: HistoryTopic, type: SubjectiveQuestionType, score: Int)] = [
        (.ancientChina, .materialAnalysis, 13),
        (.modernChina, .measure, 13),
        (.worldHistory, .significance, 14),
        (.sprint, .openInquiry, 12)
    ]
}

struct ExamPracticeSet: Identifiable {
    let id: String
    let title: String
    let choiceQuestions: [HistoryQuestion]
    let subjectiveQuestions: [SubjectiveQuestion]

    var choiceScore: Int { ExamPracticeBlueprint.choiceScore }
    var subjectiveScore: Int { ExamPracticeBlueprint.subjectiveScore }
}

enum ExamPracticeData {
    static let all: [ExamPracticeSet] = (0..<6).map { index in
        ExamPracticeSet(id: "exam_practice_\(index + 1)",
                        title: "高考历史权重套练 \(index + 1)",
                        choiceQuestions: choiceQuestions(seed: index),
                        subjectiveQuestions: subjectiveQuestions(seed: index))
    }

    static func choiceQuestions(seed: Int) -> [HistoryQuestion] {
        ExamPracticeBlueprint.choiceTopicSlots.flatMap { slot in
            unique(rotated(AuthoredQuestionData.questions(topic: slot.topic), seed: seed) +
                   rotated(QuestionBank.generated.filter { $0.topic == slot.topic }, seed: seed))
            .prefix(slot.count)
        }
    }

    static func subjectiveQuestions(seed: Int) -> [SubjectiveQuestion] {
        ExamPracticeBlueprint.subjectiveQuestionSlots.compactMap { slot in
            let authoredByType = AuthoredSubjectiveQuestionData.questions(topic: slot.topic).filter { $0.questionType == slot.type }
            let authoredByTopic = AuthoredSubjectiveQuestionData.questions(topic: slot.topic)
            let fallback = SubjectiveQuestionData.generated.filter { MainLineData.node(id: $0.nodeId)?.topic == slot.topic }
            return unique(rotated(authoredByType, seed: seed) + rotated(authoredByTopic, seed: seed) + rotated(fallback, seed: seed)).first
        }
    }

    private static func rotated<T>(_ items: [T], seed: Int) -> [T] {
        guard !items.isEmpty else { return [] }
        let offset = seed % items.count
        return Array(items[offset..<items.count] + items[0..<offset])
    }

    private static func unique<T: Identifiable>(_ items: [T]) -> [T] where T.ID == String {
        var seen = Set<String>()
        return items.filter { item in
            if seen.contains(item.id) { return false }
            seen.insert(item.id)
            return true
        }
    }
}
