import SwiftUI

enum Stage: String, Codable, CaseIterable, Identifiable {
    case junior
    case required
    case elective
    case sprint

    var id: String { rawValue }

    var title: String {
        switch self {
        case .junior: return "初中 · 通史打底"
        case .required: return "高中必修 · 高考主战场"
        case .elective: return "选择性必修 · 专题突破"
        case .sprint: return "冲刺 · 史料与小论文"
        }
    }

    var shortTitle: String {
        switch self {
        case .junior: return "初中"
        case .required: return "必修"
        case .elective: return "选必"
        case .sprint: return "冲刺"
        }
    }

    var mark: String {
        switch self {
        case .junior: return "基"
        case .required: return "核"
        case .elective: return "拓"
        case .sprint: return "战"
        }
    }

    var subtitle: String {
        switch self {
        case .junior: return "中国古代 · 近代探索 · 世界启蒙"
        case .required: return "中外纲要 · 制度经济 · 民族国家"
        case .elective: return "国家制度 · 经济社会 · 文化交流"
        case .sprint: return "史料实证 · 阶段特征 · 小论文"
        }
    }

    var color: Color {
        switch self {
        case .junior: return .stageJunior
        case .required: return .stageRequired
        case .elective: return .stageElective
        case .sprint: return .stageSprint
        }
    }
}
