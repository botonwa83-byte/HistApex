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

下一轮待办（未在本轮展开）：

- 付费 A 级知识点剩余约 25 个（56 个 A 点中已精修 31 个：5 个历史遗留 + 本轮未涉及 A 点；需要重新核对具体清单）仍是模板内容。
- 免费层（初中节点1-9，18 个 S 点 + 对应 A 点）全部还是模板内容，本轮按优先级决策推后。
- 选择性必修结构性扩容（国家制度/经济与社会/文化交流各从 1 个节点拆到 2-3 个节点）未做，需要单独评估对 28 关总数、免费/付费边界、Boss 映射等下游代码的影响。
- App Store 上架还缺隐私政策/服务条款/支持页文档（repo 内未发现 `docs/` 目录）。
