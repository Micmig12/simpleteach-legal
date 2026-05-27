import SwiftData
import Foundation

@Model
final class TrashItem {
    var id: UUID
    var imageData: Data
    // SwiftData requer propriedade scalar; category é calculada em cima de categoryRaw
    var categoryRaw: String
    var weightGrams: Double
    var confidence: Double
    var notes: String
    var capturedAt: Date

    init(
        imageData: Data,
        category: RecyclingCategory,
        weightGrams: Double? = nil,
        confidence: Double = 0.8,
        notes: String = ""
    ) {
        self.id = UUID()
        self.imageData = imageData
        self.categoryRaw = category.rawValue
        self.weightGrams = weightGrams ?? category.averageWeightGrams
        self.confidence = confidence
        self.notes = notes
        self.capturedAt = Date()
    }

    var category: RecyclingCategory {
        get { RecyclingCategory(rawValue: categoryRaw) ?? .reject }
        set { categoryRaw = newValue.rawValue }
    }

    var isRecyclable: Bool { category.isRecyclable }
    var weightKg: Double { weightGrams / 1000.0 }
}
