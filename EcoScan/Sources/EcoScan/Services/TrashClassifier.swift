import Vision
import UIKit

struct ClassificationResult {
    let category: RecyclingCategory
    let confidence: Double
    let allLabels: [String]
}

final class TrashClassifier {
    static let shared = TrashClassifier()
    private init() {}

    // Vision label → RecyclingCategory mapping
    private let labelMap: [String: RecyclingCategory] = [
        // Paper
        "paper": .paper, "newspaper": .paper, "cardboard": .paper,
        "book": .paper, "document": .paper, "envelope": .paper,
        "box": .paper, "carton": .paper, "magazine": .paper,
        // Plastic
        "plastic": .plastic, "bottle": .plastic, "bag": .plastic,
        "container": .plastic, "cup": .plastic, "straw": .plastic,
        "packaging": .plastic, "wrapper": .plastic, "film": .plastic,
        // Glass
        "glass": .glass, "jar": .glass, "wine glass": .glass,
        "bottle cap": .glass, "mirror": .glass, "window": .glass,
        // Metal
        "metal": .metal, "can": .metal, "tin": .metal,
        "aluminum": .metal, "steel": .metal, "foil": .metal,
        "scrap": .metal, "iron": .metal, "copper": .metal,
        // Organic
        "food": .organic, "fruit": .organic, "vegetable": .organic,
        "plant": .organic, "leaf": .organic, "wood": .organic,
        "bone": .organic, "coffee": .organic, "compost": .organic,
        // Electronic
        "phone": .electronic, "computer": .electronic, "battery": .electronic,
        "cable": .electronic, "electronic": .electronic, "device": .electronic,
        "charger": .electronic, "keyboard": .electronic, "mouse": .electronic,
    ]

    func classify(image: UIImage) async throws -> ClassificationResult {
        guard let cgImage = image.cgImage else {
            throw ClassifierError.invalidImage
        }

        return try await withCheckedThrowingContinuation { continuation in
            let request = VNClassifyImageRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let observations = (request.results as? [VNClassificationObservation]) ?? []
                let top5Labels = observations.prefix(5).map { $0.identifier }

                let result = self.mapToCategory(observations: observations, labels: top5Labels)
                continuation.resume(returning: result)
            }

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private func mapToCategory(
        observations: [VNClassificationObservation],
        labels: [String]
    ) -> ClassificationResult {
        for observation in observations where observation.confidence > 0.1 {
            let label = observation.identifier.lowercased()
            for (keyword, category) in labelMap {
                if label.contains(keyword) {
                    return ClassificationResult(
                        category: category,
                        confidence: Double(observation.confidence),
                        allLabels: labels
                    )
                }
            }
        }
        // Default to reject if no match found
        return ClassificationResult(
            category: .reject,
            confidence: 0.5,
            allLabels: labels
        )
    }

    enum ClassifierError: Error {
        case invalidImage
    }
}
