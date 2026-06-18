import Foundation

struct ReviewInterval: Equatable {
    let days: Int
}

enum ReviewScheduler {
    static func nextInterval(currentLevel: Int, grade: ImportanceGrade, correct: Bool) -> ReviewInterval {
        guard correct else { return ReviewInterval(days: 1) }
        let intervals = grade.reviewIntervals
        let nextLevel = min(max(currentLevel + 1, 0), intervals.count - 1)
        return ReviewInterval(days: intervals[nextLevel])
    }

    static func priorityCards(limit: Int = 12) -> [MemoryCard] {
        MemoryData.highWeight(limit: limit)
    }
}
