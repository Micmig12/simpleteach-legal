import SwiftUI
import SwiftData

struct AnalysisView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var classificationResult: ClassificationResult?
    @State private var selectedCategory: RecyclingCategory = .reject
    @State private var weightGrams: Double = 100
    @State private var isAnalyzing = true
    @State private var saved = false

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                ScrollView {
                    VStack(spacing: 24) {
                        photoCard
                        if isAnalyzing {
                            analyzingIndicator
                        } else {
                            resultCard
                            weightCard
                            actionButtons
                        }
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Análise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
        }
        .task { await runClassification() }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color(red: 0.05, green: 0.15, blue: 0.1), Color(red: 0.0, green: 0.08, blue: 0.18)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var photoCard: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay {
                if saved {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.mint.opacity(0.3))
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.white)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(duration: 0.4), value: saved)
    }

    private var analyzingIndicator: some View {
        LiquidGlassCard {
            VStack(spacing: 16) {
                ProgressView()
                    .tint(.mint)
                    .scaleEffect(1.5)
                Text("Identificando material...")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }

    private var resultCard: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Material Identificado")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Spacer()
                    if let result = classificationResult {
                        Text(String(format: "%.0f%% confiança", result.confidence * 100))
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }

                Picker("Categoria", selection: $selectedCategory) {
                    ForEach(RecyclingCategory.allCases) { cat in
                        HStack {
                            Image(systemName: cat.icon)
                            Text(cat.localizedName)
                        }
                        .tag(cat)
                    }
                }
                .pickerStyle(.menu)
                .tint(.mint)

                HStack(spacing: 12) {
                    CategoryBadge(category: selectedCategory, size: .large)

                    Spacer()

                    Label(
                        selectedCategory.isRecyclable ? "Reciclável" : "Não Reciclável",
                        systemImage: selectedCategory.isRecyclable ? "checkmark.circle.fill" : "xmark.circle.fill"
                    )
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(selectedCategory.isRecyclable ? .mint : .red)
                }

                if selectedCategory.isRecyclable {
                    Label("Descarte na lixeira \(selectedCategory.binColor)", systemImage: "trash.fill")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
    }

    private var weightCard: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Peso Estimado")
                    .font(.headline)
                    .foregroundStyle(.white)

                HStack {
                    Text(String(format: "%.0f g", weightGrams))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.mint)
                    Text("(≈ \(String(format: "%.3f", weightGrams / 1000)) kg)")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.5))
                }

                Slider(
                    value: $weightGrams,
                    in: 1...5000,
                    step: 10
                )
                .tint(.mint)

                Text("Ajuste o peso conforme necessário")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: saveItem) {
                Label("Salvar Item", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.mint, in: RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(.black)
            }

            Button(action: { dismiss() }) {
                Text("Descartar")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }

    private func runClassification() async {
        isAnalyzing = true
        do {
            let result = try await TrashClassifier.shared.classify(image: image)
            classificationResult = result
            selectedCategory = result.category
            weightGrams = result.category.averageWeightGrams
        } catch {
            selectedCategory = .reject
        }
        withAnimation { isAnalyzing = false }
    }

    private func saveItem() {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let item = TrashItem(
            imageData: data,
            category: selectedCategory,
            confidence: classificationResult?.confidence ?? 0.5
        )
        item.weightGrams = weightGrams
        modelContext.insert(item)

        withAnimation { saved = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { dismiss() }
    }
}
