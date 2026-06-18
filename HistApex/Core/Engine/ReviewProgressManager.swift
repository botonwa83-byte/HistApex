import Foundation
import SwiftUI

final class ReviewProgressManager: ObservableObject {
    static let shared = ReviewProgressManager()

    @Published private(set) var states: [String: ReviewCardState]

    private let storageKey = "histapex_review_card_states"
    private let calendar = Calendar.current

    private init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([String: ReviewCardState].self, from: data) {
            states = decoded
        } else {
            states = [:]
        }
    }

    var dueCards: [MemoryCard] {
        dueCards(on: Date())
    }

    var masteredCount: Int {
        states.values.filter { $0.level >= 4 && $0.wrongCount == 0 }.count
    }

    func state(for card: MemoryCard) -> ReviewCardState {
        states[card.id] ?? ReviewCardState()
    }

    func dueCards(on date: Date, limit: Int = 30) -> [MemoryCard] {
        MemoryData.all
            .filter { card in
                (states[card.id]?.nextDue ?? .distantPast) <= date
            }
            .sorted { lhs, rhs in
                if lhs.grade != rhs.grade { return lhs.grade > rhs.grade }
                return lhs.type.rawValue < rhs.type.rawValue
            }
            .prefix(limit)
            .map { $0 }
    }

    func record(card: MemoryCard, correct: Bool, now: Date = Date()) {
        var state = states[card.id] ?? ReviewCardState()
        let currentLevel = state.level
        let interval = ReviewScheduler.nextInterval(currentLevel: currentLevel, grade: card.grade, correct: correct)
        state.level = correct ? min(currentLevel + 1, card.grade.reviewIntervals.count - 1) : 0
        state.nextDue = calendar.date(byAdding: .day, value: interval.days, to: now) ?? now
        state.lastReviewed = now
        if correct {
            state.correctCount += 1
        } else {
            state.wrongCount += 1
        }
        states[card.id] = state
        persist()
    }

    func reset() {
        states = [:]
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(states) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
