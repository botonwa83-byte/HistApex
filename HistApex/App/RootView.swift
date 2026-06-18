import SwiftUI

struct RootView: View {
    @State private var passedPromo: Bool = {
        let args = ProcessInfo.processInfo.arguments
        return args.contains("-skipPromo") || args.contains { $0.hasPrefix("-demo") }
    }()

    var body: some View {
        ZStack {
            if passedPromo {
                MainTabView()
                    .transition(.opacity)
            } else {
                PromoView {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        passedPromo = true
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.35), value: passedPromo)
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            AscentPathView()
                .tabItem { Label("登顶之路", systemImage: "map") }
                .tag(0)

            TrainingView()
                .tabItem { Label("历史训练", systemImage: "text.append") }
                .tag(1)

            ConceptGraphView()
                .tabItem { Label("概念星图", systemImage: "network") }
                .tag(2)

            MoreView()
                .tabItem { Label("更多", systemImage: "ellipsis.circle") }
                .tag(3)
        }
        .tint(.apexLava)
    }
}
