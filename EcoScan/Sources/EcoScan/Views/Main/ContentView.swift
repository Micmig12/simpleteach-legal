import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .dashboard
    @Environment(\.horizontalSizeClass) private var sizeClass

    enum Tab: String, CaseIterable {
        case dashboard, scan, history

        var title: String {
            switch self {
            case .dashboard: return "Painel"
            case .scan: return "Escanear"
            case .history: return "Histórico"
            }
        }
        var icon: String {
            switch self {
            case .dashboard: return "chart.bar.fill"
            case .scan: return "camera.viewfinder"
            case .history: return "clock.fill"
            }
        }
    }

    var body: some View {
        ZStack {
            backgroundGradient

            if sizeClass == .regular {
                ipadLayout
            } else {
                iphoneLayout
            }
        }
    }

    // iPad: NavigationSplitView with sidebar
    private var ipadLayout: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            detailView(for: selectedTab)
        }
        .navigationSplitViewStyle(.balanced)
    }

    // iPhone: TabView
    private var iphoneLayout: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                NavigationStack {
                    detailView(for: tab)
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
        .tint(.mint)
    }

    private var sidebar: some View {
        List(Tab.allCases, id: \.self, selection: $selectedTab) { tab in
            Label(tab.title, systemImage: tab.icon)
                .tag(tab)
                .font(.body)
                .padding(.vertical, 4)
        }
        .navigationTitle("EcoScan")
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
        .background(.ultraThinMaterial)
    }

    @ViewBuilder
    private func detailView(for tab: Tab) -> some View {
        ZStack {
            backgroundGradient
            switch tab {
            case .dashboard: DashboardView()
            case .scan: ScanView()
            case .history: HistoryView()
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            stops: [
                .init(color: Color(red: 0.02, green: 0.12, blue: 0.08), location: 0),
                .init(color: Color(red: 0.0, green: 0.06, blue: 0.15), location: 0.5),
                .init(color: Color(red: 0.05, green: 0.0, blue: 0.12), location: 1),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
