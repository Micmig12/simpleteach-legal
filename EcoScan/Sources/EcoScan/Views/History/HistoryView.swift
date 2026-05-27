import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \TrashItem.capturedAt, order: .reverse) private var items: [TrashItem]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedFilter: RecyclingCategory? = nil
    @State private var showRecyclableOnly = false

    private let columns = [
        GridItem(.adaptive(minimum: 160, maximum: 220), spacing: 16)
    ]

    private var filteredItems: [TrashItem] {
        items.filter { item in
            if showRecyclableOnly && !item.isRecyclable { return false }
            if let filter = selectedFilter, item.categoryRaw != filter.rawValue { return false }
            return true
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                filterBar

                if filteredItems.isEmpty {
                    emptyState
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredItems) { item in
                            TrashItemCard(item: item)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        modelContext.delete(item)
                                    } label: {
                                        Label("Excluir", systemImage: "trash")
                                    }
                                }
                        }
                    }
                }

                Spacer(minLength: 40)
            }
            .padding(24)
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Histórico")
        .navigationBarTitleDisplayMode(.large)
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                filterChip(label: "Todos", isSelected: selectedFilter == nil && !showRecyclableOnly) {
                    selectedFilter = nil
                    showRecyclableOnly = false
                }
                filterChip(label: "Recicláveis", isSelected: showRecyclableOnly, color: .mint) {
                    showRecyclableOnly.toggle()
                    selectedFilter = nil
                }
                ForEach(RecyclingCategory.allCases) { cat in
                    filterChip(label: cat.localizedName, isSelected: selectedFilter == cat, color: cat.color) {
                        selectedFilter = selectedFilter == cat ? nil : cat
                        showRecyclableOnly = false
                    }
                }
            }
        }
    }

    private func filterChip(label: String, isSelected: Bool, color: Color = .white, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? color.opacity(0.25) : .white.opacity(0.08))
                        .overlay(Capsule().stroke(isSelected ? color.opacity(0.6) : .white.opacity(0.2), lineWidth: 1))
                )
                .foregroundStyle(isSelected ? color : .white.opacity(0.7))
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.2))
            Text("Nenhum item encontrado")
                .font(.title3)
                .foregroundStyle(.white.opacity(0.5))
            Text("Escaneie seu lixo para começar")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.3))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}
