import XCTest
@testable import HistApex

final class HistApexTests: XCTestCase {
    func testMainLineHasPlannedCoverage() {
        XCTAssertEqual(MainLineData.nodes.count, 28)
        XCTAssertEqual(MainLineData.nodes.map(\.order), Array(1...28))
        XCTAssertEqual(Set(MainLineData.nodes.map(\.id)).count, MainLineData.nodes.count)
        XCTAssertTrue(MainLineData.nodes.prefix(9).allSatisfy { $0.stage == .junior })
        XCTAssertEqual(MainLineData.nodes.last?.stage, .sprint)
    }

    func testKnowledgeIdsUniqueAndEveryNodeCovered() {
        let ids = MainLineData.allKnowledgePoints.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "考点 ID 重复")
        for node in MainLineData.nodes {
            XCTAssertGreaterThanOrEqual(MainLineData.coveragePoints(for: node).count, 4,
                                        "节点 \(node.id) 考点覆盖不足")
        }
        XCTAssertGreaterThanOrEqual(MainLineData.allKnowledgePoints.count, 100)
        XCTAssertGreaterThan(MainLineData.allKnowledgePoints.filter { $0.grade == .s }.count, 20)
    }

    func testWeightedQuestionGenerationCoversEveryKnowledgePoint() {
        let grouped = Dictionary(grouping: QuestionBank.generated, by: \.knowledgeId)
        for point in MainLineData.allKnowledgePoints {
            let questions = grouped[point.id] ?? []
            XCTAssertEqual(questions.count, QuestionBank.questionCount(for: point.grade),
                           "考点 \(point.id) 题量未按 \(point.grade.rawValue) 级权重生成")
            for question in questions {
                XCTAssertTrue(question.options.indices.contains(question.answerIndex),
                              "题 \(question.id) 答案下标越界")
                XCTAssertEqual(question.knowledgeId, point.id)
            }
        }
    }

    func testGeneratedChoiceQuestionsAvoidSingleTemplateShell() {
        let prompts = QuestionBank.generated.map(\.prompt)
        XCTAssertGreaterThan(Set(prompts).count, MainLineData.allKnowledgePoints.count * 2,
                             "生成选择题不能只是每个考点换标题")
        XCTAssertLessThan(prompts.filter { $0.contains("关于「") && $0.contains("最符合高考历史作答要求") }.count,
                          QuestionBank.generated.count / 4,
                          "生成选择题仍有明显通用模板残留")

        let repeatedOptionSets = Dictionary(grouping: QuestionBank.generated) { question in
            question.options.sorted().joined(separator: "|")
        }
        .values
        .filter { $0.count > 8 }
        XCTAssertTrue(repeatedOptionSets.isEmpty, "选择题选项组合重复过多")
    }

    func testGeneratedSubjectiveQuestionsHaveTypeAndPromptVariety() {
        let generated = SubjectiveQuestionData.generated
        let types = Set(generated.map(\.questionType))
        XCTAssertTrue(types.contains(.materialAnalysis))
        XCTAssertTrue(types.contains(.measure))
        XCTAssertTrue(types.contains(.significance))
        XCTAssertTrue(types.contains(.evaluation))
        XCTAssertTrue(types.contains(.openInquiry))
        XCTAssertLessThan(generated.filter { $0.material.hasPrefix("材料围绕") }.count,
                          generated.count / 5,
                          "生成主观题仍像统一材料模板")
        XCTAssertGreaterThan(Set(generated.map(\.prompt)).count, MainLineData.allKnowledgePoints.count / 2,
                             "生成主观题设问重复度过高")
    }

    func testNodePracticeIdsResolveFullCoverage() {
        for node in MainLineData.nodes {
            let expectedCount = MainLineData.coveragePoints(for: node)
                .map { QuestionBank.questionCount(for: $0.grade) }
                .reduce(0, +)
            XCTAssertEqual(node.allPracticeIds.count, expectedCount, "节点 \(node.id) 动态练习 ID 没覆盖全部考点")
            XCTAssertEqual(Set(node.allPracticeIds).count, node.allPracticeIds.count, "节点 \(node.id) 练习 ID 重复")
            for id in node.allPracticeIds {
                XCTAssertNotNil(QuestionBank.question(id: id), "节点 \(node.id) 练习 ID \(id) 没有关联到题库")
            }
        }
    }

    func testHighPriorityPointsHaveSubjectiveQuestions() {
        let subjectiveIds = Set(SubjectiveQuestionData.all.map(\.knowledgeId))
        for point in MainLineData.allKnowledgePoints where point.grade == .s || point.grade == .a {
            XCTAssertTrue(subjectiveIds.contains(point.id), "S/A 考点 \(point.id) 缺主观题")
        }
        XCTAssertTrue(SubjectiveQuestionData.all.allSatisfy { !$0.answerPoints.isEmpty })
    }

    func testPracticeCoverageIsLaunchReady() {
        let allPoints = MainLineData.allKnowledgePoints
        let choiceIds = Set(QuestionBank.all.map(\.knowledgeId))
        let subjectiveIds = Set(SubjectiveQuestionData.all.map(\.knowledgeId))
        let fullyCovered = allPoints.filter { choiceIds.contains($0.id) && subjectiveIds.contains($0.id) }

        XCTAssertEqual(fullyCovered.count, allPoints.count, "每个知识点都应同时有选择题和非选择题")
        XCTAssertGreaterThanOrEqual(QuestionBank.all.count, allPoints.count * 3,
                                    "选择题总量不足，无法支撑高频刷题")
        XCTAssertGreaterThanOrEqual(SubjectiveQuestionData.all.count, allPoints.count,
                                    "非选择题应至少覆盖每个知识点")

        let subjectiveTypes = Set(SubjectiveQuestionData.all.map(\.questionType))
        XCTAssertEqual(subjectiveTypes, Set(SubjectiveQuestionType.allCases),
                       "非选择题题型池不完整")
    }

    func testExamPracticeSetsFollowGaokaoRatio() {
        XCTAssertEqual(ExamPracticeBlueprint.choiceQuestionCount, 16)
        XCTAssertEqual(ExamPracticeBlueprint.choiceScore, 48)
        XCTAssertEqual(ExamPracticeBlueprint.subjectiveQuestionCount, 4)
        XCTAssertEqual(ExamPracticeBlueprint.subjectiveScore, 52)
        XCTAssertEqual(ExamPracticeBlueprint.totalScore, 100)

        for set in ExamPracticeData.all {
            XCTAssertEqual(set.choiceQuestions.count, ExamPracticeBlueprint.choiceQuestionCount,
                           "套练 \(set.id) 选择题数量不符合高考比例")
            XCTAssertEqual(set.subjectiveQuestions.count, ExamPracticeBlueprint.subjectiveQuestionCount,
                           "套练 \(set.id) 非选择题数量不符合高考比例")
            XCTAssertEqual(set.subjectiveQuestions.map(\.score).reduce(0, +), ExamPracticeBlueprint.subjectiveScore,
                           "套练 \(set.id) 非选择题分值未按高考比重配置")
            XCTAssertTrue(set.choiceQuestions.contains { $0.id.hasPrefix("aq_") },
                          "套练 \(set.id) 选择题没有使用人工高考风格题")
            XCTAssertTrue(set.subjectiveQuestions.contains { $0.id.hasPrefix("asq_") },
                          "套练 \(set.id) 非选择题没有使用人工题")

            let subjectiveTopics = Set(set.subjectiveQuestions.compactMap { MainLineData.node(id: $0.nodeId)?.topic })
            XCTAssertTrue(subjectiveTopics.contains(.ancientChina), "套练 \(set.id) 缺中国古代史史料题")
            XCTAssertTrue(subjectiveTopics.contains(.modernChina), "套练 \(set.id) 缺中国近现代史史料题")
            XCTAssertTrue(subjectiveTopics.contains(.worldHistory), "套练 \(set.id) 缺世界史史料题")
            XCTAssertTrue(subjectiveTopics.contains(.sprint), "套练 \(set.id) 缺综合冲刺非选择题")

            let subjectiveTypes = Set(set.subjectiveQuestions.map(\.questionType))
            XCTAssertTrue(subjectiveTypes.contains(.measure), "套练 \(set.id) 缺措施题")
            XCTAssertTrue(subjectiveTypes.contains(.materialAnalysis), "套练 \(set.id) 缺材料分析题")
            XCTAssertTrue(subjectiveTypes.contains(.evaluation), "套练 \(set.id) 缺评析题")
            XCTAssertTrue(subjectiveTypes.contains(.openInquiry), "套练 \(set.id) 缺开放探究题")
        }
    }

    func testAuthoredPracticeQuestionsAreValidAndTyped() {
        XCTAssertGreaterThanOrEqual(AuthoredQuestionData.all.count, ExamPracticeBlueprint.choiceQuestionCount)
        XCTAssertGreaterThanOrEqual(AuthoredSubjectiveQuestionData.all.count, 8)
        XCTAssertEqual(Set(AuthoredQuestionData.all.map(\.id)).count, AuthoredQuestionData.all.count)
        XCTAssertEqual(Set(AuthoredSubjectiveQuestionData.all.map(\.id)).count, AuthoredSubjectiveQuestionData.all.count)

        let choiceTopics = Set(AuthoredQuestionData.all.map(\.topic))
        for slot in ExamPracticeBlueprint.choiceTopicSlots {
            XCTAssertTrue(choiceTopics.contains(slot.topic), "人工选择题缺 \(slot.topic.name)")
        }

        for question in AuthoredQuestionData.all {
            XCTAssertNotNil(MainLineData.node(id: question.nodeId), "人工选择题 \(question.id) nodeId 无效")
            XCTAssertNotNil(MainLineData.knowledge(id: question.knowledgeId), "人工选择题 \(question.id) knowledgeId 无效")
            XCTAssertEqual(question.options.count, 4, "人工选择题 \(question.id) 选项数不为 4")
            XCTAssertTrue(question.options.indices.contains(question.answerIndex), "人工选择题 \(question.id) 答案下标越界")
            XCTAssertFalse(question.prompt.isEmpty)
            XCTAssertFalse(question.explanation.isEmpty)
        }

        let subjectiveTopics = Set(AuthoredSubjectiveQuestionData.all.compactMap { MainLineData.node(id: $0.nodeId)?.topic })
        for topic in ExamPracticeBlueprint.subjectiveTopicSlots {
            XCTAssertTrue(subjectiveTopics.contains(topic), "人工非选择题缺 \(topic.name)")
        }

        let subjectiveTypes = Set(AuthoredSubjectiveQuestionData.all.map(\.questionType))
        XCTAssertTrue(subjectiveTypes.contains(.measure))
        XCTAssertTrue(subjectiveTypes.contains(.materialAnalysis))
        XCTAssertTrue(subjectiveTypes.contains(.significance))
        XCTAssertTrue(subjectiveTypes.contains(.evaluation))
        XCTAssertTrue(subjectiveTypes.contains(.openInquiry))

        for question in AuthoredSubjectiveQuestionData.all {
            XCTAssertNotNil(MainLineData.node(id: question.nodeId), "人工非选择题 \(question.id) nodeId 无效")
            XCTAssertNotNil(MainLineData.knowledge(id: question.knowledgeId), "人工非选择题 \(question.id) knowledgeId 无效")
            XCTAssertGreaterThanOrEqual(question.score, 10, "人工非选择题 \(question.id) 分值过低")
            XCTAssertGreaterThanOrEqual(question.answerPoints.count, 4, "人工非选择题 \(question.id) 采分点不足")
            XCTAssertFalse(question.material.isEmpty)
            XCTAssertFalse(question.prompt.isEmpty)
            XCTAssertFalse(question.diagnostics.isEmpty)
        }
    }

    func testPrioritySPointsHaveDeepExplanations() {
        let allSPoints = MainLineData.allKnowledgePoints.filter { $0.grade == .s }
        let points = allSPoints.filter(\.hasDeepExplanation)
        XCTAssertEqual(points.count, allSPoints.count, "所有 S 级考点都必须有深度讲解")
        XCTAssertGreaterThanOrEqual(points.count, 36, "S 级深度讲解数量异常")

        for point in points {
            XCTAssertGreaterThanOrEqual(point.mustReciteLines.count, 3, "S 级考点 \(point.id) 必背句不足")
            XCTAssertGreaterThanOrEqual(point.sampleAnswerSentences.count, 2, "S 级考点 \(point.id) 高分答案句不足")
            XCTAssertGreaterThanOrEqual(point.commonTrapLines.count + point.explanation.confusions.count, 2,
                                        "S 级考点 \(point.id) 易错/易混信息不足")
            XCTAssertFalse(point.explanation.plainExplanation.isEmpty, "S 级考点 \(point.id) 缺白话理解")
            XCTAssertFalse(point.explanation.answerTemplate.isEmpty, "S 级考点 \(point.id) 缺答题模板")
            XCTAssertFalse(point.explanation.reciteChecklist.isEmpty, "S 级考点 \(point.id) 缺默写清单")
        }
    }

    func testPriorityAPointsHaveDeepExplanations() {
        let allAPoints = MainLineData.allKnowledgePoints.filter { $0.grade == .a }
        let points = allAPoints.filter(\.hasDeepExplanation)
        XCTAssertEqual(points.count, allAPoints.count, "所有 A 级考点都必须有深度讲解")
        XCTAssertGreaterThanOrEqual(points.count, 48, "A 级深度讲解数量异常")

        for point in points {
            XCTAssertGreaterThanOrEqual(point.mustReciteLines.count, 3, "A 级考点 \(point.id) 必背句不足")
            XCTAssertGreaterThanOrEqual(point.sampleAnswerSentences.count, 2, "A 级考点 \(point.id) 高分答案句不足")
            XCTAssertGreaterThanOrEqual(point.commonTrapLines.count + point.explanation.confusions.count, 2,
                                        "A 级考点 \(point.id) 易错/易混信息不足")
            XCTAssertFalse(point.explanation.plainExplanation.isEmpty, "A 级考点 \(point.id) 缺白话理解")
            XCTAssertFalse(point.explanation.answerTemplate.isEmpty, "A 级考点 \(point.id) 缺答题模板")
        }
    }

    func testDeepExplanationsImproveGeneratedTrainingContent() {
        let deepPoint = MainLineData.allKnowledgePoints.first { $0.id == "k1601" }
        XCTAssertNotNil(deepPoint)
        XCTAssertTrue(deepPoint?.hasDeepExplanation == true)

        let subjective = SubjectiveQuestionData.questions(knowledgeId: "k1601").first
        XCTAssertNotNil(subjective)
        XCTAssertTrue(subjective?.answerPoints.contains { $0.contains("背景") || $0.contains("影响") } == true,
                      "深度主观题应使用结构化采分句，而不是只引用 detail")

        let card = MemoryData.all.first { $0.knowledgeId == "k1601" }
        XCTAssertNotNil(card)
        XCTAssertTrue(card?.back.contains("时空") == true || card?.back.contains("史实") == true,
                      "深度记忆卡应包含历史学科记忆要点")
    }

    func testKnowledgeBridgeConnectsPointToLearningLoop() {
        for point in MainLineData.allKnowledgePoints {
            let bridge = KnowledgeBridgeData.bridge(for: point)
            XCTAssertNotNil(bridge, "考点 \(point.id) 缺知识枢纽")
            XCTAssertEqual(bridge?.point.id, point.id)
            XCTAssertTrue(bridge?.node.knowledgePoints.contains { $0.id == point.id } == true)
            XCTAssertFalse(bridge?.choiceQuestions.isEmpty == true && bridge?.subjectiveQuestions.isEmpty == true,
                           "考点 \(point.id) 没有连接到任何练习")
            XCTAssertFalse(bridge?.answerTemplates.isEmpty == true, "考点 \(point.id) 没有连接到答题模板")
            XCTAssertNotNil(bridge?.weaponGuide, "考点 \(point.id) 没有连接到方法武器")
        }
    }

    func testHistoricalSpecialModulesAreReachableThroughWeapons() {
        for guide in WeaponGuideData.all {
            let modules = HistoricalSpecialData.modules(for: guide.weapon)
            XCTAssertFalse(modules.isEmpty, "武器 \(guide.weapon.name) 没有对应历史专属模块")
        }
    }

    func testAuthoredKnowledgeSamplesReplaceGenericShells() {
        let checkedIds = ["k1101", "k1403", "k1602", "k1801", "k2001", "k2501", "k2803"]
        for id in checkedIds {
            let point = MainLineData.knowledge(id: id)
            XCTAssertNotNil(point, "人工深讲考点 \(id) 不存在")
            XCTAssertTrue(point?.mustReciteLines.joined().contains("材料题要先看出处") == false,
                          "人工深讲考点 \(id) 仍像通用空模板")
            XCTAssertGreaterThanOrEqual(point?.explanation.triggerScenes.count ?? 0, 4)
            XCTAssertGreaterThanOrEqual(point?.sampleAnswerSentences.count ?? 0, 2)
        }
        XCTAssertTrue(MainLineData.knowledge(id: "k1101")?.explanation.plainExplanation.contains("地方权力") == true)
        XCTAssertTrue(MainLineData.knowledge(id: "k1801")?.explanation.plainExplanation.contains("偶然冒险") == true)
        XCTAssertTrue(MainLineData.knowledge(id: "k2803")?.explanation.answerTemplate.joined().contains("观点") == true)
    }

    func testBossDuelReferencesResolveAndAreFaster() {
        XCTAssertGreaterThanOrEqual(BossDuelData.all.count, 15, "Boss Duel 数量不足，不能只保留少量示例")
        let ids = BossDuelData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "Boss Duel ID 重复")
        let nodeIds = Set(MainLineData.nodes.map(\.id))
        for duel in BossDuelData.all {
            XCTAssertTrue(nodeIds.contains(duel.nodeId), "Boss \(duel.id) nodeId 不存在")
            XCTAssertGreaterThan(duel.timeRatio, 1)
            XCTAssertGreaterThanOrEqual(duel.standard.steps.count, 3, "Boss \(duel.id) 常规解步骤不足")
            XCTAssertGreaterThanOrEqual(duel.weaponPath.steps.count, 3, "Boss \(duel.id) 武器解步骤不足")
            XCTAssertGreaterThanOrEqual(duel.sampleAnswer.count, 3, "Boss \(duel.id) 高分答案句不足")
        }
        for node in MainLineData.nodes where node.bossCaseId != nil {
            XCTAssertNotNil(BossDuelData.duel(id: node.bossCaseId!))
        }
    }

    func testBossDuelContentIsNotGenericShell() {
        XCTAssertEqual(BossDuelData.all.count, MainLineData.nodes.count, "Boss 应覆盖所有主线节点")
        XCTAssertLessThan(BossDuelData.all.filter { $0.material.hasPrefix("材料呈现") }.count,
                          BossDuelData.all.count / 5,
                          "Boss 材料不能继续使用通用空模板")
        XCTAssertGreaterThan(Set(BossDuelData.all.map(\.keyInsight)).count,
                             BossDuelData.all.count / 2,
                             "Boss 关键洞察重复度过高")

        for duel in BossDuelData.all {
            let node = MainLineData.node(id: duel.nodeId)
            XCTAssertNotNil(node)
            XCTAssertTrue(node?.knowledgePoints.contains { duel.title.contains($0.title) || duel.keyInsight.contains($0.title) } == true,
                          "Boss \(duel.id) 没有绑定具体考点表达")
            XCTAssertFalse(duel.standard.steps.contains("回忆事件"), "Boss \(duel.id) 常规解仍是旧模板")
            XCTAssertFalse(duel.weaponPath.steps.contains("切材料"), "Boss \(duel.id) 武器解仍是旧模板")
        }
    }

    func testMaterialCaseBreadthAndReferencesResolve() {
        XCTAssertGreaterThanOrEqual(MaterialCaseData.all.count, 15, "材料案例数量不足，不能只覆盖少量模块")
        let ids = MaterialCaseData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "材料案例 ID 重复")
        let knowledgeIds = Set(MainLineData.allKnowledgePoints.map(\.id))
        for item in MaterialCaseData.all {
            XCTAssertGreaterThanOrEqual(item.knowledgeIds.count, 2, "材料案例 \(item.id) 关联考点不足")
            XCTAssertGreaterThanOrEqual(item.answerSentences.count, 3, "材料案例 \(item.id) 答案句不足")
            XCTAssertFalse(item.diagnostics.isEmpty, "材料案例 \(item.id) 缺扣分提醒")
            for id in item.knowledgeIds {
                XCTAssertTrue(knowledgeIds.contains(id), "材料案例 \(item.id) 引用不存在考点 \(id)")
            }
        }
    }

    func testMaterialCasesCoverFullMainlineAndAvoidGenericShell() {
        XCTAssertEqual(MaterialCaseData.all.count, MainLineData.nodes.count, "材料案例应覆盖全部 28 个节点")
        XCTAssertLessThan(MaterialCaseData.all.filter { $0.material.hasPrefix("材料选取") }.count,
                          MaterialCaseData.all.count / 5,
                          "材料案例仍有明显通用模板")
        XCTAssertLessThan(MaterialCaseData.all.filter { $0.subject == "历史主体" }.count,
                          MaterialCaseData.all.count / 5,
                          "材料案例主体字段仍过于笼统")
        XCTAssertGreaterThan(Set(MaterialCaseData.all.map(\.goal)).count, 6,
                             "材料案例训练目标重复度过高")
    }

    func testConceptGraphReferencesResolve() {
        let conceptIds = Set(ConceptGraphData.nodes.map(\.id))
        XCTAssertEqual(conceptIds.count, ConceptGraphData.nodes.count)
        for edge in ConceptGraphData.edges {
            XCTAssertTrue(conceptIds.contains(edge.from), "边 \(edge.id) from 不存在")
            XCTAssertTrue(conceptIds.contains(edge.to), "边 \(edge.id) to 不存在")
            XCTAssertFalse(edge.relation.isEmpty)
        }
    }

    func testConceptGraphCoversFullMainlineAndThematicEdges() {
        XCTAssertEqual(ConceptGraphData.nodes.count, MainLineData.nodes.count, "概念星图应覆盖完整 28 关")
        XCTAssertGreaterThan(ConceptGraphData.edges.count, ConceptGraphData.nodes.count,
                             "概念星图不能只有顺序承接边")
        XCTAssertTrue(ConceptGraphData.edges.contains { $0.relation.contains("史料实证") || $0.relation.contains("小论文") },
                      "概念星图缺史料题/小论文关系")
        XCTAssertTrue(ConceptGraphData.edges.contains { $0.relation.contains("工业革命") || $0.relation.contains("世界市场") },
                      "概念星图缺世界史专题关系")
        XCTAssertTrue(ConceptGraphData.edges.contains { $0.relation.contains("中央集权") || $0.relation.contains("国家制度") },
                      "概念星图缺制度治理专题关系")
    }

    func testFreeTierPolicy() {
        let freeNodes = MainLineData.nodes.filter { $0.order <= PurchaseManager.freeNodeCount }
        XCTAssertTrue(freeNodes.allSatisfy { $0.stage == .junior }, "免费主线应完整覆盖初中通史")
        XCTAssertEqual(freeNodes.count, 9, "免费档应完整覆盖初中 9 关")
        XCTAssertLessThanOrEqual(PurchaseManager.freeDuelCount, BossDuelData.all.count)
        XCTAssertLessThanOrEqual(PurchaseManager.freeMaterialCaseCount, MaterialCaseData.all.count)
        XCTAssertLessThanOrEqual(PurchaseManager.freeWeaponCount, WeaponGuideData.all.count)
    }

    func testPremiumPlanCommunicatesCoreUnlocks() {
        XCTAssertGreaterThanOrEqual(PremiumContentPlan.heroBenefits.count, 6)
        XCTAssertTrue(PremiumContentPlan.unlockSummary.contains("高考权重套练"))
        XCTAssertTrue(PremiumContentPlan.unlockSummary.contains("史料题题型池"))
        XCTAssertTrue(PremiumContentPlan.paywallFootnote.contains("无订阅"))
        XCTAssertTrue(PremiumContentPlan.paywallFootnote.contains("恢复购买"))

        let pillarText = PremiumContentPlan.pillars
            .map { "\($0.title) \($0.detail) \($0.metric)" }
            .joined(separator: " ")
        XCTAssertTrue(pillarText.contains("48/52"), "内购价值必须明确按高考分值权重组织")
        XCTAssertTrue(pillarText.contains("史料题"), "内购价值必须突出史料题题型池")
        XCTAssertTrue(pillarText.contains("历史规律引擎"), "内购价值必须突出规律提分")
        XCTAssertTrue(pillarText.contains("史学实验室"), "内购价值必须突出历史独有模块")
        XCTAssertTrue(PremiumContentPlan.heroBenefits.contains { $0.title.contains("一次买断") })
    }

    func testPremiumPlanHasQuantifiedQualityProof() {
        XCTAssertGreaterThanOrEqual(PremiumContentPlan.qualityStats.count, 4)
        XCTAssertTrue(PremiumContentPlan.qualityStats.contains { $0.title.contains("知识点练习覆盖") && $0.value == "100%" })
        XCTAssertTrue(PremiumContentPlan.qualityStats.contains { $0.value == "48/52" })
        XCTAssertGreaterThanOrEqual(PremiumContentPlan.unlockComparison.count, 4)
        XCTAssertTrue(PremiumContentPlan.unlockComparison.contains { $0.premium.contains("28 关") })
        XCTAssertTrue(PremiumContentPlan.unlockComparison.contains { $0.premium.contains("\(BossDuelData.all.count) 场") })
    }

    func testHistoricalSpecialModulesReflectHistoryDiscipline() {
        XCTAssertEqual(HistoricalSpecialData.all.count, 5)
        let kinds = Set(HistoricalSpecialData.all.map(\.kind))
        XCTAssertEqual(kinds, Set(HistoricalSpecialKind.allCases))
        let knowledgeIds = Set(MainLineData.allKnowledgePoints.map(\.id))
        for module in HistoricalSpecialData.all {
            XCTAssertFalse(module.method.isEmpty)
            XCTAssertGreaterThanOrEqual(module.examples.count, 3)
            for id in module.linkedKnowledgeIds {
                XCTAssertTrue(knowledgeIds.contains(id), "历史专属模块 \(module.id) 引用不存在考点 \(id)")
            }
        }
    }

    func testTimeMuseumIsFunButExamLinked() {
        XCTAssertGreaterThanOrEqual(TimeMuseumData.all.count, 7)
        let ids = TimeMuseumData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "穿越策展馆展品 ID 重复")
        let knowledgeIds = Set(MainLineData.allKnowledgePoints.map(\.id))

        for exhibit in TimeMuseumData.all {
            XCTAssertFalse(exhibit.artifact.isEmpty)
            XCTAssertFalse(exhibit.scene.isEmpty)
            XCTAssertFalse(exhibit.curatorNote.isEmpty)
            XCTAssertFalse(exhibit.miniMission.isEmpty)
            XCTAssertFalse(exhibit.hiddenExamPoint.isEmpty)
            XCTAssertFalse(exhibit.wrongTurn.isEmpty)
            XCTAssertGreaterThanOrEqual(exhibit.rewardSentences.count, 2)
            XCTAssertGreaterThanOrEqual(exhibit.knowledgeIds.count, 2)

            for id in exhibit.knowledgeIds {
                XCTAssertTrue(knowledgeIds.contains(id), "展品 \(exhibit.id) 引用不存在考点 \(id)")
                XCTAssertTrue(MainLineData.knowledge(id: id)?.grade == .s || MainLineData.knowledge(id: id)?.grade == .a,
                              "展品 \(exhibit.id) 应绑定 S/A 高频考点")
            }

            XCTAssertFalse(PracticeLinker.choiceQuestions(knowledgeIds: exhibit.knowledgeIds).isEmpty,
                           "展品 \(exhibit.id) 没有接选择题")
            XCTAssertFalse(PracticeLinker.subjectiveQuestions(knowledgeIds: exhibit.knowledgeIds).isEmpty,
                           "展品 \(exhibit.id) 没有接主观题")
        }
    }

    func testHistoryEncountersConnectFamousPeopleEventsAndExamPoints() {
        XCTAssertGreaterThanOrEqual(HistoryEncounterData.all.count, 9)
        let ids = HistoryEncounterData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "时空会客厅 ID 重复")
        let knowledgeIds = Set(MainLineData.allKnowledgePoints.map(\.id))

        let people = Set(HistoryEncounterData.all.map(\.person))
        XCTAssertTrue(people.contains("秦始皇"))
        XCTAssertTrue(people.contains("孙中山"))
        XCTAssertTrue(people.contains("毛泽东"))
        XCTAssertTrue(people.contains("哥伦布"))
        XCTAssertTrue(people.contains("瓦特"))

        for encounter in HistoryEncounterData.all {
            XCTAssertFalse(encounter.person.isEmpty)
            XCTAssertFalse(encounter.event.isEmpty)
            XCTAssertFalse(encounter.setting.isEmpty)
            XCTAssertFalse(encounter.openingLine.isEmpty)
            XCTAssertFalse(encounter.turningPoint.isEmpty)
            XCTAssertFalse(encounter.examFocus.isEmpty)
            XCTAssertFalse(encounter.studentMission.isEmpty)
            XCTAssertFalse(encounter.wrongMemory.isEmpty)
            XCTAssertFalse(encounter.timelineClue.isEmpty)
            XCTAssertGreaterThanOrEqual(encounter.answerLines.count, 2)
            XCTAssertGreaterThanOrEqual(encounter.knowledgeIds.count, 2)

            for id in encounter.knowledgeIds {
                XCTAssertTrue(knowledgeIds.contains(id), "会客厅 \(encounter.id) 引用不存在考点 \(id)")
                XCTAssertTrue(MainLineData.knowledge(id: id)?.grade == .s || MainLineData.knowledge(id: id)?.grade == .a,
                              "会客厅 \(encounter.id) 应绑定 S/A 高频考点")
            }

            XCTAssertFalse(PracticeLinker.choiceQuestions(knowledgeIds: encounter.knowledgeIds).isEmpty,
                           "会客厅 \(encounter.id) 没有接选择题")
            XCTAssertFalse(PracticeLinker.subjectiveQuestions(knowledgeIds: encounter.knowledgeIds).isEmpty,
                           "会客厅 \(encounter.id) 没有接主观题")
        }
    }

    func testHistoryPatternEngineProvidesTransferableDryGoods() {
        XCTAssertGreaterThanOrEqual(HistoryPatternData.all.count, 8)
        let ids = HistoryPatternData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "历史规律卡 ID 重复")
        let knowledgeIds = Set(MainLineData.allKnowledgePoints.map(\.id))

        let text = HistoryPatternData.all
            .map { "\($0.title) \($0.law) \($0.whyItWorks)" }
            .joined(separator: " ")
        XCTAssertTrue(text.contains("制度"))
        XCTAssertTrue(text.contains("经济"))
        XCTAssertTrue(text.contains("思想"))
        XCTAssertTrue(text.contains("世界"))
        XCTAssertTrue(text.contains("史料"))

        for card in HistoryPatternData.all {
            XCTAssertFalse(card.law.isEmpty)
            XCTAssertFalse(card.whyItWorks.isEmpty)
            XCTAssertGreaterThanOrEqual(card.examSignals.count, 2)
            XCTAssertGreaterThanOrEqual(card.applySteps.count, 3)
            XCTAssertGreaterThanOrEqual(card.transferCases.count, 3)
            XCTAssertFalse(card.wrongCounterExample.isEmpty)
            XCTAssertFalse(card.premiumHook.isEmpty)
            XCTAssertGreaterThanOrEqual(card.answerLines.count, 2)
            XCTAssertGreaterThanOrEqual(card.knowledgeIds.count, 4)

            for id in card.knowledgeIds {
                XCTAssertTrue(knowledgeIds.contains(id), "规律卡 \(card.id) 引用不存在考点 \(id)")
                XCTAssertTrue(MainLineData.knowledge(id: id)?.grade == .s || MainLineData.knowledge(id: id)?.grade == .a,
                              "规律卡 \(card.id) 应绑定 S/A 高频考点")
            }

            XCTAssertFalse(PracticeLinker.choiceQuestions(knowledgeIds: card.knowledgeIds).isEmpty,
                           "规律卡 \(card.id) 没有接选择题")
            XCTAssertFalse(PracticeLinker.subjectiveQuestions(knowledgeIds: card.knowledgeIds).isEmpty,
                           "规律卡 \(card.id) 没有接主观题")
        }
    }

    func testExpansionModulesLinkToPractice() {
        for guide in WeaponGuideData.all {
            XCTAssertFalse(PracticeLinker.choiceQuestions(for: guide).isEmpty, "武器 \(guide.weapon.name) 缺关联选择题")
            XCTAssertFalse(PracticeLinker.subjectiveQuestions(for: guide).isEmpty, "武器 \(guide.weapon.name) 缺关联主观题")
            if let id = guide.exampleCaseId {
                XCTAssertNotNil(BossDuelData.duel(id: id), "武器 \(guide.weapon.name) 的 Boss 示例不存在")
            }
        }

        for duel in BossDuelData.all {
            XCTAssertFalse(PracticeLinker.choiceQuestions(for: duel).isEmpty, "Boss \(duel.id) 缺关联练习题")
        }

        for item in MaterialCaseData.all {
            XCTAssertFalse(PracticeLinker.choiceQuestions(for: item).isEmpty, "材料案例 \(item.id) 缺关联选择题")
            XCTAssertFalse(PracticeLinker.subjectiveQuestions(for: item).isEmpty, "材料案例 \(item.id) 缺关联主观题")
        }

        for drill in TrapDrillData.all {
            XCTAssertFalse(PracticeLinker.choiceQuestions(for: drill).isEmpty, "排雷题 \(drill.id) 缺关联选择题")
        }

        for subject in SubjectMatrixData.all {
            XCTAssertFalse(PracticeLinker.choiceQuestions(for: subject).isEmpty, "主体 \(subject.id) 缺关联选择题")
            XCTAssertFalse(PracticeLinker.subjectiveQuestions(for: subject).isEmpty, "主体 \(subject.id) 缺关联主观题")
        }

        for template in AnswerTemplateData.all {
            XCTAssertFalse(PracticeLinker.choiceQuestions(for: template).isEmpty, "模板 \(template.id) 缺关联选择题")
            XCTAssertFalse(PracticeLinker.subjectiveQuestions(for: template).isEmpty, "模板 \(template.id) 缺关联主观题")
        }
    }

    func testReviewIntervalsRespectImportance() {
        XCTAssertEqual(ReviewScheduler.nextInterval(currentLevel: 0, grade: .s, correct: true).days, 2)
        XCTAssertEqual(ReviewScheduler.nextInterval(currentLevel: 0, grade: .a, correct: true).days, 3)
        XCTAssertEqual(ReviewScheduler.nextInterval(currentLevel: 0, grade: .b, correct: true).days, 7)
        XCTAssertEqual(ReviewScheduler.nextInterval(currentLevel: 0, grade: .c, correct: true).days, 30)
        XCTAssertEqual(ReviewScheduler.nextInterval(currentLevel: 4, grade: .s, correct: false).days, 1)
    }

    func testTrapDrillIntegrity() {
        XCTAssertGreaterThanOrEqual(TrapDrillData.all.count, 5)
        let ids = TrapDrillData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "陷阱题 ID 重复")
        let knowledgeIds = Set(MainLineData.allKnowledgePoints.map(\.id))
        let categories = Set(TrapDrillData.all.map(\.category))
        XCTAssertTrue(categories.contains(.scopeOverreach))
        XCTAssertTrue(categories.contains(.subjectMismatch))
        XCTAssertTrue(categories.contains(.causalityReversed))
        for drill in TrapDrillData.all {
            XCTAssertTrue(knowledgeIds.contains(drill.knowledgeId), "陷阱题 \(drill.id) 引用不存在考点")
            XCTAssertFalse(drill.trapOption.isEmpty)
            XCTAssertFalse(drill.correction.isEmpty)
            XCTAssertFalse(drill.explanation.isEmpty)
        }
    }

    func testChoiceQuestionAnswersAreExplicitAndReasoned() {
        let bannedGenericExplanations = [
            "本题要求定时空、看材料、辨析概念边界",
            "史料题要同时看出处、时间、立场、信息和限度",
            "历史因果题不能只背单点原因",
            "比较题要按维度展开"
        ]

        for question in QuestionBank.all {
            let correct = question.options[question.answerIndex]
            XCTAssertTrue(question.explanation.contains("答案："), "选择题 \(question.id) 没有明确写出答案")
            XCTAssertTrue(question.explanation.contains(correct), "选择题 \(question.id) 解析没有包含正确选项原文")
            XCTAssertTrue(question.explanation.contains("原因：") || question.explanation.contains("为什么"),
                          "选择题 \(question.id) 没有解释为什么")
            for phrase in bannedGenericExplanations {
                XCTAssertFalse(question.explanation.contains(phrase), "选择题 \(question.id) 仍有泛泛解析：\(phrase)")
            }
        }
    }

    func testSubjectiveBossAndMaterialAnswersExplainWhatAndWhy() {
        for question in SubjectiveQuestionData.all {
            let answerText = question.answerPoints.joined(separator: " ")
            XCTAssertTrue(answerText.contains("答案："), "主观题 \(question.id) 没有明确答案")
            XCTAssertTrue(answerText.contains("为什么：") || answerText.contains("原因："),
                          "主观题 \(question.id) 没有解释为什么")
            XCTAssertFalse(answerText.contains("从材料和所学可知，") && answerText.contains("深远影响"),
                           "主观题 \(question.id) 仍像通用空模板")
        }

        for duel in BossDuelData.all {
            let answerText = duel.sampleAnswer.joined(separator: " ")
            XCTAssertTrue(answerText.contains("答案："), "Boss \(duel.id) 样例答案没有明确答案")
            XCTAssertTrue(answerText.contains("为什么："), "Boss \(duel.id) 样例答案没有解释为什么")
            XCTAssertFalse(answerText.contains("材料A提供时空和主体行动"), "Boss \(duel.id) 仍有旧泛化答案")
        }

        for item in MaterialCaseData.all {
            let answerText = item.answerSentences.joined(separator: " ")
            XCTAssertTrue(answerText.contains("答案："), "材料案例 \(item.id) 没有明确答案")
            XCTAssertTrue(answerText.contains("为什么："), "材料案例 \(item.id) 没有解释为什么")
            XCTAssertFalse(answerText.contains("材料中的时间、主体和行动共同指向"), "材料案例 \(item.id) 仍有旧泛化答案")
        }
    }

    func testSubjectMatrixIntegrity() {
        XCTAssertGreaterThanOrEqual(SubjectMatrixData.all.count, 4)
        let ids = SubjectMatrixData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "主体矩阵 ID 重复")
        let knowledgeIds = Set(MainLineData.allKnowledgePoints.map(\.id))
        for subject in SubjectMatrixData.all {
            XCTAssertFalse(subject.canDo.isEmpty, "主体 \(subject.id) 缺可做职责")
            XCTAssertFalse(subject.cannotDo.isEmpty, "主体 \(subject.id) 缺禁止串台提醒")
            XCTAssertFalse(subject.triggerWords.isEmpty, "主体 \(subject.id) 缺材料触发词")
            for id in subject.knowledgeIds {
                XCTAssertTrue(knowledgeIds.contains(id), "主体 \(subject.id) 引用不存在考点 \(id)")
            }
        }
    }

    func testAnswerTemplateIntegrity() {
        XCTAssertGreaterThanOrEqual(AnswerTemplateData.all.count, 5)
        let ids = AnswerTemplateData.all.map(\.id)
        XCTAssertEqual(Set(ids).count, ids.count, "模板 ID 重复")
        for item in AnswerTemplateData.all {
            XCTAssertFalse(item.promptType.isEmpty)
            XCTAssertGreaterThanOrEqual(item.structure.count, 3)
            XCTAssertFalse(item.sentenceStarters.isEmpty)
            XCTAssertFalse(item.sample.isEmpty)
        }
    }

    func testReviewProgressManagerRecordsCardState() {
        let manager = ReviewProgressManager.shared
        manager.reset()
        let card = MemoryData.highWeight(limit: 1)[0]
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        manager.record(card: card, correct: true, now: now)
        var state = manager.state(for: card)
        XCTAssertEqual(state.level, 1)
        XCTAssertEqual(state.correctCount, 1)
        XCTAssertGreaterThan(state.nextDue, now)

        manager.record(card: card, correct: false, now: now)
        state = manager.state(for: card)
        XCTAssertEqual(state.level, 0)
        XCTAssertEqual(state.wrongCount, 1)
    }
}
