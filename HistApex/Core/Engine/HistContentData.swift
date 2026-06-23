import Foundation

enum MainLineData {
    static let nodes: [LearningNode] = assignOrder([
        node(1, .junior, .juniorAncient, "中华文明起源与早期国家", "先立时间轴：史前、夏商周、春秋战国", .timelineAnchor, ["中华文明多元一体", "早期国家与礼乐制度", "春秋战国社会转型", "百家争鸣"]),
        node(2, .junior, .juniorAncient, "秦汉统一多民族国家", "统一、郡县、儒学、丝路是四个锚点", .institutionEvolution, ["秦统一与中央集权", "汉武帝大一统", "丝绸之路", "儒学正统地位"]),
        node(3, .junior, .juniorAncient, "魏晋隋唐制度与开放", "民族交融、制度创新、开放气象", .stageFeature, ["三国两晋南北朝民族交融", "隋唐科举三省六部", "唐代中外交流", "唐宋变革前夜"]),
        node(4, .junior, .juniorAncient, "宋元明清经济文化", "经济重心、商品经济、专制强化、边疆治理", .continuityChange, ["宋代经济重心南移", "元明清统一多民族国家", "明清君主专制强化", "传统科技文化"]),
        node(5, .junior, .juniorModern, "晚清危机与近代化起步", "外来冲击下的制度、经济、思想变动", .causalityChain, ["鸦片战争与条约体系", "洋务运动", "戊戌变法", "辛亥革命"]),
        node(6, .junior, .juniorModern, "新民主主义革命", "从五四到新中国成立，抓主要矛盾变化", .stageFeature, ["五四运动", "中国共产党成立", "国共关系变化", "新民主主义革命胜利"]),
        node(7, .junior, .juniorModern, "社会主义建设与改革开放", "制度建立、曲折探索、改革开放、高质量发展", .timelineAnchor, ["新中国成立与制度建立", "社会主义建设探索", "改革开放", "新时代中国"]),
        node(8, .junior, .juniorWorld, "世界古代文明与中古世界", "文明多样性和区域交流并重", .mapSpace, ["古代亚非文明", "古希腊罗马", "中古欧洲", "阿拉伯帝国与文明交流"]),
        node(9, .junior, .juniorWorld, "世界近现代转型", "资本主义、民族国家、工业化、国际秩序", .worldSystem, ["新航路开辟", "资产阶级革命", "工业革命", "两次世界大战与战后格局"]),
        node(10, .required, .ancientChina, "先秦政治与思想转型", "分封宗法到变法集权，百家争鸣是思想镜像", .stageFeature, ["分封制宗法制", "铁犁牛耕与小农经济", "商鞅变法", "百家争鸣"]),
        node(11, .required, .ancientChina, "秦汉大一统秩序", "中央集权、郡县、察举、儒学、丝路", .institutionEvolution, ["皇帝制度与郡县制", "汉代察举制", "独尊儒术", "丝绸之路与边疆治理"]),
        node(12, .required, .ancientChina, "隋唐宋元制度经济", "科举、三省六部、经济重心南移、市民文化", .comparisonMatrix, ["三省六部制", "科举制成熟", "宋代商品经济", "元代行省制度"]),
        node(13, .required, .ancientChina, "明清国家治理与社会变动", "专制强化、海禁开放、白银流入、早期启蒙", .continuityChange, ["内阁军机处", "明清赋役制度", "白银货币化", "明清思想文化"]),
        node(14, .required, .modernChina, "晚清民族危机与救亡探索", "侵略、抗争、近代化三条线合看", .causalityChain, ["列强侵略与不平等条约", "太平天国与义和团", "洋务运动", "维新变法"]),
        node(15, .required, .modernChina, "辛亥革命与民国转型", "共和制度、社会生活、新文化运动", .materialEvidence, ["辛亥革命", "中华民国建立", "民族资本主义发展", "新文化运动"]),
        node(16, .required, .modernChina, "中共革命道路与民族解放", "道路探索、统一战线、抗战、解放战争", .stageFeature, ["五四运动与中共成立", "工农武装割据", "全民族抗战", "人民解放战争"]),
        node(17, .required, .modernChina, "新中国制度建设与现代化", "制度、工业化、外交、改革开放", .timelineAnchor, ["人民政权巩固", "一五计划与三大改造", "中国特色大国外交", "改革开放与市场经济"]),
        node(18, .required, .worldHistory, "新航路与早期全球联系", "世界市场雏形、殖民扩张、文明碰撞", .worldSystem, ["新航路开辟原因", "早期殖民扩张", "商业革命和价格革命", "全球联系加强"]),
        node(19, .required, .worldHistory, "欧美资产阶级革命与制度", "英美法制度差异和启蒙思想影响", .comparisonMatrix, ["英国君主立宪制", "美国共和制", "法国大革命", "启蒙运动"]),
        node(20, .required, .worldHistory, "工业革命与世界市场", "生产力、阶级结构、城市化、世界体系", .economyStructure, ["第一次工业革命", "第二次工业革命", "马克思主义诞生", "资本主义世界市场形成"]),
        node(21, .required, .worldHistory, "两次世界大战与国际格局", "凡尔赛华盛顿、雅尔塔、冷战、多极化", .worldSystem, ["一战与凡尔赛体系", "二战与反法西斯联盟", "冷战格局", "世界多极化趋势"]),
        node(22, .elective, .stateSystem, "国家制度与治理演变", "把制度放回时代需求和治理能力中理解", .institutionEvolution, ["中国古代官僚制度", "近现代民主制度", "基层治理传统", "国家治理现代化"]),
        node(23, .elective, .economySociety, "经济结构与社会生活", "农业、手工业、商业、工业化和生活变迁", .economyStructure, ["小农经济", "商品经济发展", "工业化道路", "社会生活变迁"]),
        node(24, .elective, .culturalExchange, "文化交流与文明互鉴", "传播路线、接受改造、互动影响", .cultureExchange, ["丝绸之路文化交流", "佛教传播中国化", "西学东渐", "全球化下文化交流"]),
        node(25, .elective, .historicalMethod, "史料实证与解释", "材料出处、立场、信息、限度四问", .materialEvidence, ["一手史料与二手史料", "史料价值与局限", "历史解释", "史论结合"]),
        node(26, .elective, .historicalMethod, "历史概念与史观", "概念边界和史观转换决定高分上限", .historiographyView, ["革命史观", "现代化史观", "全球史观", "文明史观"]),
        node(27, .sprint, .sprint, "选择题陷阱与高频主题", "时间、主体、因果、程度、史料出处五排雷", .choiceTrapFilter, ["时间错位", "主体错配", "因果倒置", "绝对化表述"]),
        node(28, .sprint, .sprint, "史料题与历史小论文", "提观点、找证据、建逻辑、扣主题", .openEssaySixSteps, ["史料题四步", "比较题矩阵", "小论文论证", "开放题评分点"])
    ])

    static var allKnowledgePoints: [KnowledgePoint] { nodes.flatMap { $0.knowledgePoints } }

    static func coveragePoints(for node: LearningNode) -> [KnowledgePoint] { node.knowledgePoints }
    static func node(id: String) -> LearningNode? { nodes.first { $0.id == id } }
    static func knowledge(id: String) -> KnowledgePoint? { allKnowledgePoints.first { $0.id == id } }

    private static func node(_ order: Int,
                             _ stage: Stage,
                             _ topic: HistoryTopic,
                             _ title: String,
                             _ tagline: String,
                             _ weapon: HistoryWeapon,
                             _ titles: [String]) -> LearningNode {
        let points = titles.enumerated().map { index, title in
            kp(nodeOrder: order, item: index + 1, title: title, topic: topic, weapon: weapon)
        }
        return LearningNode(id: "n\(String(format: "%02d", order))",
                            order: order,
                            stage: stage,
                            topic: topic,
                            title: title,
                            tagline: tagline,
                            knowledgePoints: points,
                            practiceIds: points.map { "q_n\(String(format: "%02d", order))_\($0.id)_0" },
                            bossCaseId: order % 2 == 0 ? "duel_\(String(format: "%02d", order))" : nil,
                            weaponUnlocked: weapon)
    }

    private static func kp(nodeOrder: Int,
                           item: Int,
                           title: String,
                           topic: HistoryTopic,
                           weapon: HistoryWeapon) -> KnowledgePoint {
        let id = "k\(String(format: "%02d", nodeOrder))\(String(format: "%02d", item))"
        let grade: ImportanceGrade = item <= 2 ? .s : .a
        let type: MemoryCardType = item == 1 ? .original : (item == 2 ? .boundary : (item == 3 ? .scene : .template))
        let genericDetail = "\(title) 是 \(topic.name) 的高频考点。复习时要放进具体时代背景，说明原因、过程、影响，并能用史料证据支撑判断。"
        let genericPitfall = "历史题不能只背结论，必须交代时空背景、材料依据和因果链。"
        let authored = AuthoredKnowledgeData.explanations[id]
        return KnowledgePoint(id: id,
                              title: title,
                              detail: authored?.mustRecite.first ?? genericDetail,
                              grade: grade,
                              cardType: type,
                              pitfall: authored?.commonTraps.first ?? genericPitfall,
                              keywords: [title, topic.name, weapon.name],
                              explanation: authored ?? explanation(title: title, topic: topic, weapon: weapon))
    }

    private static func explanation(title: String, topic: HistoryTopic, weapon: HistoryWeapon) -> KnowledgeExplanation {
        KnowledgeExplanation(
            mustRecite: [
                "\(title) 要放在 \(topic.name) 的时空坐标中理解。",
                "答题必须同时写史实、因果和影响，不能只写单句结论。",
                "材料题要先看出处、时间、立场和关键词，再提炼有效信息。"
            ],
            plainExplanation: "历史高分不是背孤立事件，而是把事件放回时代：为什么发生、怎样发展、改变了什么、和前后阶段有什么关系。",
            answerTemplate: [
                "背景：从政治、经济、思想文化或国际环境中选最贴材料的两点。",
                "过程：按时间顺序或主体行动写清变化。",
                "影响：分当时影响和长远影响，必要时补局限。"
            ],
            triggerScenes: ["出现时间线索", "出现史料出处", "要求比较变化", "要求评价观点"],
            confusions: ["原因不等于背景，影响不等于意义。", "史料信息不等于完整史实，必须注意史料立场和限度。"],
            commonTraps: ["时间错位。", "把后世结论套回当时。", "只摘材料不调动所学。"],
            sampleAnswerSentences: [
                "答案：\(title) 要解释为 \(topic.name) 中具体时空下的制度、经济、思想或国际关系变化，不能只写名词。",
                "为什么：题干出现 \(weapon.name) 相关线索时，要用材料证据说明它回应了什么现实问题，并写清当时作用与后续影响。"
            ],
            reciteChecklist: ["时间", "背景", "主体", "措施/过程", "影响", "局限"]
        )
    }

    private static func assignOrder(_ list: [LearningNode]) -> [LearningNode] { list }
}

enum QuestionBank {
    static let generated: [HistoryQuestion] = MainLineData.nodes.flatMap { node in
        MainLineData.coveragePoints(for: node).flatMap { point in
            (0..<questionCount(for: point.grade)).map { makeQuestion(node: node, point: point, variant: $0) }
        }
    }

    static let all: [HistoryQuestion] = AuthoredQuestionData.all + generated

    static func questions(topic: HistoryTopic) -> [HistoryQuestion] { all.filter { $0.topic == topic } }
    static func questions(nodeId: String) -> [HistoryQuestion] { all.filter { $0.nodeId == nodeId } }
    static func question(id: String) -> HistoryQuestion? { all.first { $0.id == id } }

    static func questionCount(for grade: ImportanceGrade) -> Int {
        switch grade {
        case .s: return 4
        case .a: return 3
        case .b: return 2
        case .c: return 1
        }
    }

    private static func makeQuestion(node: LearningNode, point: KnowledgePoint, variant: Int) -> HistoryQuestion {
        let scene = choiceScene(node: node, point: point, variant: variant)
        var options = scene.options
        let shift = variant % options.count
        options = Array(options[shift..<options.count] + options[0..<shift])
        return HistoryQuestion(id: "q_\(node.id)_\(point.id)_\(variant)",
                               nodeId: node.id,
                               knowledgeId: point.id,
                               topic: node.topic,
                               stage: node.stage,
                               prompt: scene.prompt,
                               options: options,
                               answerIndex: options.firstIndex(of: scene.correct) ?? 0,
                               explanation: scene.explanation,
                               trapTags: scene.trapTags,
                               weapon: node.weaponUnlocked)
    }

    private struct ChoiceScene {
        let prompt: String
        let correct: String
        let options: [String]
        let explanation: String
        let trapTags: [String]
    }

    private static func choiceScene(node: LearningNode, point: KnowledgePoint, variant: Int) -> ChoiceScene {
        let anchor = point.explanation.triggerScenes[safe: variant] ?? point.title
        switch variant % 4 {
        case 0:
            let correct = "应把\(point.title)放回\(node.title)的阶段背景中，先判时代再判结论。"
            return ChoiceScene(
                prompt: "材料出现“\(anchor)”等信息时，判断「\(point.title)」最先要抓住的是：",
                correct: correct,
                options: [
                    correct,
                    "只要材料关键词相近，就可以套用任意朝代或国家的结论。",
                    "先背最终评价，不必区分事件发生的具体阶段。",
                    "优先选择范围最大、语气最绝对的表述。"
                ],
                explanation: "答案：\(correct)。原因：\(point.title)属于\(node.title)中的\(node.topic.name)考点，题干给出“\(anchor)”时，先定时间和阶段，才能判断该现象的性质；错项通常把后世结论、绝对化表述或跨时代说法套回当时。",
                trapTags: ["时间错位", "阶段误判", "绝对化"]
            )
        case 1:
            let correct = "分析\(point.title)时，要把材料有效信息与所学史实互证，不能只摘一句材料作结论。"
            return ChoiceScene(
                prompt: "若题干给出一段关于「\(point.title)」的史料，最稳妥的解题路径是：",
                correct: correct,
                options: [
                    correct,
                    "材料出现\(point.keywords.first ?? point.title)一词，就直接等同于教材中的完整结论。",
                    "\(node.topic.name)史料只要能证明观点，就不必看出处、立场和限度。",
                    "遇到\(point.title)史料题应优先排除所有涉及所学知识的选项。"
                ],
                explanation: "答案：\(correct)。原因：材料只能证明它直接呈现的信息，\(point.title)还要结合\(node.title)的相关史实解释；只抓关键词会把材料证据误当完整结论，容易忽略出处、立场和史料限度。",
                trapTags: ["史论脱节", "材料误读", "过度推断"]
            )
        case 2:
            let correct = "理解\(point.title)应按背景、触发、过程、影响搭出因果链，区分直接原因和深层原因。"
            return ChoiceScene(
                prompt: "从因果关系看，理解「\(point.title)」最容易得分的表述是：",
                correct: correct,
                options: [
                    correct,
                    "把\(node.title)中时间上先发生的现象都写成\(point.title)的根本原因。",
                    "只写\(point.title)的结果，不需要说明推动变化的条件。",
                    "把材料中的个别人物行动当作\(node.topic.name)变化的唯一决定因素。"
                ],
                explanation: "答案：\(correct)。原因：\(point.title)的形成或推进不是单一原因造成的，要把\(node.title)中的背景条件、直接触发、过程和影响串成因果链；只写结果或个别人物行动会漏掉结构性条件。",
                trapTags: ["因果倒置", "单因解释", "范围扩大"]
            )
        default:
            let correct = "比较\(point.title)时应同时看背景、主体、方式和结果，不能只找表面相似词。"
            return ChoiceScene(
                prompt: "把「\(point.title)」与同类历史现象比较时，下列方法最合理的是：",
                correct: correct,
                options: [
                    correct,
                    "只比较\(point.title)与同类现象名称是否相似，不必看制度环境和历史任务。",
                    "只要\(node.topic.name)中两个现象结果相近，就说明二者性质完全相同。",
                    "比较\(point.title)时优先写共同点，差异和时代背景可以省略。"
                ],
                explanation: "答案：\(correct)。原因：\(point.title)与同类现象的性质取决于时代背景、行动主体、实现方式和历史结果；只看名称或结果相似会造成机械类比，无法判断真正差异。",
                trapTags: ["概念混淆", "主体错配", "机械类比"]
            )
        }
    }
}

enum SubjectiveQuestionData {
    static let generated: [SubjectiveQuestion] = MainLineData.nodes.flatMap { node in
        MainLineData.coveragePoints(for: node).enumerated().map { index, point in
            let scene = subjectiveScene(node: node, point: point, index: index)
            return SubjectiveQuestion(id: "sq_\(node.id)_\(point.id)",
                                      nodeId: node.id,
                                      knowledgeId: point.id,
                                      grade: point.grade,
                                      questionType: scene.type,
                                      score: scene.score,
                                      material: scene.material,
                                      prompt: scene.prompt,
                                      answerPoints: scene.answerPoints,
                                      diagnostics: scene.diagnostics)
        }
    }

    static let all: [SubjectiveQuestion] = AuthoredSubjectiveQuestionData.all + generated

    static func questions(nodeId: String) -> [SubjectiveQuestion] { all.filter { $0.nodeId == nodeId } }
    static func questions(topic: HistoryTopic) -> [SubjectiveQuestion] { all.filter { MainLineData.node(id: $0.nodeId)?.topic == topic } }
    static func questions(knowledgeId: String) -> [SubjectiveQuestion] { all.filter { $0.knowledgeId == knowledgeId } }

    private struct SubjectiveScene {
        let type: SubjectiveQuestionType
        let score: Int
        let material: String
        let prompt: String
        let answerPoints: [String]
        let diagnostics: [String]
    }

    private static func subjectiveScene(node: LearningNode, point: KnowledgePoint, index: Int) -> SubjectiveScene {
        let trigger = point.explanation.triggerScenes.first ?? "材料信息"
        let baseAnswers = point.sampleAnswerSentences + point.explanation.answerTemplate
        // 材料直接取自该考点的必背史实，而不是泛泛描述材料里"会有什么"，
        // 这样材料和采分点共用同一套真实内容，不再各说各话。
        let factualMaterial = "材料：" + point.mustReciteLines.joined(separator: " ")
        switch (node.order + index) % 5 {
        case 0:
            return SubjectiveScene(
                type: .materialAnalysis,
                score: 13,
                material: factualMaterial,
                prompt: "根据材料并结合所学，概括「\(point.title)」反映的历史变化。",
                answerPoints: [
                    "答案：\(point.title)反映的是\(node.title)中\(node.topic.name)由旧格局向新阶段调整的变化。",
                    "为什么：材料中的“\(trigger)”提供时空和主体行动依据，说明该变化不是孤立史实，而是阶段任务或社会矛盾的集中反映。"
                ] + baseAnswers,
                diagnostics: ["是否锁定材料时间", "是否提取有效信息", "是否联系所学", "是否写出变化方向"]
            )
        case 1:
            return SubjectiveScene(
                type: .measure,
                score: 13,
                material: factualMaterial,
                prompt: "结合材料和所学，分析「\(point.title)」出现或推进的背景原因。",
                answerPoints: [
                    "答案：\(point.title)出现或推进的原因，应从\(node.title)的现实矛盾、主体行动和\(node.topic.name)发展的需要三层回答。",
                    "为什么：材料提示“\(trigger)”，说明该考点既有直接推动因素，也有更深层的制度、经济、思想或国际背景。"
                ] + point.explanation.answerTemplate + point.mustReciteLines,
                diagnostics: ["是否区分背景与原因", "是否写出直接推动因素", "是否写出深层结构因素", "是否避免单因解释"]
            )
        case 2:
            return SubjectiveScene(
                type: .significance,
                score: 14,
                material: factualMaterial,
                prompt: "结合材料和所学，说明「\(point.title)」的历史影响。",
                answerPoints: [
                    "答案：\(point.title)的影响要分当时和长远两层：当时回应\(node.title)中的现实问题，长远改变相关制度、经济、思想或世界联系。",
                    "为什么：材料同时给出当时影响和后世评价，说明不能只写积极意义，还要说明作用边界和历史局限。"
                ] + point.sampleAnswerSentences + ["从当时看，要说明它回应了怎样的时代问题。", "从长远看，要说明它对制度、经济、思想或世界联系的影响。"],
                diagnostics: ["是否分当时和长远", "是否写积极影响", "是否补充局限", "是否回扣材料评价"]
            )
        case 3:
            return SubjectiveScene(
                type: .evaluation,
                score: 13,
                material: factualMaterial,
                prompt: "评析材料中关于「\(point.title)」的观点。",
                answerPoints: [
                    "答案：评价\(point.title)不能简单肯定或否定，应先指出材料观点，再结合\(node.title)说明其历史作用和局限。",
                    "为什么：同一史实在不同阶段会有不同功能，只有放回\(node.topic.name)的具体时空，才能避免用今天标准替代历史解释。"
                ] + point.sampleAnswerSentences + ["评价要放回具体时代，做到一分为二。"],
                diagnostics: ["是否先亮明观点", "是否史论结合", "是否一分为二", "是否避免脱离时代评价"]
            )
        default:
            return SubjectiveScene(
                type: .openInquiry,
                score: 12,
                material: factualMaterial,
                prompt: "围绕「\(point.title)」自拟论题，并用两个以上史实加以论证。",
                answerPoints: [
                    "答案：可立论题为“\(point.title)推动或体现了\(node.title)中的阶段转型”。",
                    "为什么：该论题能把考点、时代背景和变化方向连起来，便于用两个以上史实证明，而不是只罗列关键词。"
                ] + ["史实要准确并服务于论题。", "论证要体现因果、比较或变化逻辑。", "结尾回扣主题，形成完整历史解释。"],
                diagnostics: ["是否有明确论题", "是否至少两个史实", "是否有论证逻辑", "是否回扣主题"]
            )
        }
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

enum BossDuelData {
    static let all: [BossDuel] = MainLineData.nodes.enumerated().map { index, node in
        let points = node.knowledgePoints
        let leadPoint = points[0]
        let supportPoint = points[safe: 1] ?? leadPoint
        let scene = bossScene(node: node, leadPoint: leadPoint, supportPoint: supportPoint)
        return BossDuel(id: "duel_\(String(format: "%02d", index + 1))",
                        nodeId: node.id,
                        title: scene.title,
                        material: scene.material,
                        question: scene.question,
                        standard: scene.standard,
                        weaponPath: scene.weaponPath,
                        weapon: node.weaponUnlocked ?? .materialEvidence,
                        keyInsight: scene.keyInsight,
                        sampleAnswer: scene.sampleAnswer)
    }

    static func duel(id: String) -> BossDuel? { all.first { $0.id == id } }

    private struct BossScene {
        let title: String
        let material: String
        let question: String
        let standard: SolutionPath
        let weaponPath: SolutionPath
        let keyInsight: String
        let sampleAnswer: [String]
    }

    private static func bossScene(node: LearningNode, leadPoint: KnowledgePoint, supportPoint: KnowledgePoint) -> BossScene {
        let weapon = node.weaponUnlocked ?? .materialEvidence
        let topicLens = lens(for: node.topic)
        let material = "材料A以\(leadPoint.title)为中心，交代\(node.title)中的关键时空和主体行动；材料B补充\(supportPoint.title)，提示\(topicLens)的变化方向。"
        let question = "依据两则材料并结合所学，说明\(leadPoint.title)为什么能体现\(node.title)的阶段特征。"
        let standardSteps = [
            "先回忆\(leadPoint.title)的教材结论",
            "再罗列\(node.topic.name)相关背景",
            "最后补写影响，但容易漏掉材料证据"
        ]
        let weaponSteps = weaponSteps(for: weapon, leadPoint: leadPoint, supportPoint: supportPoint)
        return BossScene(
            title: "\(node.title) · \(leadPoint.title)破局",
            material: material,
            question: question,
            standard: SolutionPath(title: "常规解：背\(leadPoint.title)", steps: standardSteps, timeMinutes: 8),
            weaponPath: SolutionPath(title: "武器解：\(weapon.name)", steps: weaponSteps, timeMinutes: 3),
            keyInsight: "\(leadPoint.title)不能孤立背，要用\(supportPoint.title)补出\(topicLens)这条线。",
            sampleAnswer: [
                "答案：\(leadPoint.title)体现了\(node.title)中\(topicLens)的阶段特征，不能把它当成孤立名词背诵。",
                "为什么：材料A给出\(leadPoint.title)的时空和主体行动，材料B用\(supportPoint.title)补出制度、经济、思想或世界联系条件，两则材料共同证明变化方向。",
                "写法：先定\(node.title)的阶段，再写\(leadPoint.title)发生的原因和影响，最后用\(supportPoint.title)说明这一变化对后续历史进程的作用。"
            ]
        )
    }

    private static func lens(for topic: HistoryTopic) -> String {
        switch topic {
        case .juniorAncient, .ancientChina: return "国家治理和社会结构"
        case .juniorModern, .modernChina: return "民族危机、救亡探索和社会转型"
        case .juniorWorld, .worldHistory: return "全球联系、制度变革和世界格局"
        case .stateSystem: return "制度设计和治理能力"
        case .economySociety: return "经济结构和社会生活"
        case .culturalExchange: return "文明交流、吸收和再创造"
        case .historicalMethod: return "史料证据和历史解释"
        case .sprint: return "综合设问和评分逻辑"
        }
    }

    private static func weaponSteps(for weapon: HistoryWeapon, leadPoint: KnowledgePoint, supportPoint: KnowledgePoint) -> [String] {
        switch weapon {
        case .timelineAnchor:
            return ["圈出材料中的年代和阶段", "把\(leadPoint.title)放回前后顺序", "用\(supportPoint.title)验证阶段特征"]
        case .stageFeature:
            return ["先写阶段关键词", "用材料主体行动对应阶段任务", "把\(leadPoint.title)概括成阶段特征"]
        case .materialEvidence:
            return ["看出处和立场", "提取材料有效信息", "用\(supportPoint.title)补足所学"]
        case .causalityChain:
            return ["拆背景、触发、过程", "区分直接原因和深层原因", "把影响落到\(supportPoint.title)"]
        case .comparisonMatrix:
            return ["列背景、主体、方式、结果四格", "先比同再比异", "用差异解释\(leadPoint.title)"]
        case .continuityChange:
            return ["先找延续内容", "再找变化方向", "说明变化为何发生在此阶段"]
        case .conceptBoundary:
            return ["界定\(leadPoint.title)概念", "排除相似但错位的说法", "回到材料关键词"]
        case .mapSpace:
            return ["标出空间路线或区域", "解释空间如何影响交流", "连接\(supportPoint.title)"]
        case .institutionEvolution:
            return ["识别制度要解决的问题", "说明权力配置变化", "评价治理效果和局限"]
        case .economyStructure:
            return ["看生产、交换、分配", "找社会关系变化", "说明经济结构带来的影响"]
        case .cultureExchange:
            return ["判断传播方向", "分析本土化改造", "评价文明互鉴影响"]
        case .worldSystem:
            return ["从局部事件切入", "放入世界市场或国际格局", "写全球联系的扩大"]
        case .historiographyView:
            return ["先判断材料史观", "换史观看同一现象", "用史实支撑解释"]
        case .choiceTrapFilter:
            return ["排时间错位", "排主体错配", "排因果和程度错误"]
        case .essayArgument:
            return ["提出明确观点", "选两个史实论证", "回扣主题形成解释"]
        case .openEssaySixSteps:
            return ["审主题", "立论点", "配史实", "建逻辑", "扣结论"]
        }
    }
}

enum MemoryData {
    static let all: [MemoryCard] = MainLineData.allKnowledgePoints.flatMap { point in
        MemoryCardType.allCases.map { type in
            MemoryCard(id: "m_\(point.id)_\(type.rawValue)",
                       knowledgeId: point.id,
                       type: type,
                       grade: point.grade,
                       front: "\(type.rawValue)：\(point.title)",
                       back: cardBack(point: point, type: type),
                       mode: type == .original ? .recite : .apply)
        }
    }

    static func cards(type: MemoryCardType) -> [MemoryCard] { all.filter { $0.type == type } }
    static func highWeight(limit: Int) -> [MemoryCard] { Array(all.filter { $0.grade == .s || $0.grade == .a }.prefix(limit)) }

    private static func cardBack(point: KnowledgePoint, type: MemoryCardType) -> String {
        switch type {
        case .original: return point.mustReciteLines.joined(separator: "\n")
        case .boundary: return point.commonTrapLines.joined(separator: "\n")
        case .subject: return "主体/对象：\(point.keywords.joined(separator: "、"))"
        case .scene: return point.explanation.triggerScenes.joined(separator: "\n")
        case .template: return point.explanation.answerTemplate.joined(separator: "\n")
        }
    }
}

enum MaterialCaseData {
    static let all: [MaterialCase] = MainLineData.nodes.map { node in
        let ids = node.knowledgePoints.prefix(3).map(\.id)
        let first = node.knowledgePoints[0]
        let second = node.knowledgePoints[safe: 1] ?? first
        let third = node.knowledgePoints[safe: 2] ?? second
        return MaterialCase(id: "case_\(node.id)",
                            title: "\(node.title) · \(first.title)材料切片",
                            material: materialText(node: node, first: first, second: second),
                            question: questionText(node: node, first: first, third: third),
                            subject: subjectText(for: node.topic),
                            action: actionText(for: node.weaponUnlocked ?? .materialEvidence, first: first),
                            object: node.topic.name,
                            goal: goalText(for: node.stage, first: first),
                            knowledgeIds: ids,
                            answerSentences: answerSentences(node: node, first: first, second: second, third: third),
                            diagnostics: diagnostics(for: node.weaponUnlocked ?? .materialEvidence))
    }

    private static func materialText(node: LearningNode, first: KnowledgePoint, second: KnowledgePoint) -> String {
        switch node.topic {
        case .ancientChina, .juniorAncient:
            return "材料节选自有关\(first.title)的制度记述，并提到\(second.title)带来的地方治理、社会秩序或思想变化。"
        case .modernChina, .juniorModern:
            return "材料围绕\(first.title)展开，既有民族危机或社会动员的信息，也能看到\(second.title)推动中国转型的线索。"
        case .worldHistory, .juniorWorld:
            return "材料展示\(first.title)对世界联系、制度变革或生产方式的影响，并以\(second.title)提示全球视角。"
        case .stateSystem:
            return "材料比较\(first.title)前后的权力配置和治理方式，暗含制度调整服务现实治理需要。"
        case .economySociety:
            return "材料从生产、交换和社会生活切入，呈现\(first.title)与\(second.title)之间的结构性联系。"
        case .culturalExchange:
            return "材料包含路线、媒介和接受者信息，说明\(first.title)并非简单输入，而是伴随选择和改造。"
        case .historicalMethod:
            return "材料提供出处、立场和叙述差异，要求判断\(first.title)相关史料的价值与限度。"
        case .sprint:
            return "材料围绕\(node.title)设置开放情境，要求从\(first.title)切入，组织史实并形成解释。"
        }
    }

    private static func questionText(node: LearningNode, first: KnowledgePoint, third: KnowledgePoint) -> String {
        "提取材料信息，结合\(third.title)，说明\(first.title)如何体现\(node.title)的核心考点。"
    }

    private static func subjectText(for topic: HistoryTopic) -> String {
        switch topic {
        case .ancientChina, .juniorAncient: return "君主、官僚、士人、地方社会"
        case .modernChina, .juniorModern: return "列强、清政府、革命力量、人民群众"
        case .worldHistory, .juniorWorld: return "新兴资产阶级、民族国家、工人阶级、殖民地人民"
        case .stateSystem: return "国家、地方、基层组织、社会力量"
        case .economySociety: return "农民、商人、企业、国家政策"
        case .culturalExchange: return "传播者、接受者、翻译者、本土社会"
        case .historicalMethod: return "史料作者、研究者、命题者"
        case .sprint: return "材料主体、论证主体、评分主体"
        }
    }

    private static func actionText(for weapon: HistoryWeapon, first: KnowledgePoint) -> String {
        switch weapon {
        case .timelineAnchor: return "定位\(first.title)的年代和阶段"
        case .stageFeature: return "概括\(first.title)背后的阶段特征"
        case .materialEvidence: return "用史料信息证明\(first.title)"
        case .causalityChain: return "拆出\(first.title)的背景、触发和影响"
        case .comparisonMatrix: return "比较\(first.title)与同类现象的异同"
        case .continuityChange: return "判断\(first.title)中的延续与变迁"
        case .mapSpace: return "从空间路线理解\(first.title)"
        case .institutionEvolution: return "说明\(first.title)中的制度调整"
        case .economyStructure: return "分析\(first.title)牵动的经济结构"
        case .cultureExchange: return "解释\(first.title)中的传播和改造"
        case .worldSystem: return "把\(first.title)放入世界体系"
        default: return "把\(first.title)转化为可得分的历史解释"
        }
    }

    private static func goalText(for stage: Stage, first: KnowledgePoint) -> String {
        switch stage {
        case .junior: return "把\(first.title)打成通史基础锚点"
        case .required: return "把\(first.title)转成高考主干答案"
        case .elective: return "把\(first.title)放入专题线索"
        case .sprint: return "把\(first.title)用于综合设问"
        }
    }

    private static func answerSentences(node: LearningNode, first: KnowledgePoint, second: KnowledgePoint, third: KnowledgePoint) -> [String] {
        [
            "答案：本题核心是用\(first.title)说明\(node.title)的主干考点，先定时空再判断性质。",
            "为什么：材料中的主体、行动和评价词共同指向\(first.title)，这些信息是答案的材料依据，不能只摘关键词。",
            "展开：\(second.title)可以补足背景、条件或变化方向，\(third.title)则把答案从单点史实提升到\(node.topic.name)的阶段特征。",
            "结论：写清当时影响和长远影响，必要时补局限，才能回答“如何体现核心考点”，而不是停留在材料复述。"
        ]
    }

    private static func diagnostics(for weapon: HistoryWeapon) -> [String] {
        switch weapon {
        case .materialEvidence: return ["有没有看出处", "有没有定时间", "有没有判断立场", "有没有联系所学"]
        case .comparisonMatrix: return ["有没有比较维度", "有没有同异并写", "有没有说明原因", "有没有回扣材料"]
        case .causalityChain: return ["有没有区分背景和原因", "有没有直接触发", "有没有深层条件", "有没有影响层次"]
        case .continuityChange: return ["有没有写延续", "有没有写变化", "有没有解释变化原因", "有没有防止只背结论"]
        default: return ["有没有时空", "有没有主体", "有没有材料证据", "有没有历史解释"]
        }
    }
}

enum ConceptGraphData {
    static let nodes: [ConceptNode] = MainLineData.nodes.map { node in
        ConceptNode(id: "c_\(node.id)",
                    title: node.title,
                    subtitle: node.tagline,
                    grade: node.knowledgePoints.first?.grade ?? .a,
                    topic: node.topic,
                    triggerWords: node.knowledgePoints.flatMap(\.keywords).prefix(4).map { $0 })
    }

    static let edges: [ConceptEdge] = sequentialEdges + thematicEdges

    private static let sequentialEdges: [ConceptEdge] = zip(nodes, nodes.dropFirst()).map { a, b in
        ConceptEdge(id: "e_seq_\(a.id)_\(b.id)", from: a.id, to: b.id, relation: "通史前后承接")
    }

    private static let thematicEdges: [ConceptEdge] = [
        edge("n02", "n11", "秦汉统一国家从初中基础接到高中中央集权"),
        edge("n03", "n12", "隋唐制度创新接科举、三省六部和宋元治理"),
        edge("n04", "n13", "明清经济文化接专制强化和社会变动"),
        edge("n05", "n14", "晚清危机从初中近代史接高考救亡探索"),
        edge("n06", "n16", "新民主主义革命接革命道路和统一战线"),
        edge("n07", "n17", "新中国建设接制度建设与改革开放"),
        edge("n09", "n18", "新航路开辟打开早期全球联系"),
        edge("n09", "n20", "工业革命推动世界市场和社会结构变化"),
        edge("n19", "n22", "近现代民主制度接国家制度与治理专题"),
        edge("n20", "n23", "工业化接经济结构和社会生活变迁"),
        edge("n24", "n08", "文化交流反向理解古代文明多样性"),
        edge("n25", "n28", "史料实证直接服务史料题和小论文"),
        edge("n26", "n28", "史观转换提升开放题解释层次"),
        edge("n27", "n28", "选择题排雷迁移到主观题审题")
    ]

    private static func edge(_ from: String, _ to: String, _ relation: String) -> ConceptEdge {
        ConceptEdge(id: "e_theme_\(from)_\(to)", from: "c_\(from)", to: "c_\(to)", relation: relation)
    }

    static func related(to id: String) -> [ConceptEdge] { edges.filter { $0.from == id || $0.to == id } }
    static func concept(id: String) -> ConceptNode? { nodes.first { $0.id == id } }
    static func knowledgePoints(for conceptId: String) -> [KnowledgePoint] {
        guard let nodeId = conceptId.split(separator: "_").last.map(String.init) else { return [] }
        return MainLineData.node(id: nodeId)?.knowledgePoints ?? []
    }
}

enum WeaponGuideData {
    static let all: [WeaponGuide] = HistoryWeapon.allCases.map { weapon in
        WeaponGuide(weapon: weapon,
                    tagline: tagline(for: weapon),
                    whenToUse: ["材料有明显时间或出处", "设问要求分析变化、原因、影响或评价"],
                    steps: steps(for: weapon),
                    exampleCaseId: BossDuelData.all.first { $0.weapon == weapon }?.id)
    }

    static func guide(for weapon: HistoryWeapon) -> WeaponGuide? { all.first { $0.weapon == weapon } }

    private static func tagline(for weapon: HistoryWeapon) -> String {
        switch weapon {
        case .timelineAnchor: return "先定年代，再判阶段"
        case .stageFeature: return "把事件放进阶段特征"
        case .materialEvidence: return "出处、时间、立场、信息四问"
        case .causalityChain: return "背景、触发、结果三层因果"
        case .comparisonMatrix: return "同异点按背景、制度、影响比较"
        case .continuityChange: return "既看延续，也看变迁"
        case .conceptBoundary: return "概念不混、时代不串"
        case .mapSpace: return "空间位置决定交流路径"
        case .institutionEvolution: return "制度因治理需要而变"
        case .economyStructure: return "生产、交换、分配、生活联动"
        case .cultureExchange: return "传播、吸收、改造、影响"
        case .worldSystem: return "从全球联系看局部事件"
        case .historiographyView: return "换史观，换答案层次"
        case .choiceTrapFilter: return "排时间、主体、因果、程度、无关"
        case .essayArgument: return "观点明确，史实支撑"
        case .openEssaySixSteps: return "提观点、列论据、建逻辑、扣主题"
        }
    }

    private static func steps(for weapon: HistoryWeapon) -> [String] {
        switch weapon {
        case .openEssaySixSteps: return ["审题定主题", "提出观点", "选择两到三个史实", "建立因果或比较逻辑", "回扣主题", "检查史实准确"]
        case .materialEvidence: return ["看出处", "定时间", "判立场", "提信息", "联所学"]
        default: return ["定时空", "抓主体", "提材料信息", "联系所学", "写影响"]
        }
    }
}
