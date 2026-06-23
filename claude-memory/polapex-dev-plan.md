# HistApex Development Memory

## Objective

Build **HistApex · 历史登顶** as an independent Apex family app in `trae_projects/histapex`.

- Bundle id: `com.histapex.app`
- IAP product id: `com.histapex.app.full_unlock`
- Tech stack: SwiftUI / iOS 16 / Swift 5 / XcodeGen
- Product core: knowledge coverage + weighted memory + answer-output loop
- Current phase: **P1 spine + weighted coverage MVP complete**

## Development Rules

1. Keep HistApex independent from ChemApex. Do not put HistApex files under `chemapex`.
2. Follow `../APEX_APP_开发范式.md`.
3. Each phase must be independently buildable and verifiable.
4. Reuse Apex family patterns where practical: DesignSystem, ThemeColors semantics, ReviewScheduler shape, paywall/promo structure, readable width, StoreKit naming.
5. Self-build the political-science heart: weighted memory, concept graph, material slicer, answer factory, subject matrix, weapon guides.
6. Content red lines: no fabricated exam source, no vague slogans as answers, no promise of “no memorization full marks”, timestamp sourced current-history material.
7. Visual baseline now follows `../chemapex/ChemApex`: dynamic light/dark colors, warm paper background, rounded card surfaces, lava accent, and user-selectable appearance with default "跟随系统".

## 2026-06-18 上线前内容补强计划

Current judgment: HistApex 的技术框架、模块串联、题型比例和内购骨架已经站住，但内容仍需要从“覆盖完整”推进到“可收费的高质量内容”。上线前重点不是继续堆新模块，而是把高频考点、史料题、规律迁移、易错排雷和内购价值做厚。

### A. 高频知识点人工精修

Goal: 把通用模板型深讲替换为真正像老师归纳的考点讲解。

- [ ] 人工精修至少 30-40 个最高频 S/A 考点。
- [ ] 每个精修点必须包含：必背句、白话理解、答题模板、材料触发词、易混辨析、常见陷阱、高分答案句、默写清单。
- [ ] 第一批优先点：
  - 中国古代史：分封宗法、郡县制、三省六部、科举制、宋代商品经济、明清君主专制、白银货币化。
  - 中国近现代史：洋务运动、维新变法、辛亥革命、新文化运动、工农武装割据、抗日民族统一战线、一五计划与三大改造、改革开放。
  - 世界史：新航路开辟、英国君主立宪、美国 1787 年宪法、法国大革命、工业革命、罗斯福新政、冷战、多极化。
  - 史学方法：一手/二手史料、史料价值与局限、历史解释、现代化史观、全球史观、历史小论文。
- [ ] 已开始补充的人工精修点继续保留并跑测试：`k1001`, `k1202`, `k1301`, `k1501`, `k1504`, `k1702`, `k1704`, `k1901`, `k1902`, `k2103`。

### B. 题库与题型比例

Goal: 不靠题海，而是让高频点有像高考的题型闭环。

- [ ] 每个人工精修点至少补：2 道高考风格选择题 + 1 道非选择题。
- [ ] 继续遵守 `ExamPracticeBlueprint`：选择题约 48 分，非选择题约 52 分。
- [ ] 新增题优先补非选择题：史料分析、背景原因、影响意义、观点评析、历史小论文。
- [ ] 每道非选择题必须有材料、设问、分值、采分点、自查清单。
- [ ] 避免 generated 题目占比过高；上线前人工题应能撑起首页套练和内购展示。

### C. 薄弱模块丰满

Goal: 把现有模块从“有入口”升级为“有内容密度”。

- [ ] `ConceptGraphData`：从前 14 关扩到全部 28 关；关系不只“前后承接”，要加入因果、比较、继承、转型、冲突、史观转换。
- [ ] `MaterialCaseData`：从前 16 关扩到至少 28 个案例；高中后半、选必、冲刺必须覆盖；材料文本要更像高考材料。
- [ ] `TrapDrillData`：从 5 个扩到 20+，覆盖时间错位、主体错配、因果倒置、范围扩大、无中生有、偷换概念、绝对化、正确无关。
- [ ] `SubjectMatrixData`：从 4 类扩到 12 类左右，补农民、工人、地主士绅、知识分子、资产阶级革命派、洋务派/维新派、政党、列强、国际组织。
- [ ] `AnswerTemplateData`：从 5 类扩到 10+，补特点类、变化趋势类、启示认识类、史料价值类、史论结合类、原因影响综合类。
- [ ] `HistoryPatternData`：从 8 条规律扩到 20 条，作为内购最核心“干货”资产。
- [ ] `TimeMuseumData` 和 `HistoryEncounterData`：继续作为轻松入口，但每次新增都必须绑定 S/A 考点和练习题。

### D. 内购价值打磨

Goal: 让用户明确知道为什么值得购买。

- [ ] 免费层保留：初中通史、少量展馆/会客厅、少量规律卡、基础复习。
- [ ] 完整版重点突出：历史规律引擎、高考比例套练、史料题题型池、史料侦探高级案例、完整主线、Boss 双解。
- [ ] Paywall 文案不要讲“题多”，要讲“少背散点、形成迁移模型、主观题能写出采分句”。
- [ ] 每个付费核心模块首页都要显示：覆盖多少考点、多少题、能解决什么高考痛点。

### E. 上线前工程与产品检查

Goal: 做到可以提交 TestFlight / App Store 的状态。

- [ ] 所有新增 Swift 文件后必须 `xcodegen generate`。
- [ ] 每轮内容扩充后必须跑：`xcodebuild test -scheme HistApex -project HistApex.xcodeproj -destination 'platform=iOS Simulator,name=iPhone 17'`。
- [ ] 清理历史遗留文案：当前 memory/PLAN 中仍有早期政治版内容，后续需要系统替换为历史学科表述。
- [ ] 检查 App icon 是否仍是占位图，准备历史气质图标。
- [ ] 准备隐私政策、用户协议、支持页面、App Store 截图文案、内购说明。
- [ ] 上线前至少完成一次真机/模拟器 UI 浏览：浅色、深色、跟随系统、iPhone、小屏和 iPad。

### Next Work Order

1. 完成已开始的人工精修点补充并跑测试。
2. 扩 `TrapDrillData`, `SubjectMatrixData`, `AnswerTemplateData` 三个薄弱模块。
3. 扩 `MaterialCaseData` 到 28 个案例。
4. 扩 `ConceptGraphData` 到全 28 关并增加多关系边。
5. 给新增精修点补人工选择题和非选择题。
6. 回头清理 `PLAN.md` 和本 memory 文件中的政治版历史遗留表述。

## Phase Plan

### P0 Skeleton

Goal: create a buildable independent SwiftUI app shell.

- [x] `project.yml` for XcodeGen
- [x] `HistApex/App/HistApexApp.swift`
- [x] `HistApex/App/RootView.swift`
- [x] `Core/Renderer/DesignSystem.swift`
- [x] `Core/Renderer/ThemeColors.swift`
- [x] `Core/Models/Stage.swift`
- [x] 4-tab shell: 登顶之路 / 答案工厂 / 概念星图 / 更多
- [x] App icon placeholder asset
- [x] `HistApexTests/HistApexTests.swift`
- [x] `HistApex.storekit`
- [x] Generate Xcode project
- [x] Run build/test

### P1 Spine

Goal: implement the main learning spine and monetization boundary.

- [x] History topic/weapon/knowledge models
- [x] 28-node mainline data
- [x] knowledge importance model
- [x] progress manager
- [x] node detail page
- [x] PurchaseManager + paywall + free-tier policy constants
- [x] PromoView
- [x] tests for unique ids, references, free-tier policy

### P1.5 Weighted Gaokao Coverage

Goal: ensure every political knowledge point has practice and priority.

- [x] 112-point initial exam catalog: junior DaoFa, required high-school history, selective compulsory, sprint
- [x] importance split: S 36 / A 48 / B 26 / C 2
- [x] weighted generated choice practice: S 4, A 3, B 2, C 1, total 342
- [x] S/A subjective practice, total 84
- [x] coverage dashboard in app
- [x] tests guaranteeing every knowledge point has weighted questions and S/A subjective practice

### P2 Weighted Memory Engine

Goal: make political memorization concrete and adaptive.

- [x] five memory card types: 原话 / 边界 / 主体 / 场景 / 模板
- [x] weighted review intervals for S/A/B/C points
- [x] recall modes: 认得出 / 背得出 / 分得清 / 用得上
- [x] high-weight daily queue
- [x] local review state manager with correct/wrong counts, level, next due date
- [x] Smart Review UI: due queue, card reveal, remembered/forgotten recording
- [ ] terminology accuracy tracking
- [ ] tests for interval transitions and due-card ordering

### P2.5 First Expansion Modules

Goal: add high-impact political-score modules beyond the spine.

- [x] Choice trap drill range: 12 hand-authored traps covering 主体错配 / 绝对化 / 因果倒置 / 范围越界 / 无中生有 / 正确无关
- [x] Political subject matrix: 10 subjects covering party, NPC, government, CPPCC, court, procuratorate, citizen, enterprise, market, grassroots autonomy
- [x] Answer template library: 6 templates for 原因 / 措施 / 意义 / 体现 / 哲学 / 评析
- [x] New module entry cards on 答案工厂 and 更多
- [x] Integrity tests for trap drills, subject matrix, templates, review state

### P2.6 Content Depth Remediation

Goal: fix the "empty shell knowledge point" problem by turning each high-value point into a recitable, distinguishable, and answer-ready study unit.

Audit finding:

- Current `KnowledgePoint.detail` is mostly one sentence, suitable for card previews but too thin for a memorization-heavy political-science app.
- Choice questions, subjective questions, and memory cards all reuse the same `detail`, so practice volume looks large but content depth repeats.
- Material cases and concept graph are useful, but coverage is narrow compared with the 112-point catalog.
- Existing tests validate counts, references, and non-empty fields, but do not validate explanation depth.

Remediation requirements:

- [ ] Extend knowledge data from one-line detail to structured explanation fields: must-recite lines, plain explanation, answer template, trigger scenes, confusion pairs, common traps, sample answer sentences, recite checklist.
- [ ] Prioritize S/A points first, especially 党的领导、人大、政府、政协、公民、全过程人民民主、依法治国、市场与宏观调控、基本经济制度、实践与认识、矛盾观、文化创新、国家利益、民事责任、主观题模板.
- [ ] Update node detail UI so a knowledge point shows 必背原文 / 白话理解 / 答题模板 / 易混辨析 / 材料触发 / 高分答案句 / 扣分提醒 / 默写清单.
- [ ] Split memory-card backs by card type so 原话卡背原文、边界卡背易混、主体卡背职责、场景卡背触发、模板卡背输出句.
- [ ] Replace generated subjective answer points with structured knowledge explanation where available.
- [ ] Add content quality tests: S points must have enough must-recite lines, sample answer sentences, and traps; high-priority points must not rely only on `detail`.

Acceptance target for first implementation pass:

- [x] At least 20 S-level points have deep structured explanations.
- [x] S-level deep points each include at least 3 must-recite lines, 2 sample answer sentences, and 2 common traps or confusion notes.
- [x] Node detail and review cards visibly use the deeper content.
- [x] Tests fail if S-level content regresses to one-line shells.
- [x] All 36 S-level points now have structured deep explanations and are guarded by tests.
- [x] First A-level remediation wave: 22 high-frequency A points have structured deep explanations and are guarded by tests.
- [x] All 48 A-level points now have structured deep explanations and are guarded by tests.

### P3 Concept Graph

Goal: build the political knowledge map.

- [ ] concept graph model
- [ ] subject responsibility graph
- [ ] confusion edge data
- [ ] weighted heat rendering
- [ ] graph/list hybrid UI
- [ ] tests for valid node/edge references

### P4 Answer Factory

Goal: train material-question output.

- [ ] MaterialSlice model
- [ ] subject/action/object/goal detection rules
- [ ] six-step essay workflow
- [ ] answer sentence templates
- [ ] diagnostic tags: 主体错配 / 范围越界 / 因果倒置 / 术语不准 / 材料没贴
- [ ] short-answer practice UI

### P5 Weapon Library

Goal: implement method coaching and boss dual-solution cases.

- [ ] 12 MVP weapons
- [ ] weapon guide pages: when to use / steps / boss duel / practice
- [ ] choice-question trap filter
- [ ] philosophy locator
- [ ] economy chain
- [ ] contradiction three questions
- [ ] 20 boss duel cases
- [ ] tests for boss references and answer validity

### P6 Content Coverage

Goal: fill initial junior + senior mandatory + elective content.

- [ ] junior law/nation/growth points
- [ ] high school mandatory 1-4 points
- [ ] selective compulsory 1-3 points
- [ ] reverse-generated training items per knowledge point
- [ ] coverage dashboard
- [ ] tests for minimum coverage by importance grade

### P7 Emotional Hooks

Goal: add stories without losing exam relevance.

- [ ] thinkers / legal figures / governance stories
- [ ] archive list and detail pages
- [ ] every story ends with linked exam points
- [ ] tests for linked knowledge ids

### P8 Release Prep

Goal: prepare for App Store submission.

- [ ] final 1024 icon flattened without alpha
- [ ] StoreKit scheme configuration
- [ ] docs: index / privacy / terms / support
- [ ] iPad readable width validation
- [ ] launch screenshots checklist
- [ ] release checklist package
- [ ] full `xcodebuild test`

## Current Progress

- 2026-06-15: Created independent project directory `histapex`.
- 2026-06-15: Created product design `PLAN.md`.
- 2026-06-15: Created this development memory file.
- 2026-06-18: Implemented independent SwiftUI/XcodeGen app shell, StoreKit config, theme, icon, four tabs.
- 2026-06-18: Implemented 28-node political learning spine, 112 weighted knowledge points, generated 342 weighted choice questions and 84 S/A subjective questions.
- 2026-06-18: Implemented material slicer, answer factory, concept graph, weapon library, boss duels, progress manager, paywall/free tier, coverage tests.
- 2026-06-18: Generated `HistApex.xcodeproj`; `xcodebuild ... test` on iPhone 17 simulator passed 8 tests, 0 failures.
- 2026-06-18: First expansion completed: smart review module, choice trap drill range, political subject matrix, answer template library.
- 2026-06-18: Regenerated `HistApex.xcodeproj`; `xcodebuild ... test` on iPhone 17 simulator passed 12 tests, 0 failures.
- 2026-06-18: Audited knowledge content depth. Found the app has adequate coverage counts but many knowledge points are one-line shells; added P2.6 content-depth remediation plan.
- 2026-06-18: Implemented structured `KnowledgeExplanation`, node-detail deep study cards, deep memory-card backs, deep subjective answer points, and content-quality tests.
- 2026-06-18: Completed S-level remediation: all 36 S-level knowledge points now have must-recite lines, plain explanations, answer templates, trigger scenes, confusions/traps, sample answer sentences, and recite checklists. `xcodebuild ... test` passed 14 tests, 0 failures.
- 2026-06-18: Completed first A-level remediation wave: 22 high-frequency A points across junior law/democracy/nation, socialism, economy, culture, international relations, and legal life now have structured deep explanations. `xcodebuild ... test` passed 15 tests, 0 failures.
- 2026-06-18: Completed A-level remediation: all 48 A-level knowledge points now have must-recite lines, plain explanations, answer templates, trigger scenes, confusions/traps, sample answer sentences, and recite checklists. Tests now require every S/A point to have deep content. `xcodebuild ... test` passed 15 tests, 0 failures.
- 2026-06-18: Migrated HistApex visual baseline to match `../chemapex/ChemApex`: dynamic `UIColor`-backed ThemeColors, ChemApex-style card surface/radius/shadow, lava tab accent, App-level `AppearanceManager`, and "更多 > 外观" picker with 跟随系统/浅色/深色. Default remains follow system. `xcodebuild ... test` passed 15 tests, 0 failures.
- 2026-06-18: Product-structure remediation after module-linking audit: added `PracticeLinker` so weapons, Boss duels, material cases, trap drills, subject matrix, and answer templates all link back to choice/subjective practice; expanded subjective generation from S/A to S/A/B so logic and legal-life modules have主观题; added node full-practice-id checks and expansion-module practice-link tests.
- 2026-06-18: IAP value remediation: added `PremiumContentPlan`, rewrote paywall around six purchasable pillars, surfaced free-vs-full boundaries, and reorganized 答案工厂 into a study loop: 提分闭环 / 完整版价值 / 方法训练区 / 材料切片 / Boss 双解 / 主观题 / 记忆 / 覆盖数据. `xcodebuild ... test` passed 17 tests, 0 failures.
- 2026-06-18: Content breadth expansion wave: Boss Duel expanded from 7 to 15 cases, covering Chinese modernization, distribution/common prosperity, CPPCC, practice/knowledge, people/value choice, culture, international relations, and civil law in addition to existing organs/market/party/rule-law/contradiction/hot/essay. Material cases expanded from 5 to 15, adding new quality productive forces, distribution, party-led rule-of-law governance, CPPCC eldercare, public hearing, national security, contract dispute, labor overtime, global climate governance, and core-values network governance.
- 2026-06-18: Added tests requiring at least 15 Boss duels and 15 material cases, unique ids, valid node/knowledge references, 3+ solution/answer steps, and non-empty diagnostics. `xcodebuild ... test` passed 18 tests, 0 failures.
- 2026-06-18: Added Gaokao-ratio practice calibration: `ExamPracticeBlueprint` models the common new-Gaokao political elective structure as 16 single-choice questions / 48 points and 4 non-choice questions / 52 points, with province-level variation noted in UI copy. Added `ExamPracticeData` six套高考比例套练, training-page entry, set detail UI, topic slots, and tests enforcing 16+4 structure plus economy/history-law/philosophy-culture/sprint subjective coverage. Premium value copy now highlights ratio-based套练 instead of raw question volume. `xcodebuild ... test` passed 19 tests, 0 failures.
- 2026-06-18: Corrected practice expansion direction after audit: do not judge Gaokao alignment by raw question count. Added `SubjectiveQuestionType` and per-question score, split generated/authored practice pools, added authored high-school style questions, and made exam套练 prefer authored items while enforcing 48-point choice + 52-point non-choice score weight. Non-choice pool now covers measures, material analysis, significance, evaluation, and open inquiry, with UI chips showing type and score. Added tests for authored question validity, non-choice type coverage, and 52-point non-choice total. `xcodebuild ... test` passed 20 tests, 0 failures.
- 2026-06-18: Final weak-point audit found the IAP plumbing already worked, but the purchase module lacked ChemApex-level value clarity. Reworked `PremiumContentPlan` and `PaywallView` to mirror ChemApex's hero + benefit rows + one-time unlock CTA while using HistApex-specific assets: Gaokao-ratio套练, non-choice question type pool, material answer factory, subject matrix, weapon library, Boss dual solutions, and review loop. Updated `HistApex.storekit` product copy, added DEBUG local unlock toggle, and added premium-plan tests requiring 48/52 and non-choice type messaging. `xcodebuild ... test` passed 21 tests, 0 failures.
- Next: continue adding questions by topic, but prioritize non-choice题型广度 and分值权重 first: every new wave should add fewer choice questions and more material/措施/意义/评析/开放探究题, keep `ExamPracticeBlueprint` passing, and keep IAP value copy focused on purchasable training assets instead of raw content counts.

## 2026-06-22 上线前内容核查与第一轮付费 S 级精修

Audit finding: `hasDeepExplanation`/`testPrioritySPointsHaveDeepExplanations` 等测试只检查字段非空，而 `MainLineData.kp()` 的通用兜底模板本身就会填满这些字段，所以此前显示的"S/A 100% 深度覆盖"是假阳性。精确统计后，112 个知识点中只有 17 个真正人工精修（`AuthoredKnowledgeData.explanations`），其余约 85% 是换标题的模板内容；选择性必修三本书（国家制度/经济与社会/文化交流）合计只压缩进 3 个节点 12 个知识点，经济与社会生活模块当时是 0 个人工精修、0 道人工非选择题。另发现 `kp()` 生成 `detail`/`pitfall` 时永远使用通用模板字符串，即使该知识点已被人工精修也不会跟着换——而 `detail` 正是 `AscentPathView` 主线详情页直接展示的文本。

用户决策：本轮先补付费内容（必修10-21、选择性必修22-26、冲刺27-28）再补免费层（初中节点1-9）；选择性必修的结构性扩容（拆分出更多节点）本轮不做，作为下一轮单独立项。

第一轮（本轮）完成内容：

- 修复 `MainLineData.kp()`：`detail`/`pitfall` 现在优先取精修内容的 `mustRecite.first`/`commonTraps.first`，不再永远显示通用模板；`KnowledgePoint.commonTrapLines` 加了去重判断避免 pitfall 和 commonTraps 首句重复。
- 新增反模板测试 `testEveryAuthoredKnowledgePointAvoidsGenericTemplateShell`，对所有标记为"已精修"的知识点断言不含通用模板固定句式，防止后续再退化成假阳性。
- 把付费 S 级知识点的人工精修从 17 个提升到 43 个（覆盖全部 26 个本轮目标付费 S 点：先秦秦汉隋唐宋元明清剩余点、晚清到新中国剩余点、新航路到二战剩余点、国家制度/经济与社会/文化交流全部 S 点、史料方法和史观、选择题陷阱和史料小论文方法点）。
- 人工选择题从 17 道增加到 36 道，人工非选择题从 8 道增加到 9 道（economySociety 历史上首次有人工非选择题 `asq_econ_01`）。
- 顺带修正一处既有数据 bug：`aq_method_02`（现代化史观选择题）此前误挂在知识点 `k2601`（革命史观）上，已改挂回 `k2602`。
- `xcodebuild test`（iPhone 17 模拟器）全程保持 38/38 通过。

## 2026-06-22 第二轮：付费 A 级知识点精修（完成全部付费内容）

延续第一轮的方法论和优先级（付费内容优先，结构性扩容不动），把剩余 33 个付费 A 级知识点全部补成真人工精修内容：中国古代史 8 个（商鞅变法、百家争鸣、独尊儒术、丝绸之路与边疆治理、宋代商品经济、元代行省制度、白银货币化、明清思想文化）、中国近现代史 5 个（维新变法、民族资本主义发展、全民族抗战、人民解放战争、中国特色大国外交）、世界史 7 个（商业革命和价格革命、全球联系加强、法国大革命、启蒙运动、马克思主义诞生、资本主义世界市场形成、世界多极化趋势）、选择性必修 6 个（基层治理传统、国家治理现代化、工业化道路、社会生活变迁、西学东渐、全球化下文化交流）、史学方法 4 个（历史解释、史论结合、全球史观、文明史观）、冲刺模块 3 个（因果倒置、绝对化表述、开放题评分点）。每个点都配了至少 1 道人工选择题。

里程碑：人工精修知识点从 43 个增加到 **76 个**，恰好等于全部付费知识点总数（必修+选择性必修+冲刺，38 个 S 级 + 38 个 A 级），即**付费内容人工精修覆盖率达到 100%**；人工选择题从 36 道增加到 **69 道**；`xcodebuild test` 全程保持 38/38 通过。

## 2026-06-22 第三轮：三个薄弱周边模块扩容

`TrapDrillData`/`SubjectMatrixData`/`AnswerTemplateData` 是 2026-06-18 计划里点名要扩容的"薄弱模块丰满"项，此前一直停留在最低测试阈值（5/4/5），本轮按当年计划目标补满：

- `TrapDrillData` 从 5 条扩到 **22 条**，6 个 `TrapCategory` 分类（主体错配/绝对化/因果倒置/范围越界/无中生有/正确无关）均衡覆盖（4/4/4/4/3/3），且把此前所有陷阱题共用的同一句通用 `explanation`（"历史选择题先排时间、主体、因果和史料限度。"）拆成了每条独立、针对具体陷阱写的解析。
- `SubjectMatrixData` 从 4 个主体扩到 **12 个**，新增农民阶级、工人阶级、地主士绅阶层、近代先进知识分子、资产阶级革命派、洋务派与维新派、近代政党组织（国共两党）、列强与国际组织。
- `AnswerTemplateData` 从 5 个模板扩到 **10 个**，新增特点类、变化趋势类、启示认识类、史料价值类、原因影响综合类；同步重写了 `templates(for:node:)` 的武器映射逻辑，让新模板能在对应的武器节点正确展示，而不是只新增数据却没有入口。

`xcodebuild test` 全程保持 38/38 通过。

## 2026-06-23 第四轮：免费层（初中9关）知识点精修——112 个知识点全量精修完成

把最后剩余的免费层 36 个知识点（初中节点1-9，18 个 S + 18 个 A，覆盖中国古代史、中国近现代史、世界史三条线）全部从模板内容补成人工精修内容，难度和表述按初中学情简化（少用高考分析框架，多用口诀式记忆点），每个点配至少 1 道人工选择题。

**里程碑：112 个知识点全部完成人工精修（100%），人工选择题从 69 道增加到 104 道。** 至此 `MainLineData.kp()` 的通用兜底模板（`HistContentData.swift` 里的 `explanation(title:topic:weapon:)` 函数）已无任何知识点在实际使用——全部走 `AuthoredKnowledgeData.explanations` 的人工内容路径。`xcodebuild test` 全程保持 38/38 通过。

## 2026-06-23 第五轮：内容质量把关审查

用户开始自行处理 git 提交，要求 Claude 专职负责知识点内容补充把关和习题质量保证。本轮是纯审查/修复轮，没有新增知识点。

审查方式：通读 `AuthoredKnowledgeData.swift`（2300+ 行，112 个知识点全部精修内容）和 `AuthoredPracticeData.swift`（104 道人工选择题 + 9 道人工非选择题的解析），逐条核对史实准确性。

发现并修复的问题：

1. **史实精度**：`aq_ac_13`（元代行省制度选择题解析）原文说"元朝事实上仍保留了科举制度"，暗示连续未中断，实际上元朝灭南宋后科举制中断了三十余年，直到1315年元仁宗才恢复。已改为准确表述"科举制在元朝中期（1315年）恢复并延续到明清，并未被元朝废除"。
2. **数据正确性 bug**：`AuthoredSubjectiveQuestionData.sq()` 辅助函数把所有人工非选择题的 `grade` 字段硬编码为 `.s`，目前9条数据恰好都是S级所以没暴露问题，但这是个潜在隐患——以后给A级点加人工非选择题时grade会被错误标记。已改为从 `MainLineData.knowledge(id:)` 动态取真实等级。
3. **系统性质量缺口（影响面最大）**：`SubjectiveQuestionData.subjectiveScene()` 生成的约100道生成式非选择题，其 `material`（材料）字段一直是元描述语言（如"材料摘录了与XXX相关的时间、主体行动和评价语句"），而不是真实材料内容——即使112个知识点已经全部人工精修，生成主观题的"材料"部分从未真正引用这些精修内容，只有"采分点"部分在用。这造成材料和答案两部分自说自话。已改为 `material` 直接取该知识点的 `mustReciteLines`（必背史实），材料和采分点现在共用同一套真实内容。
4. **测试守门更新**：`testGeneratedSubjectiveQuestionsHaveTypeAndPromptVariety` 里检测材料模板的字符串（"材料围绕"）已经是几轮迭代前的旧字符串，对当前代码的实际模板特征毫无防护力，等于测试在"假装"在把关。已替换成针对当前 5 种模板的元语言检测，并新增断言：每道生成主观题的材料必须包含该知识点的某条必背史实，确保材料和内容真正挂钩。

`xcodebuild test` 全程保持 38/38 通过（含强化后的新断言）。

下一轮待办（未在本轮展开）：

- 选择性必修结构性扩容（国家制度/经济与社会/文化交流各从 1 个节点拆到 2-3 个节点）未做，需要单独评估对 28 关总数、免费/付费边界、Boss 映射等下游代码的影响。这是目前内容层面唯一还没动的较大改动。
- App Store 上架还缺隐私政策/服务条款/支持页文档（repo 内未发现 `docs/` 目录）。
- 本轮审查覆盖了全部 112 个知识点的精修内容和题目解析，未发现其他史实错误；但审查方式是人工通读，没有做覆盖性的逐字核对，仍建议未来有历史学科背景的人做一轮独立校对。

## 2026-06-23 第七轮：按知识点重要程度配题量

用户提出新原则：习题数量要按知识点重要程度（S/A）分级安排，不能所有点一刀切给一样的题量。审计发现：生成式题库本身已经按等级分级（`QuestionBank.questionCount`：S=4/A=3/B=2/C=1 道生成选择题），但人工精修题库完全没有体现等级差异——S 和 A 点几乎都只有 1 道人工选择题，且 3 个 S 点（k1001/k1702/k1902）和 5 个 A 点（k1403/k1504/k1704/k2103/k2803）甚至 0 道，只能靠生成式兜底。

执行的修复：

1. **先补真空白**：给上述 8 个零覆盖点（3 个 S + 5 个 A）各补 1 道人工选择题，确保全部 112 个知识点至少有 1 道人工选择题——这一步与"重要程度"无关，是更基础的覆盖底线。
2. **按重要程度拉开差距**：选取 10 个仍只有 1 道人工选择题的付费 S 级点（跨中国古代史/近现代史/世界史/史学方法/冲刺 5 个 topic），每个点补第 2 道人工选择题 + 1 道人工非选择题，让 S 级点的人工题量明显超过 A 级点（A 级目前稳定在 1 道人工选择题，靠生成式的 3 道选择题与 S 级的 4 道拉开差距）。

**当前数据**（112 个知识点）：S 级 0 道人工选择题的点：0 个；S 级 2+ 道人工选择题的点：30/56；S 级有人工非选择题的点：30/56。A 级仍保持 1 道人工选择题、0 道人工非选择题（A 级的差异化主要靠生成式题量 3 道 vs S 级 4 道体现，没有再额外加人工题，避免不必要的工作量）。

剩余 10 个付费 S 级点（k1002/k1201/k1202/k1302/k1502/k1602/k1702/k1802/k2002/k2102）和 16 个免费层 S 级点仍只有 1 道人工选择题，可作为下一轮继续按同样模式推进。

## 2026-06-23 第八轮：付费 S 级点配题量收官

延续上一轮模式，把剩余 10 个付费 S 级点（k1002/k1201/k1202/k1302/k1502/k1602/k1702/k1802/k2002/k2102）各补第 2 道人工选择题 + 1 道人工非选择题，覆盖中国古代史、中国近现代史、世界史三个 topic。这一批全部一次性通过测试，没有触发连带回归——前几轮踩过的"新题分值/题型混入候选池打破不变量"的坑，这次在写题时就提前对齐了同 topic 已有题目的分值模式。

**里程碑：全部 40 个付费 S 级知识点（中国古代史/近现代史/世界史/史学方法/冲刺）现在都有 2 道以上人工选择题 + 至少 1 道人工非选择题。** A 级点保持 1 道人工选择题不变（差异化由生成式 4 道 vs 3 道体现）。剩余的"只有 1 道人工选择题"的 16 个点全部是免费层初中知识点，按既定优先级排在后面。

累计数据：人工选择题 132 道（轮次起点 17 道），人工非选择题 41 道（轮次起点 9 道）。`xcodebuild test` 全程保持 38/38 通过。

## 2026-06-23 第九轮：免费层 S 级点收官，按重要程度配题量全部完成

把剩余 16 个免费层 S 级点（初中节点1-9：k0101/k0102/k0202/k0301/k0302/k0401/k0402/k0501/k0502/k0601/k0602/k0701/k0702/k0801/k0802/k0901）补齐第 2 道人工选择题 + 1 道人工非选择题，难度按初中学情简化。这批 32 个新条目一次性全部通过测试，没有触发任何连带回归。

**里程碑：全部 112 个知识点里的 56 个 S 级点，现在 100% 都有 2 道以上人工选择题 + 至少 1 道人工非选择题。** 至此"按知识点重要程度安排习题数量"这条任务线全部完成：S 级点题量明显多于 A 级点（人工层面 2+ 道 vs 1 道，生成层面 4 道 vs 3 道），A 级点维持 1 道人工选择题不再额外加量。

累计数据：人工选择题从起点 17 道增加到 **148 道**，人工非选择题从起点 9 道增加到 **57 道**。`xcodebuild test` 全程保持 38/38 通过。

下一步可选方向（未要求情况下不主动展开）：
- A 级知识点（56 个，目前只有 1 个有 2+ 道人工选择题、1 个有人工非选择题）是否也要补充，目前判断不需要——生成式题量本身已做 S/A 区分，人工题的差异化目的已经达成，继续加只是堆数量、边际价值低。
- 选择性必修结构性扩容、App Store 合规文档仍是未动的两项，状态同上一轮记录。

## 2026-06-23 第十轮：概念星图设计对齐 polapex + 修复套练访问缺口

用户要求"概念星图模仿上级目录的 polapex 项目的设计，另外宣传有 6 套高考比例套练"。

**概念星图重做**：对比发现 polapex（`../polapex/PolApex/Features/ConceptGraph/ConceptGraphView.swift`）的设计明显更完整——按模块（topic）分组、可展开/收起，展开后渲染"概念圆环"（权重最高节点居中，其余按圆周均匀分布，Canvas 画连线，选中节点高亮连线），点节点弹出 sheet 显示主体职责、材料触发词（FlowWrap 自动换行）、深度知识卡（复用 `KnowledgePointStudyCard`）、关系边并支持在 sheet 内继续跳转到关联节点。HistApex 原来的版本只是一个平铺网格 + 内嵌详情面板，没有圆环、没有 Canvas 连线、详情里也没接深度知识卡。

落地改动：
1. `Core/Renderer/DesignSystem.swift` 新增 `FlowWrap`（按行自动换行的 Layout，直接从 polapex 移植）。
2. `Core/Engine/HistContentData.swift` 给 `ConceptGraphData` 新增 `knowledgePoints(for:)`，把概念节点 id（`c_n01`）解析回 `LearningNode` 取知识点列表。
3. `Features/AscentPath/AscentPathView.swift` 把 `KnowledgePointStudyCard` 从 `private struct` 改成 `struct`，让 ConceptGraphView 能复用（HistApex 这个卡片是分段选择器样式，不是 polapex 那种可折叠区块样式，故 sheet 里调用时不传 `defaultExpanded` 参数，没有连带搬运卡片内部的折叠重构——那是另一个组件的事，不在这次"概念星图"范围内）。
4. `Features/ConceptGraph/ConceptGraphView.swift` 整体按 polapex 结构重写：模块分组、默认展开节点最多的模块、圆环布局、Canvas 连线、sheet 详情。

**6 套高考比例套练**：审计发现一个真实的功能缺口——`ExamPracticeData.all` 有 6 套，但 `TrainingView.swift` 里唯一引用它的地方用了 `prefix(3)`，且没有任何"查看全部"入口，导致第 4-6 套从应用内任何位置都无法到达，付费用户买了"6 套"实际上只能用 3 套。修复：新增 `ExamPracticeListView`（仿照已有的 `SubjectivePracticeListView` 模式）列出全部 6 套，并在 `examPracticeSection` 加了"查看全部 6 套"入口；同时把 section 标题和 `PremiumPillar` 文案都显式写出套数（之前只有 `PaywallView` 的 hero benefit 动态显示数字，其余地方都没提具体数量）。

**实机验证**：用 `run` skill 在模拟器里实际跑了一遍。`-skipPromo` 启动参数跳过引导页直接进主界面；通过 `osascript`/System Events 模拟点击验证了概念星图的圆环布局和模块展开/收起确实按预期渲染（截图可见"初中中国古代史"模块展开后，"中华文明起源与早期国家"居中、其余三个节点环绕排布，连线清晰）。受限于 sandbox 里 Accessibility 自动点击的可靠性问题（多次点击在小目标——圆形节点气泡——上失手，期间还导致模拟器一度无响应重启），没能拍到点开节点气泡弹出 sheet 的截图，也没能精确点中"套练"分段标签验证 `ExamPracticeListView`；这两处改动改为依赖代码比对（与已验证可用的 polapex/`SubjectivePracticeListView` 模式逐行对应）和全量测试通过来兜底信心，不算完整的视觉验证。

`xcodebuild test` 全程保持 38/38 通过。

**修复了 2 处连带 bug**（都是数据池里混入不一致分值/类型的题目，被现有轮换选题逻辑随机抽中后打破不变量）：
1. 新增 `asq_wh_04`（世界史，significance 类型）后，世界史 topic 第一次真正命中 `ExamPracticeBlueprint` declared 的 slot 类型，但该 slot 当年声明的类型（`.significance`）其实和测试断言、以及现有 3 道世界史人工题（全是 `.evaluation`）都不一致——只是因为该 slot 一直靠 fallback 兜底才没暴露。把 blueprint 里这个 slot 的类型从 `.significance` 改成 `.evaluation`，使其和测试期望、和现有内容的真实类型保持一致，这是修正了一个被掩盖多轮的潜在配置错误，不是引入新的不一致。
2. 给 k1601 配人工非选择题后，破坏了某条测试隐含依赖"k1601 没人工题，所以取到含'背景/影响'字样的生成题"的假设——已在上上轮修复，本轮未再触发。

`xcodebuild test` 全程保持 38/38 通过。

## 2026-06-23 第六轮：人工非选择题扩容到全部 11 个 topic

用户开始自行处理 git 提交；继续由 Claude 负责内容补充和习题质量把关。延续第五轮审查发现的"人工非选择题覆盖太薄"问题，新增 12 道人工非选择题：中国古代史 +1（k1301 明清君主专制）、中国近现代史 +2（k1601 五四运动、k1701 巩固政权）、世界史 +1（k2101 凡尔赛体系）、冲刺 +1（k2802 比较题矩阵，用洋务运动对比明治维新）、史学方法 +1（k2601 革命史观评太平天国）、文化交流 +1（k2402 佛教中国化）、国家制度 +1（k2202 近现代民主制度探索）、经济与社会 +1（k2301 小农经济），以及初中三条线各 1 道（k0201 秦中央集权、k0504 辛亥革命、k0902 资产阶级革命）。所有材料文本都是通用历史叙述，不假托具体某年某卷的考试出处，符合项目诚信红线。

**里程碑：人工非选择题从 9 道增加到 21 道，11 个 topic 全部至少覆盖 1 道**（中国近现代史、世界史达到 3 道，其余多数 2 道）。

过程中发现并修复了 2 处因新增内容触发的连带回归：
1. `testDeepExplanationsImproveGeneratedTrainingContent` 原本依赖"k1601 没有人工主观题，所以取到的是生成式主观题（含'背景'/'影响'字样）"这个隐含前提；新增 k1601 人工主观题后该前提被打破，调整了答案句措辞使其同时满足语义准确和测试断言。
2. `testExamPracticeSetsFollowGaokaoRatio` 中两套练（exam_practice_3、exam_practice_6）非选择题总分从 52 掉到 51——根因是世界史新增的 `asq_wh_02` 评分定为 13 分，混进了"世界史按主题兜底"的候选池后，被某些种子轮换选中，与该池其余两条 14 分题形成分值不一致。改成 14 分（与同池其余题目一致）即解决，没有改任何选题逻辑代码。这两处回归本身也说明：往候选池里加新数据时，分值必须和同池同主题的题目保持一致，否则会被现有的轮换选题逻辑随机抽中并破坏分值总和。

`xcodebuild test` 全程保持 38/38 通过。

## 2026-06-23 第十一轮：上线准备包（参照 PolApex 模板）

内容覆盖确认后（112/112 知识点已精修、56/56 S 级点题量达标、148 道人工选择题 + 57 道人工非选择题、6 套套练全部可达），开始正式的上线前准备工作，产出物分两部分：

**仓库内工程修复**：
1. `.gitignore` 删除了 `## Documentation` 下的 `docs/` 排除规则——这条规则会让 `git add docs/` 被静默忽略，GitHub Pages 永远拿不到文件（PolApex 等家族其他 app 早期踩过同一个坑）。已用 `git add --dry-run docs/` 验证修复后能正常识别到 4 个新文件。
2. 新增 `HistApex/PrivacyInfo.xcprivacy`，声明 `NSPrivacyAccessedAPICategoryUserDefaults`，理由码 `1C8F.1`；已确认 Release 构建产物里包含该文件。
3. `PaywallView.swift` 付费墙底部文案接入隐私政策/用户协议可点击链接，指向预期的 GitHub Pages URL（`https://botonwa83-byte.github.io/HistApex/...`）。
4. `project.yml` 新增 `DEVELOPMENT_TEAM: Z7F8BY55DS`——沿用 PolApex 同一开发者账号填写，**未经用户确认这就是 HistApex 实际要用的签名账号**，已在检查清单里显著标注需要用户在 Archive 前自行核实。
5. 新增 `docs/index.html`、`privacy.html`、`terms.html`、`support.html`，历史学科文案原创撰写（不是照抄 PolApex 的政治学科文案）。
6. `xcodegen generate` + `xcodebuild test`（38/38 通过）+ Release 真机目标构建（`-sdk iphoneos -destination generic/platform=iOS CODE_SIGNING_ALLOWED=NO`）均验证通过。

**桌面交付物**：`~/Desktop/HistApex_上线准备/` 下生成 11 个文件（README + 00 总检查清单 + 01-09 各专项文档），结构对齐 `~/Desktop/PolApex_上线准备/`，但所有数字和文案都替换成 HistApex 真实值（28 关/112 知识点/148+57 人工题/6 套套练/¥22/38 测试），不是套壳复制。

**核查中发现并如实记录的一个真实产品口径问题（未擅自处理）**：`ExamPracticeSetView`/`ExamPracticeListView`（6 套高考比例套练）目前代码里没有接 `PurchaseManager.isUnlocked` 判断，对免费用户完全可见可做，但商品描述和付费墙文案把"6 套套练"当核心付费卖点宣传——两者口径不一致。这是产品定价策略决策，已在 `06_内购配置_IAP.md` 和 `05_审核备注_ReviewNotes.md` 里向用户显著标注，等用户决定要不要补付费判断或改文案，没有自行选边修改。

**外部变更观察**：本轮工作过程中，`HistApex/Features/Onboarding/PromoView.swift` 被整体重写（更换为更丰富的品牌开屏页设计，含 glow 动画、开发者信息区等），这不是本轮任何一步操作产生的改动，应为用户在另一侧直接编辑。已重新跑过 `xcodebuild test` 确认该改动不影响其余功能（38/38 通过），未对该文件做任何修改或冲突处理。

我没有执行 git commit / push，也没有修改 App Store Connect 后台。
