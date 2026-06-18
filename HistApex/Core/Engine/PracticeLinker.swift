import Foundation

enum PracticeLinker {
    static func choiceQuestions(knowledgeIds: [String]) -> [HistoryQuestion] {
        let wanted = Set(knowledgeIds)
        return QuestionBank.all.filter { wanted.contains($0.knowledgeId) }
    }

    static func subjectiveQuestions(knowledgeIds: [String]) -> [SubjectiveQuestion] {
        let wanted = Set(knowledgeIds)
        return SubjectiveQuestionData.all.filter { wanted.contains($0.knowledgeId) }
    }

    static func choiceQuestions(for guide: WeaponGuide) -> [HistoryQuestion] {
        let byWeapon = QuestionBank.all.filter { $0.weapon == guide.weapon }
        if !byWeapon.isEmpty {
            return byWeapon
        }
        return fallbackChoiceQuestions(for: guide.weapon)
    }

    static func subjectiveQuestions(for guide: WeaponGuide) -> [SubjectiveQuestion] {
        let nodeIds = Set(MainLineData.nodes.filter { $0.weaponUnlocked == guide.weapon }.map(\.id))
        let byNode = SubjectiveQuestionData.all.filter { nodeIds.contains($0.nodeId) }
        if !byNode.isEmpty {
            return byNode
        }
        return subjectiveQuestions(knowledgeIds: fallbackKnowledgeIds(for: guide.weapon))
    }

    static func choiceQuestions(for duel: BossDuel) -> [HistoryQuestion] {
        let nodeQuestions = QuestionBank.questions(nodeId: duel.nodeId)
        if !nodeQuestions.isEmpty {
            return nodeQuestions
        }
        return choiceQuestions(for: WeaponGuide(weapon: duel.weapon,
                                               tagline: "",
                                               whenToUse: [],
                                               steps: [],
                                               exampleCaseId: nil))
    }

    static func choiceQuestions(for drill: TrapDrill) -> [HistoryQuestion] {
        let direct = QuestionBank.all.filter {
            $0.knowledgeId == drill.knowledgeId &&
            !$0.trapTags.isEmpty
        }
        if !direct.isEmpty {
            return direct
        }
        return QuestionBank.all.filter { $0.knowledgeId == drill.knowledgeId }
    }

    static func subjectiveQuestions(for template: AnswerTemplate) -> [SubjectiveQuestion] {
        let matched = SubjectiveQuestionData.all.filter { question in
            matchesTemplate(template, prompt: question.prompt) ||
            question.answerPoints.contains { matchesTemplate(template, prompt: $0) }
        }
        if !matched.isEmpty {
            return matched
        }
        return subjectiveQuestions(knowledgeIds: fallbackKnowledgeIds(for: template))
    }

    static func choiceQuestions(for template: AnswerTemplate) -> [HistoryQuestion] {
        let subjectiveIds = Set(subjectiveQuestions(for: template).map(\.knowledgeId))
        if !subjectiveIds.isEmpty {
            return choiceQuestions(knowledgeIds: Array(subjectiveIds))
        }
        return choiceQuestions(knowledgeIds: fallbackKnowledgeIds(for: template))
    }

    static func choiceQuestions(for subject: SubjectResponsibility) -> [HistoryQuestion] {
        choiceQuestions(knowledgeIds: subject.knowledgeIds)
    }

    static func subjectiveQuestions(for subject: SubjectResponsibility) -> [SubjectiveQuestion] {
        subjectiveQuestions(knowledgeIds: subject.knowledgeIds)
    }

    static func choiceQuestions(for item: MaterialCase) -> [HistoryQuestion] {
        choiceQuestions(knowledgeIds: item.knowledgeIds)
    }

    static func subjectiveQuestions(for item: MaterialCase) -> [SubjectiveQuestion] {
        subjectiveQuestions(knowledgeIds: item.knowledgeIds)
    }

    private static func fallbackChoiceQuestions(for weapon: HistoryWeapon) -> [HistoryQuestion] {
        choiceQuestions(knowledgeIds: fallbackKnowledgeIds(for: weapon))
    }

    private static func fallbackKnowledgeIds(for weapon: HistoryWeapon) -> [String] {
        switch weapon {
        case .timelineAnchor: return ["k1101", "k1701", "k2101"]
        case .stageFeature: return ["k1004", "k1602", "k2701"]
        case .materialEvidence: return ["k2501", "k2502", "k2801"]
        case .causalityChain: return ["k1401", "k1801", "k2001"]
        case .comparisonMatrix: return ["k1201", "k1901", "k2802"]
        case .continuityChange: return ["k1301", "k1501", "k2401"]
        case .conceptBoundary: return ["k1401", "k2601", "k2701"]
        case .mapSpace: return ["k0804", "k1801", "k2401"]
        case .institutionEvolution: return ["k1101", "k1201", "k2201"]
        case .economyStructure: return ["k2001", "k2301", "k1303"]
        case .cultureExchange: return ["k2401", "k2402", "k0904"]
        case .worldSystem: return ["k1801", "k2004", "k2104"]
        case .historiographyView: return ["k2601", "k2602", "k2201"]
        case .choiceTrapFilter: return TrapDrillData.all.map(\.knowledgeId)
        case .essayArgument: return ["k2801", "k2802", "k2501"]
        case .openEssaySixSteps: return ["k2801", "k2802", "k1901"]
        }
    }

    private static func fallbackKnowledgeIds(for template: AnswerTemplate) -> [String] {
        switch template.id {
        case "tpl_background": return ["k1401", "k1801", "k2001"]
        case "tpl_impact": return ["k1501", "k2001", "k2101"]
        case "tpl_compare": return ["k1201", "k1901", "k2201"]
        case "tpl_evaluate": return ["k1401", "k2501", "k2601"]
        case "tpl_essay": return ["k2801", "k2802", "k2201"]
        default: return ["k2801", "k2802"]
        }
    }

    private static func matchesTemplate(_ template: AnswerTemplate, prompt: String) -> Bool {
        template.promptType
            .split(separator: "、")
            .map(String.init)
            .contains { prompt.contains($0) }
    }
}
