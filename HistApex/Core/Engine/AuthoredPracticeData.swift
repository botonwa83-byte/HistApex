import Foundation

enum AuthoredQuestionData {
    static let all: [HistoryQuestion] = [
        q("aq_ac_01", "n11", "k1101", .ancientChina, "秦统一后推行郡县制，与西周分封制相比，其主要变化是：", ["地方长官由中央任免，加强中央对地方控制", "诸侯世袭权力进一步扩大", "宗法血缘成为唯一任官标准", "地方完全脱离中央独立运行"], 0, .institutionEvolution),
        q("aq_ac_02", "n12", "k1202", .ancientChina, "唐代科举制发展，最能说明：", ["门第观念彻底消失", "选官制度扩大了统治基础并强化中央集权", "地方藩镇由此完全消除", "商品经济成为选官唯一标准"], 1, .institutionEvolution),
        q("aq_ac_03", "n13", "k1301", .ancientChina, "明清君主专制强化的共同表现是：", ["地方分权不断扩大", "中央决策更趋皇权集中", "科举制度完全废除", "白银退出流通领域"], 1, .stageFeature),
        q("aq_mc_01", "n14", "k1401", .modernChina, "鸦片战争后中国社会性质变化的关键在于：", ["自然经济立即完全解体", "中国开始逐步沦为半殖民地半封建社会", "君主专制随即终结", "民族资本主义已经占主导"], 1, .conceptBoundary),
        q("aq_mc_02", "n15", "k1501", .modernChina, "辛亥革命的历史功绩主要体现在：", ["完成反帝反封建任务", "推翻君主专制制度，建立共和政体", "立即实现民族独立", "彻底改变社会经济结构"], 1, .continuityChange),
        q("aq_mc_03", "n16", "k1602", .modernChina, "抗日民族统一战线形成的根本背景是：", ["阶级矛盾完全消失", "中日民族矛盾上升为主要矛盾", "世界市场最终形成", "清政府推行新政"], 1, .stageFeature),
        q("aq_wh_01", "n18", "k1801", .worldHistory, "新航路开辟后，欧洲出现商业革命。这里的“商业革命”主要指：", ["商业中心和贸易范围发生重大变化", "手工工场完全消失", "封建制度立即瓦解", "世界各地发展水平趋同"], 0, .worldSystem),
        q("aq_wh_02", "n19", "k1901", .worldHistory, "英国《权利法案》的意义在于：", ["确立议会权力高于王权的原则", "宣布美国独立", "建立拿破仑帝国", "废除一切私有制"], 0, .institutionEvolution),
        q("aq_wh_03", "n20", "k2001", .worldHistory, "工业革命首先发生在英国，直接条件之一是：", ["君主专制空前强化", "资本、市场、劳动力和技术条件较成熟", "殖民体系完全瓦解", "农业生产完全停滞"], 1, .causalityChain),
        q("aq_el_01", "n22", "k2201", .stateSystem, "评价中国古代制度演变时，最合理的方法是：", ["只用现代标准否定全部制度", "放回时代需求，分析治理效果和历史局限", "只看皇帝个人喜好", "不需要结合史料"], 1, .historiographyView),
        q("aq_econ_01", "n23", "k2301", .economySociety, "分析中国古代小农经济时，最应把握的是：", ["农业、家庭手工业和赋役制度之间的联系", "它完全排斥商品交换", "它只存在于近代以后", "它与国家治理没有关系"], 0, .economyStructure),
        q("aq_el_02", "n24", "k2401", .culturalExchange, "佛教传入中国后逐渐中国化，这说明文化交流通常表现为：", ["单向照搬，没有本土改造", "传播、选择、吸收和再创造", "完全消灭本土文化", "只发生在现代社会"], 1, .cultureExchange),
        q("aq_sp_01", "n27", "k2701", .sprint, "某题材料出自19世纪欧洲工人回忆录。解读该材料首先应注意：", ["史料出处、身份立场和时代背景", "只要是回忆录就绝对真实", "可直接代表全体欧洲人", "无需联系工业革命背景"], 0, .materialEvidence),
        q("aq_sp_02", "n28", "k2801", .sprint, "历史小论文“论证充分”的核心要求是：", ["观点明确，史实准确，逻辑能支撑主题", "字数越多越好", "只写个人感想", "只摘材料不概括"], 0, .essayArgument),
        q("aq_method_01", "n25", "k2501", .historicalMethod, "判断一则史料价值时，最不恰当的是：", ["分析作者身份", "考察成文时间", "关注材料立场", "认为孤证一定能还原全部历史"], 3, .materialEvidence),
        q("aq_method_02", "n26", "k2601", .historicalMethod, "用现代化史观分析近代中国，重点通常落在：", ["制度、经济、思想和社会生活向近代转型", "只研究皇帝年号", "否认民族危机影响", "排斥世界联系"], 0, .historiographyView),
        q("aq_junior_01", "n09", "k0903", .juniorWorld, "两次工业革命对世界格局的共同影响是：", ["加强资本主义国家对世界的支配和联系", "消除殖民扩张", "终结国际竞争", "使农业成为唯一产业"], 0, .worldSystem)
    ]

    static func questions(topic: HistoryTopic) -> [HistoryQuestion] { all.filter { $0.topic == topic } }

    private static func q(_ id: String, _ nodeId: String, _ knowledgeId: String, _ topic: HistoryTopic, _ prompt: String, _ options: [String], _ answer: Int, _ weapon: HistoryWeapon) -> HistoryQuestion {
        let correct = options[answer]
        return HistoryQuestion(id: id,
                               nodeId: nodeId,
                               knowledgeId: knowledgeId,
                               topic: topic,
                               stage: topic.stage,
                               prompt: prompt,
                               options: options,
                               answerIndex: answer,
                               explanation: explanation(id: id, correct: correct),
                               trapTags: ["时间错位", "概念混淆"],
                               weapon: weapon)
    }

    private static func explanation(id: String, correct: String) -> String {
        switch id {
        case "aq_ac_01":
            return "答案：\(correct)。原因：郡县制下郡守、县令由中央任免，地方不再像分封制诸侯那样世袭自治，体现官僚政治取代贵族政治，核心指向是中央集权加强。"
        case "aq_ac_02":
            return "答案：\(correct)。原因：科举以考试取士，把选官权更多收归中央，并让寒门士人有上升通道；不能说门第观念彻底消失，也不能把藩镇问题说成由科举完全解决。"
        case "aq_ac_03":
            return "答案：\(correct)。原因：明废丞相、清设军机处都使国家大政更直接服从皇帝意志，判断点是皇权集中；地方分权扩大、科举废除和白银退出都不符合明清史实。"
        case "aq_mc_01":
            return "答案：\(correct)。原因：鸦片战争后中国主权受损、自然经济逐步解体，社会性质开始由独立封建社会转向半殖民地半封建社会；“立即完全解体”“君主专制随即终结”都把渐变说成突变。"
        case "aq_mc_02":
            return "答案：\(correct)。原因：辛亥革命的最大制度成果是结束君主专制、建立共和政体；它没有完成反帝反封建任务，也没有立即实现民族独立或彻底改造经济结构。"
        case "aq_mc_03":
            return "答案：\(correct)。原因：日本全面侵华使民族矛盾压倒阶级矛盾，推动各阶级、党派围绕抗日形成统一战线；“阶级矛盾完全消失”是绝对化表述。"
        case "aq_wh_01":
            return "答案：\(correct)。原因：新航路开辟后贸易范围扩大、商路和商业中心由地中海转向大西洋沿岸，这就是商业革命的核心；它不等于封建制度立即瓦解或世界发展水平趋同。"
        case "aq_wh_02":
            return "答案：\(correct)。原因：《权利法案》限制王权、确立议会主权原则，是英国君主立宪制形成的重要基础；美国独立、拿破仑帝国和废除私有制都不属于该法案内容。"
        case "aq_wh_03":
            return "答案：\(correct)。原因：英国较早具备资本积累、海外市场、劳动力供给和技术经验，直接推动工业革命发生；君主专制强化、殖民体系瓦解和农业停滞都与史实不符。"
        case "aq_el_01":
            return "答案：\(correct)。原因：评价古代制度要回到当时统一国家治理和社会条件中，看它解决了什么问题、产生何种局限；只用现代标准否定或只看皇帝个人喜好都不是历史解释。"
        case "aq_econ_01":
            return "答案：\(correct)。原因：小农经济以家庭为单位，把农业和家庭手工业结合，并通过赋役制度嵌入国家治理；它并非完全排斥商品交换，也不是近代以后才出现。"
        case "aq_el_02":
            return "答案：\(correct)。原因：佛教中国化说明外来文化进入本土后会被选择、吸收并重新解释，形成新的文化形态；单向照搬或消灭本土文化都不符合文化交流规律。"
        case "aq_sp_01":
            return "答案：\(correct)。原因：回忆录属于具体身份和立场下的史料，先看出处、作者身份和时代背景，才能判断它能证明什么、不能证明什么；不能把个体回忆等同于绝对真实。"
        case "aq_sp_02":
            return "答案：\(correct)。原因：历史小论文得分核心是观点明确、史实准确、论证能支撑主题；字数多、写感想或照抄材料都不能形成有效历史解释。"
        case "aq_method_01":
            return "答案：\(correct)。原因：孤证只能提供线索，不能单独还原全部历史，需要与作者身份、成文时间、材料立场和其他史料互证；因此把孤证绝对化最不恰当。"
        case "aq_method_02":
            return "答案：\(correct)。原因：现代化史观关注制度、经济、思想和社会生活向近代形态转型，同时要结合民族危机和世界联系；只研究年号或排斥外部影响会偏离史观。"
        case "aq_junior_01":
            return "答案：\(correct)。原因：两次工业革命都加强了资本主义国家的经济和技术优势，推动世界市场、殖民体系和国际联系扩展；它们没有消除殖民扩张和国际竞争。"
        default:
            return "答案：\(correct)。原因：本题要先定时空，再用材料信息和教材史实互证，排除时间、主体、因果或程度错误的选项。"
        }
    }
}

enum AuthoredSubjectiveQuestionData {
    static let all: [SubjectiveQuestion] = [
        sq("asq_ac_01", "n11", "k1101", .ancientChina, .materialAnalysis, 13, "材料一 秦统一后，分天下为三十六郡，郡守、县令由中央任免。材料二 西周实行分封，诸侯在封国内享有较大世袭权力。", "比较分封制与郡县制，说明秦朝地方制度变化的历史意义。", ["分封制以血缘和功臣分封为基础，地方具有较大世袭性。", "郡县制地方官由中央任免，体现官僚政治取代贵族政治趋势。", "有利于加强中央集权和统一多民族国家治理。", "也为后世地方行政制度提供重要借鉴。"]),
        sq("asq_mc_01", "n14", "k1401", .modernChina, .measure, 13, "材料反映鸦片战争后通商口岸开放、协定关税和领事裁判权等变化。", "结合材料和所学，分析鸦片战争对中国社会转型的影响。", ["中国主权和领土完整遭到破坏。", "中国开始被卷入资本主义世界市场。", "自然经济逐步解体，近代经济因素产生。", "民族危机加深，推动先进中国人探索救亡道路。"]),
        sq("asq_wh_01", "n20", "k2001", .worldHistory, .evaluation, 14, "材料描述英国工厂制度、城市人口增长和工人阶级形成。", "评析工业革命怎样改变近代世界。", ["工业革命极大提高生产力，推动工厂制度形成。", "加速城市化和社会阶级结构变化。", "推动资本主义世界市场形成和全球联系加强。", "同时带来贫富分化、环境污染和工人问题。"]),
        sq("asq_sp_01", "n28", "k2801", .sprint, .openInquiry, 12, "围绕“制度创新与国家治理”主题，任选中国古代两个制度变革史实进行论述。", "自拟论题并展开历史小论文。", ["观点明确，围绕制度创新与治理能力。", "可选郡县制、科举制、行省制等史实。", "论证要说明制度产生背景、治理作用和历史影响。", "结尾回扣主题，避免只罗列史实。"]),
        sq("asq_method_01", "n25", "k2501", .historicalMethod, .evaluation, 13, "某学者引用地方志、官府文书和商人账簿研究明清市镇经济。", "评析多类型史料在历史研究中的价值。", ["不同史料可以相互印证，增强解释可靠性。", "地方志有官方和地方立场，需注意叙述选择。", "账簿能反映商业活动细节，但覆盖范围有限。", "史料运用应坚持史料实证，结合问题意识。"]),
        sq("asq_culture_01", "n24", "k2401", .culturalExchange, .materialAnalysis, 13, "材料展示丝绸之路上的商品、宗教、艺术和技术传播。", "说明丝绸之路对中外文明交流的作用。", ["促进东西方商品和技术交流。", "推动宗教、艺术等文化因素传播和本土化。", "加强欧亚大陆联系，体现文明互鉴。", "交流不是单向输入，而是选择、吸收和再创造。"]),
        sq("asq_state_01", "n22", "k2201", .stateSystem, .significance, 13, "材料比较秦郡县、隋唐三省六部、元行省制度。", "概括中国古代国家治理制度演变的趋势。", ["中央集权不断加强。", "官僚行政体系不断完善。", "地方治理因疆域和现实需要而调整。", "制度演变服务于统一多民族国家治理。"]),
        sq("asq_compare_01", "n19", "k1901", .worldHistory, .evaluation, 14, "材料分别涉及英国议会、美国1787年宪法和法国革命。", "比较英美法资产阶级代议制形成的异同。", ["相同点是都受启蒙思想和资本主义发展影响。", "英国路径较渐进，美国突出分权制衡，法国革命更激烈。", "都限制专制权力并推动近代民主制度发展。", "差异源于各国历史传统、社会矛盾和革命条件不同。"])
    ]

    static func questions(topic: HistoryTopic) -> [SubjectiveQuestion] { all.filter { MainLineData.node(id: $0.nodeId)?.topic == topic } }

    private static func sq(_ id: String, _ nodeId: String, _ knowledgeId: String, _ topic: HistoryTopic, _ type: SubjectiveQuestionType, _ score: Int, _ material: String, _ prompt: String, _ points: [String]) -> SubjectiveQuestion {
        let explicitPoints = points.enumerated().map { index, point in
            switch index {
            case 0: return "答案：\(point)"
            case 1: return "为什么：\(point)"
            default: return point
            }
        }
        return SubjectiveQuestion(id: id, nodeId: nodeId, knowledgeId: knowledgeId, grade: .s, questionType: type, score: score, material: material, prompt: prompt, answerPoints: explicitPoints, diagnostics: ["定时空", "提证据", "联所学", "写评价"])
    }
}
