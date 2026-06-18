import Foundation

enum TrapDrillData {
    static let all: [TrapDrill] = [
        drill("trap_time", .scopeOverreach, "k1101", "材料时间为秦朝，选项却说行省制度已经普遍推行。", "把元代行省制度前置到秦朝。", "错在时间错位", "秦朝地方制度核心是郡县制，行省制度属于元代。"),
        drill("trap_subject", .subjectMismatch, "k1501", "材料讨论新文化运动，选项归纳为洋务派自强求富。", "把新文化运动主体说成洋务派。", "错在主体错配", "新文化运动主体主要是先进知识分子，核心议题是思想文化启蒙。"),
        drill("trap_cause", .causalityReversed, "k1801", "材料反映新航路开辟后的价格革命。", "价格革命导致新航路开辟。", "错在因果倒置", "新航路开辟推动贵金属流入欧洲，引发价格革命。"),
        drill("trap_abs", .absoluteTerm, "k1901", "英国君主立宪制确立后仍经历长期发展。", "1689年后英国国王立即失去全部权力。", "错在绝对化", "英国制度演进具有渐进性，国王权力受限但并非瞬间消失。"),
        drill("trap_source", .irrelevant, "k2501", "材料出自官方奏折，反映地方官看法。", "该材料可以完整反映所有社会阶层态度。", "错在史料限度", "史料有立场和范围，不能从单一材料推出整体态度。")
    ]

    static func drills(category: TrapCategory) -> [TrapDrill] { all.filter { $0.category == category } }

    private static func drill(_ id: String, _ category: TrapCategory, _ knowledgeId: String, _ stem: String, _ trap: String, _ verdict: String, _ correction: String) -> TrapDrill {
        TrapDrill(id: id, category: category, knowledgeId: knowledgeId, stem: stem, trapOption: trap, verdict: verdict, correction: correction, explanation: "历史选择题先排时间、主体、因果和史料限度。")
    }
}

enum SubjectMatrixData {
    static let all: [SubjectResponsibility] = [
        subject("sub_emperor", "皇帝与中央政府", "中央集权核心", ["设置官僚机构", "强化地方控制", "整合资源"], ["不能等同于现代民主政府", "不能直接套用近代民族国家概念"], ["皇帝", "中央集权", "郡县"], ["k1101", "k1301"]),
        subject("sub_gentry", "士人/士绅", "制度与地方社会之间的中介", ["参加科举", "传播儒学", "参与地方治理"], ["不能代表全部民众", "不能脱离国家制度单独解释"], ["士人", "科举", "地方"], ["k1202", "k2201"]),
        subject("sub_bourgeois", "资产阶级", "近代政治经济转型主体之一", ["推动代议制", "发展资本主义经济", "传播启蒙思想"], ["不能代表所有社会阶层", "不能忽视无产阶级和人民群众"], ["资产阶级", "革命", "议会"], ["k1901", "k1902"]),
        subject("sub_people", "人民群众", "历史创造者", ["参与革命和建设", "推动社会变迁", "创造物质和精神财富"], ["不能只写英雄人物", "不能忽视群众基础"], ["群众", "工农", "社会运动"], ["k1602", "k1701"])
    ]

    private static func subject(_ id: String, _ title: String, _ role: String, _ can: [String], _ cannot: [String], _ triggers: [String], _ ids: [String]) -> SubjectResponsibility {
        SubjectResponsibility(id: id, title: title, role: role, canDo: can, cannotDo: cannot, triggerWords: triggers, knowledgeIds: ids)
    }
}

enum AnswerTemplateData {
    static let all: [AnswerTemplate] = [
        template("tpl_background", "背景原因类", "背景、原因、条件", ["定时代", "分政治经济思想外部因素", "写直接原因和根本原因"], ["从时代背景看……", "其出现与……密切相关"], "新航路开辟既有商品经济发展和资本主义萌芽的经济动因，也有奥斯曼阻隔传统商路、航海技术进步等条件。"),
        template("tpl_impact", "影响意义类", "影响、意义、作用", ["当时影响", "长远影响", "积极与局限"], ["推动了……", "同时也带来……"], "工业革命推动生产力飞跃和城市化发展，也加剧阶级矛盾并改变世界市场结构。"),
        template("tpl_compare", "比较类", "比较、异同、变化", ["比较背景", "比较内容", "比较影响"], ["二者相同点在于……", "不同点表现为……"], "英美制度都体现代议制原则，但权力结构、国家元首地位和形成路径存在差异。"),
        template("tpl_evaluate", "评析类", "评析、评价、认识", ["亮观点", "摆史实", "析得失", "扣主题"], ["这一观点有合理性，因为……", "但也应看到……"], "评价洋务运动既要看到其推动近代工业起步，也要看到其未触动封建制度根基。"),
        template("tpl_essay", "历史小论文", "论述、阐释、自拟论题", ["提炼主题", "明确观点", "两到三个史实论证", "总结升华"], ["观点：……", "论证：……", "综上……"], "观点：制度创新推动国家治理能力提升。可用秦郡县制、隋唐科举制、元行省制等史实论证。")
    ]

    static func templates(for point: KnowledgePoint, node: LearningNode) -> [AnswerTemplate] {
        let ids: [String]
        switch node.weaponUnlocked {
        case .causalityChain:
            ids = ["tpl_background", "tpl_impact"]
        case .comparisonMatrix, .continuityChange, .institutionEvolution:
            ids = ["tpl_compare", "tpl_impact"]
        case .materialEvidence, .historiographyView, .conceptBoundary:
            ids = ["tpl_evaluate", "tpl_essay"]
        case .worldSystem, .economyStructure, .cultureExchange, .mapSpace:
            ids = ["tpl_background", "tpl_impact", "tpl_compare"]
        case .choiceTrapFilter:
            ids = ["tpl_evaluate", "tpl_compare"]
        case .essayArgument, .openEssaySixSteps:
            ids = ["tpl_essay", "tpl_evaluate"]
        case .timelineAnchor, .stageFeature, .none:
            ids = ["tpl_background", "tpl_impact"]
        }

        let matched = all.filter { ids.contains($0.id) }
        if matched.isEmpty {
            return Array(all.prefix(2))
        }
        return matched
    }

    private static func template(_ id: String, _ title: String, _ prompt: String, _ structure: [String], _ starters: [String], _ sample: String) -> AnswerTemplate {
        AnswerTemplate(id: id, title: title, promptType: prompt, structure: structure, sentenceStarters: starters, diagnostics: ["是否定时空", "是否有史实", "是否有逻辑", "是否有评价"], sample: sample)
    }
}
