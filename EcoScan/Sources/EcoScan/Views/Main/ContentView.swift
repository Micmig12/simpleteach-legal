import SwiftUI

enum SidebarItem: String, CaseIterable, Hashable {
    case dashboard, scan, history

    var title: String {
        switch self {
        case .dashboard: return "Painel"
        case .scan:      return "Escanear"
        case .history:   return "Histórico"
        }
    }
    var icon: String {
        switch self {
        case .dashboard: return "chart.pie.fill"
        case .scan:      return "camera.viewfinder"
        case .history:   return "clock.fill"
        }
    }
}

struct ContentView: View {
    @State private var selection: SidebarItem? = .dashboard
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ZStack {
            EcoMeshBackground()

            if sizeClass == .regular {
                ipadLayout
            } else {
                iphoneLayout
            }
        }
    }

    // iPad: NavigationSplitView com sidebar
    private var ipadLayout: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, id: \.self, selection: $selection) { item in
                Label(item.title, systemImage: item.icon)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.vertical, 6)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .background(.ultraThinMaterial)
            .navigationTitle("EcoScan")
        } detail: {
            detailView(for: selection ?? .dashboard)
        }
        .navigationSplitViewStyle(.balanced)
    }

    // iPhone: TabView
    private var iphoneLayout: some View {
        TabView(selection: $selection) {
            ForEach(SidebarItem.allCases, id: \.self) { item in
                NavigationStack {
                    detailView(for: item)
                }
                .tabItem { Label(item.title, systemImage: item.icon) }
                .tag(item as SidebarItem?)
            }
        }
        .tint(.mint)
    }

    @ViewBuilder
    private func detailView(for item: SidebarItem) -> some View {
        switch item {
        case .dashboard: DashboardView()
        case .scan:      ScanView()
        case .history:   HistoryView()
        }
    }
}

#Preview {
    ContentView()
}
