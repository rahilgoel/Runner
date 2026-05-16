import Foundation

enum RunMood: String, CaseIterable, Codable, Identifiable {
    case strong = "Strong"
    case steady = "Steady"
    case tired = "Tired"
    case recovery = "Recovery"

    var id: String { rawValue }
}

struct RunLog: Identifiable, Codable, Equatable {
    var id = UUID()
    var date: Date
    var distanceMiles: Double
    var durationMinutes: Double
    var mood: RunMood
    var notes: String

    var paceMinutesPerMile: Double {
        guard distanceMiles > 0 else { return 0 }
        return durationMinutes / distanceMiles
    }
}

struct RunningEvent: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var date: Date
    var distance: String
    var location: String
    var registrationURL: String
}

struct RunningGroup: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var meetupDay: String
    var location: String
    var paceRange: String
    var contact: String
}

struct Trail: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var distanceMiles: Double
    var difficulty: String
    var location: String
    var notes: String
}

struct EquipmentItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var category: String
    var purchaseDate: Date
    var mileage: Double
    var replacementMileage: Double

    var remainingMiles: Double {
        max(replacementMileage - mileage, 0)
    }
}

struct RunnerData: Codable, Equatable {
    var runs: [RunLog]
    var events: [RunningEvent]
    var groups: [RunningGroup]
    var trails: [Trail]
    var equipment: [EquipmentItem]

    static let empty = RunnerData(runs: [], events: [], groups: [], trails: [], equipment: [])
}
