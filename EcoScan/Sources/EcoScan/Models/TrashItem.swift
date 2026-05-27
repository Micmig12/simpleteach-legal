import Foundation
import SwiftData

@Model
final class TrashItem {
    var id: UUID
    var imageData: Data
    var category: RecyclingCategory
    var isRecyclable: Bool
    var weightGrams: Double
    var confidence: Double
    var capturedAt: Date
    var notes: String

    init(
        imageData: Data,
        category: RecyclingCategory,
        confidence: Double = 0.8,
        notes: String = ""
    ) {
        self.id = UUID()
        self.imageData = imageData
        self.category = category
        self.isRecyclable = category.isRecyclable
        self.weightGrams = category.averageWeightGrams
        self.confidence = confidence
        self.capturedAt = Date()
        self.notes = notes
    }

    var weightKg: Double { weightGrams / 1000.0 }
}
