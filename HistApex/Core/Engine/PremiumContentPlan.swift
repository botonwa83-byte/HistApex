import SwiftUI

enum PremiumContentPlan {
    static let title = "解锁历史提分闭环"
    static let tagline = "不是多给几道题，是把背诵、材料、题型和复习串成一套。"

    static var freeSummary: String {
        "免费已开放：初中通史 \(PurchaseManager.freeNodeCount) 关、\(PurchaseManager.freeWeaponCount) 把史学武器、\(PurchaseManager.freeMaterialCaseCount) 个史料案例、\(PurchaseManager.freeDuelCount) 个 Boss 双解。"
    }

    static var unlockSummary: String {
        "解锁后：高中必修/选必/冲刺主线、高考权重套练、史料题题型池、历史规律引擎、时间轴宇宙、史料侦探、制度演变剧本、地图空间、Boss 双解和复习闭环全部开放。"
    }

    static var paywallFootnote: String {
        "一次买断，永久使用；无订阅、无续费，换机后可恢复购买。"
    }

    static var pillars: [PremiumPillar] {
        [
            PremiumPillar(
                icon: "map",
                title: "完整登顶主线",
                detail: "从初中通史到高中必修、选必和冲刺专题，\(MainLineData.nodes.count) 关按历史时空和高考权重串起来。",
                metric: "\(MainLineData.nodes.count) 关"
            ),
            PremiumPillar(
                icon: "text.book.closed",
                title: "深度背诵考点",
                detail: "S/A 高频点不只一句话，包含必背原文、易混辨析、答题模板和高分答案句。",
                metric: "\(MainLineData.allKnowledgePoints.filter(\.hasDeepExplanation).count) 个深讲"
            ),
            PremiumPillar(
                icon: "sparkles.rectangle.stack",
                title: "历史规律引擎",
                detail: "把治理、近代化、经济结构、思想解放、世界体系和史料实证抽成可迁移模型，减少死背散点。",
                metric: "\(HistoryPatternData.all.count) 条"
            ),
            PremiumPillar(
                icon: "pencil.and.list.clipboard",
                title: "高考比例套练",
                detail: "按 48 分选择题 + 52 分非选择题组织训练，不用题目数量冒充分值权重。",
                metric: "48/52"
            ),
            PremiumPillar(
                icon: "text.append",
                title: "史料题题型池",
                detail: "覆盖史料分析、背景原因、影响意义、观点评析、历史小论文，采分点和自查清单一起给。",
                metric: "\(SubjectiveQuestionType.allCases.count) 类"
            ),
            PremiumPillar(
                icon: "scissors",
                title: "史学实验室",
                detail: "时间轴宇宙、史料侦探、制度演变剧本、地图空间、武器雷达，解决历史学科独有题型。",
                metric: "\(MaterialCaseData.all.count) 案例"
            ),
            PremiumPillar(
                icon: "shield.lefthalf.filled",
                title: "秒杀武器库",
                detail: "时间轴锚点、史料实证、因果链、比较矩阵、世界体系、小论文六步法等方法直接配题练。",
                metric: "\(WeaponGuideData.all.count) 把"
            ),
            PremiumPillar(
                icon: "bolt.shield",
                title: "Boss 双解对决",
                detail: "同一题对比常规解和武器解，展示为什么能更快、更稳、更像答案。",
                metric: "\(BossDuelData.all.count) 场"
            )
        ]
    }

    static var heroBenefits: [PremiumBenefit] {
        [
            PremiumBenefit(icon: "doc.text.magnifyingglass",
                           color: .apexLava,
                           title: "解锁 \(ExamPracticeData.all.count) 套高考比例套练",
                           detail: "按分值权重排题：16 道选择题练排雷，4 道非选择题练采分。"),
            PremiumBenefit(icon: "text.append",
                           color: .apexMystery,
                           title: "解锁非选择题题型池",
                           detail: "史料分析、背景原因、影响意义、观点评析、历史小论文不再混成一种“主观题”。"),
            PremiumBenefit(icon: "sparkles.rectangle.stack",
                           color: .apexViolet,
                           title: "解锁历史规律引擎",
                           detail: "把难背考点压缩成可迁移规律：看到材料信号，直接套步骤和高分句。"),
            PremiumBenefit(icon: "scissors",
                           color: .apexGold,
                           title: "解锁史学实验室",
                           detail: "时间轴、史料侦探、制度演变、地图空间和武器雷达，专门对应历史高分能力。"),
            PremiumBenefit(icon: "tablecells",
                           color: .apexEmerald,
                           title: "解锁历史主体矩阵",
                           detail: "皇帝、士人、资产阶级、人民群众等主体归位，避免把时代主体写串。"),
            PremiumBenefit(icon: "shield.lefthalf.filled",
                           color: .apexStarBlue,
                           title: "解锁全套 \(WeaponGuideData.all.count) 把秒杀武器",
                           detail: "时间轴锚点、史料实证、比较矩阵、世界体系、小论文六步法，每把武器都接回练习。"),
            PremiumBenefit(icon: "infinity",
                           color: .apexGold,
                           title: "一次买断，永久使用",
                           detail: "无订阅、无续费，内容持续更新，支持换机恢复购买。")
        ]
    }

    static var qualityStats: [PremiumQualityStat] {
        [
            PremiumQualityStat(title: "知识点练习覆盖", value: "\(coveragePercent)%", detail: "\(MainLineData.allKnowledgePoints.count) 个考点全部接选择题和非选择题"),
            PremiumQualityStat(title: "高考题型结构", value: "48/52", detail: "套练按选择题 48 分、非选择题 52 分组织"),
            PremiumQualityStat(title: "主观题题型池", value: "\(SubjectiveQuestionType.allCases.count) 类", detail: "材料分析、原因背景、影响意义、观点评析、历史小论文"),
            PremiumQualityStat(title: "专属提分模块", value: "\(HistoryPatternData.all.count + TimeMuseumData.all.count + HistoryEncounterData.all.count) 个", detail: "规律引擎、穿越策展馆、时空会客厅形成记忆钩子")
        ]
    }

    static var unlockComparison: [PremiumUnlockComparison] {
        [
            PremiumUnlockComparison(free: "初中通史打底", premium: "高中必修、选必、冲刺完整 28 关"),
            PremiumUnlockComparison(free: "少量史料案例体验", premium: "\(MaterialCaseData.all.count) 个材料切片，覆盖全部主线节点"),
            PremiumUnlockComparison(free: "1 场 Boss 双解", premium: "\(BossDuelData.all.count) 场 Boss，对比常规解和武器解"),
            PremiumUnlockComparison(free: "\(PurchaseManager.freeWeaponCount) 把基础武器", premium: "\(WeaponGuideData.all.count) 把完整史学武器并接回练习")
        ]
    }

    private static var coveragePercent: Int {
        let total = MainLineData.allKnowledgePoints.count
        guard total > 0 else { return 0 }
        let choiceIds = Set(QuestionBank.all.map(\.knowledgeId))
        let subjectiveIds = Set(SubjectiveQuestionData.all.map(\.knowledgeId))
        let covered = MainLineData.allKnowledgePoints.filter { choiceIds.contains($0.id) && subjectiveIds.contains($0.id) }.count
        return Int((Double(covered) / Double(total) * 100).rounded())
    }
}

struct PremiumPillar: Identifiable {
    let icon: String
    let title: String
    let detail: String
    let metric: String

    var id: String { title }
}

struct PremiumBenefit: Identifiable {
    let icon: String
    let color: Color
    let title: String
    let detail: String

    var id: String { title }
}

struct PremiumQualityStat: Identifiable {
    let title: String
    let value: String
    let detail: String

    var id: String { title }
}

struct PremiumUnlockComparison: Identifiable {
    let free: String
    let premium: String

    var id: String { "\(free)-\(premium)" }
}
