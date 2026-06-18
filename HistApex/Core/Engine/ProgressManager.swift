import Foundation
import SwiftUI

struct QuestionStats: Codable, Equatable {
    var attempts: Int = 0
    var correct: Int = 0
    var bookmarked: Bool = false

    var everCorrect: Bool { correct > 0 }
    var accuracy: Double { attempts == 0 ? 0 : Double(correct) / Double(attempts) }
}

struct WeakNodeDiagnosis: Identifiable {
    let node: LearningNode
    let accuracy: Double
    var id: String { node.id }
}

final class ProgressManager: ObservableObject {
    static let shared = ProgressManager()

    @Published private(set) var completedNodeIds: Set<String>
    @Published private(set) var questionStats: [String: QuestionStats]
    @Published private(set) var streak: Int

    private let completedKey = "histapex_completed_nodes"
    private let statsKey = "histapex_question_stats"
    private let streakKey = "histapex_streak"

    private init() {
        let completed = UserDefaults.standard.stringArray(forKey: completedKey) ?? []
        completedNodeIds = Set(completed)
        streak = UserDefaults.standard.integer(forKey: streakKey)
        if let data = UserDefaults.standard.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode([String: QuestionStats].self, from: data) {
            questionStats = decoded
        } else {
            questionStats = [:]
        }
    }

    var completedNodeCount: Int { completedNodeIds.count }

    var completionRatio: Double {
        guard !MainLineData.nodes.isEmpty else { return 0 }
        return Double(completedNodeCount) / Double(MainLineData.nodes.count)
    }

    func nodeState(_ node: LearningNode, in nodes: [LearningNode] = MainLineData.nodes) -> NodeState {
        if completedNodeIds.contains(node.id) { return .completed }
        let firstOpen = nodes.first { !completedNodeIds.contains($0.id) }?.id
        if firstOpen == node.id { return .current }
        return .locked
    }

    func nodeProgress(_ node: LearningNode) -> Double {
        if completedNodeIds.contains(node.id) { return 1 }
        let questions = QuestionBank.questions(nodeId: node.id)
        guard !questions.isEmpty else { return 0 }
        let solved = questions.filter { stats(for: $0.id).everCorrect }.count
        return Double(solved) / Double(questions.count)
    }

    func currentNode(in nodes: [LearningNode] = MainLineData.nodes) -> LearningNode? {
        nodes.first { !completedNodeIds.contains($0.id) } ?? nodes.last
    }

    func complete(_ node: LearningNode) {
        completedNodeIds.insert(node.id)
        streak = max(streak, 1)
        persist()
    }

    func record(_ question: HistoryQuestion, correct: Bool) {
        var stat = questionStats[question.id] ?? QuestionStats()
        stat.attempts += 1
        if correct { stat.correct += 1 }
        questionStats[question.id] = stat
        persist()
    }

    func toggleBookmark(_ question: HistoryQuestion) {
        var stat = questionStats[question.id] ?? QuestionStats()
        stat.bookmarked.toggle()
        questionStats[question.id] = stat
        persist()
    }

    func stats(for questionId: String) -> QuestionStats {
        questionStats[questionId] ?? QuestionStats()
    }

    func errorQuestions() -> [HistoryQuestion] {
        QuestionBank.all.filter { question in
            let stat = stats(for: question.id)
            return stat.bookmarked || (stat.attempts > 0 && stat.correct == 0)
        }
    }

    func weakNodes(limit: Int) -> [WeakNodeDiagnosis] {
        MainLineData.nodes
            .filter { !completedNodeIds.contains($0.id) || nodeProgress($0) < 1 }
            .map { node in
                let questions = QuestionBank.questions(nodeId: node.id)
                let attempts = questions.map { stats(for: $0.id).attempts }.reduce(0, +)
                let correct = questions.map { stats(for: $0.id).correct }.reduce(0, +)
                let base = attempts == 0 ? (node.knowledgePoints.contains { $0.grade == .s } ? 0.35 : 0.55) : Double(correct) / Double(attempts)
                return WeakNodeDiagnosis(node: node, accuracy: base)
            }
            .sorted { $0.accuracy < $1.accuracy }
            .prefix(limit)
            .map { $0 }
    }

    func reset() {
        completedNodeIds = []
        questionStats = [:]
        streak = 0
        persist()
    }

    private func persist() {
        UserDefaults.standard.set(Array(completedNodeIds), forKey: completedKey)
        UserDefaults.standard.set(streak, forKey: streakKey)
        if let data = try? JSONEncoder().encode(questionStats) {
            UserDefaults.standard.set(data, forKey: statsKey)
        }
    }
}
