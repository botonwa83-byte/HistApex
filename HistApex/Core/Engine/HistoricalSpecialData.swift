import SwiftUI

enum HistoricalSpecialKind: String, CaseIterable, Identifiable {
    case timeline = "时间轴宇宙"
    case detective = "史料侦探"
    case institution = "制度演变剧本"
    case mapSpace = "地图空间"
    case weaponRadar = "武器雷达"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .timeline: return "timeline.selection"
        case .detective: return "doc.text.magnifyingglass"
        case .institution: return "building.columns"
        case .mapSpace: return "map"
        case .weaponRadar: return "scope"
        }
    }

    var color: Color {
        switch self {
        case .timeline: return .apexLava
        case .detective: return .apexMystery
        case .institution: return .apexStarBlue
        case .mapSpace: return .apexEmerald
        case .weaponRadar: return .apexGold
        }
    }
}

struct HistoricalSpecialModule: Identifiable {
    let kind: HistoricalSpecialKind
    let title: String
    let subtitle: String
    let method: String
    let examples: [String]
    let linkedKnowledgeIds: [String]

    var id: String { kind.rawValue }
}

enum HistoricalSpecialData {
    static let all: [HistoricalSpecialModule] = [
        HistoricalSpecialModule(
            kind: .timeline,
            title: "时间轴宇宙",
            subtitle: "参考 PhysicsApex 知识宇宙，把历史知识按时空连续性展开。",
            method: "先定位朝代/年代，再判断阶段特征，最后把事件放进前后变迁中解释。",
            examples: ["秦汉大一统", "唐宋变革", "晚清救亡", "冷战与多极化"],
            linkedKnowledgeIds: ["k1101", "k1202", "k1401", "k2104"]
        ),
        HistoricalSpecialModule(
            kind: .detective,
            title: "史料侦探",
            subtitle: "参考 ChemApex 化学神探，把史料题做成线索推理。",
            method: "按出处、时间、作者立场、材料信息、史料限度五步破案。",
            examples: ["奏折与地方志互证", "商人账簿看市镇经济", "回忆录的立场限度"],
            linkedKnowledgeIds: ["k2501", "k2502", "k2601"]
        ),
        HistoricalSpecialModule(
            kind: .institution,
            title: "制度演变剧本",
            subtitle: "参考 ChemApex 方程式剧本/工艺流程，把制度变化做成因果流程。",
            method: "治理问题 -> 制度设计 -> 运行效果 -> 历史影响 -> 局限反思。",
            examples: ["分封制到郡县制", "科举制成熟", "行省制度", "英国君主立宪制"],
            linkedKnowledgeIds: ["k1101", "k1202", "k1301", "k1901", "k2201"]
        ),
        HistoricalSpecialModule(
            kind: .mapSpace,
            title: "地图空间",
            subtitle: "历史不是只背时间，空间位置决定交流、战争、贸易和制度选择。",
            method: "先看地理通道、资源位置和交通路线，再解释文明交流和政治经济格局。",
            examples: ["丝绸之路", "新航路开辟", "地中海世界", "欧亚大陆交流"],
            linkedKnowledgeIds: ["k0804", "k1801", "k2401"]
        ),
        HistoricalSpecialModule(
            kind: .weaponRadar,
            title: "武器雷达",
            subtitle: "参考 PhysicsApex 武器雷达，训练拿到题 30 秒内判断用哪种史学方法。",
            method: "看题干关键词，选择时间轴、史料实证、比较矩阵、因果链、小论文六步法。",
            examples: ["比较英美法制度", "评价洋务运动", "论证制度创新", "分析工业革命影响"],
            linkedKnowledgeIds: ["k1901", "k2001", "k2701", "k2801"]
        )
    ]

    static func modules(knowledgeId: String) -> [HistoricalSpecialModule] {
        all.filter { $0.linkedKnowledgeIds.contains(knowledgeId) }
    }

    static func modules(for weapon: HistoryWeapon) -> [HistoricalSpecialModule] {
        switch weapon {
        case .timelineAnchor, .stageFeature, .continuityChange:
            return all.filter { $0.kind == .timeline }
        case .materialEvidence, .historiographyView:
            return all.filter { $0.kind == .detective }
        case .institutionEvolution, .conceptBoundary, .comparisonMatrix:
            return all.filter { $0.kind == .institution }
        case .mapSpace, .cultureExchange, .worldSystem:
            return all.filter { $0.kind == .mapSpace }
        case .choiceTrapFilter, .essayArgument, .openEssaySixSteps, .causalityChain, .economyStructure:
            return all.filter { $0.kind == .weaponRadar }
        }
    }
}
