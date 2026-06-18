import Foundation

enum KnowledgeBridgeData {
    static func bridge(for point: KnowledgePoint) -> KnowledgeBridge? {
        guard let node = MainLineData.nodes.first(where: { node in
            node.knowledgePoints.contains { $0.id == point.id }
        }) else {
            return nil
        }

        let orderedPoints = MainLineData.allKnowledgePoints
        let currentIndex = orderedPoints.firstIndex { $0.id == point.id }
        let previous = currentIndex.flatMap { index in
            index > 0 ? orderedPoints[index - 1] : nil
        }
        let next = currentIndex.flatMap { index in
            index + 1 < orderedPoints.count ? orderedPoints[index + 1] : nil
        }

        let specialModules = HistoricalSpecialData.modules(knowledgeId: point.id)
        let templates = AnswerTemplateData.templates(for: point, node: node)
        let materialCases = MaterialCaseData.all.filter { $0.knowledgeIds.contains(point.id) }
        let choice = PracticeLinker.choiceQuestions(knowledgeIds: [point.id])
        let subjective = PracticeLinker.subjectiveQuestions(knowledgeIds: [point.id])
        let duel = node.bossCaseId.flatMap { BossDuelData.duel(id: $0) }

        return KnowledgeBridge(point: point,
                               node: node,
                               previousPoint: previous,
                               nextPoint: next,
                               specialModules: specialModules,
                               weaponGuide: node.weaponUnlocked.flatMap { WeaponGuideData.guide(for: $0) },
                               answerTemplates: templates,
                               materialCases: materialCases,
                               choiceQuestions: choice,
                               subjectiveQuestions: subjective,
                               bossDuel: duel)
    }
}
