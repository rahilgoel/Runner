import Combine
import Foundation

@MainActor
final class RunnerStore: ObservableObject {
    @Published private(set) var data: RunnerData

    private let fileURL: URL
    private let calendar = Calendar.current

    init(fileURL: URL? = nil) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        self.fileURL = fileURL ?? documentsDirectory!.appendingPathComponent("runner-data.json")
        self.data = RunnerData.empty
        load()
    }

    var upcomingEvents: [RunningEvent] {
        let startOfToday = calendar.startOfDay(for: Date())
        return data.events
            .filter { $0.date >= startOfToday }
            .sorted { $0.date < $1.date }
    }

    var weeklyMileage: Double {
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return data.runs
            .filter { $0.date >= startOfWeek }
            .reduce(0) { $0 + $1.distanceMiles }
    }

    var totalMileage: Double {
        data.runs.reduce(0) { $0 + $1.distanceMiles }
    }

    var averagePace: Double {
        let totalDistance = data.runs.reduce(0) { $0 + $1.distanceMiles }
        let totalDuration = data.runs.reduce(0) { $0 + $1.durationMinutes }
        guard totalDistance > 0 else { return 0 }
        return totalDuration / totalDistance
    }

    func addRun(distanceMiles: Double, durationMinutes: Double, mood: RunMood, notes: String) {
        let run = RunLog(date: Date(), distanceMiles: distanceMiles, durationMinutes: durationMinutes, mood: mood, notes: notes)
        data.runs.insert(run, at: 0)
        data.equipment = data.equipment.map { item in
            var updated = item
            if item.category.localizedCaseInsensitiveContains("shoe") {
                updated.mileage += distanceMiles
            }
            return updated
        }
        save()
    }

    func seedSampleData() {
        data = RunnerData.sample
        save()
    }

    func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            data = RunnerData.sample
            save()
            return
        }

        do {
            let fileData = try Data(contentsOf: fileURL)
            data = try JSONDecoder.runnerDecoder.decode(RunnerData.self, from: fileData)
        } catch {
            data = RunnerData.sample
        }
    }

    func save() {
        do {
            let encoded = try JSONEncoder.runnerEncoder.encode(data)
            try encoded.write(to: fileURL, options: [.atomic])
        } catch {
            assertionFailure("Unable to save runner data: \(error.localizedDescription)")
        }
    }
}

private extension JSONEncoder {
    static var runnerEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}

private extension JSONDecoder {
    static var runnerDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

extension RunnerData {
    static var sample: RunnerData {
        let calendar = Calendar.current
        return RunnerData(
            runs: [
                RunLog(date: calendar.date(byAdding: .day, value: -1, to: Date())!, distanceMiles: 4.2, durationMinutes: 38, mood: .steady, notes: "Neighborhood loop with strides."),
                RunLog(date: calendar.date(byAdding: .day, value: -3, to: Date())!, distanceMiles: 6.0, durationMinutes: 55, mood: .strong, notes: "Felt smooth on the last mile."),
                RunLog(date: calendar.date(byAdding: .day, value: -6, to: Date())!, distanceMiles: 3.1, durationMinutes: 30, mood: .recovery, notes: "Easy shakeout run.")
            ],
            events: [
                RunningEvent(name: "Spring 10K Tune-Up", date: calendar.date(byAdding: .day, value: 14, to: Date())!, distance: "10K", location: "City Park", registrationURL: "https://example.com/spring-10k"),
                RunningEvent(name: "Downtown Half Marathon", date: calendar.date(byAdding: .day, value: 45, to: Date())!, distance: "13.1 mi", location: "Downtown", registrationURL: "https://example.com/half")
            ],
            groups: [
                RunningGroup(name: "Sunrise Striders", meetupDay: "Tuesdays 6:15 AM", location: "Riverfront Path", paceRange: "8:00-10:30 /mi", contact: "@sunrisestriders"),
                RunningGroup(name: "Weekend Long Run Crew", meetupDay: "Saturdays 7:00 AM", location: "Main Coffee", paceRange: "9:00-12:00 /mi", contact: "crew@example.com")
            ],
            trails: [
                Trail(name: "Lake Loop", distanceMiles: 5.4, difficulty: "Easy", location: "North Lake", notes: "Flat gravel path with water fountains."),
                Trail(name: "Ridge Climb", distanceMiles: 7.8, difficulty: "Hard", location: "West Ridge", notes: "Great hill workout and shaded switchbacks.")
            ],
            equipment: [
                EquipmentItem(name: "Daily Trainer Shoes", category: "Shoes", purchaseDate: calendar.date(byAdding: .month, value: -2, to: Date())!, mileage: 126, replacementMileage: 400),
                EquipmentItem(name: "Hydration Vest", category: "Gear", purchaseDate: calendar.date(byAdding: .month, value: -8, to: Date())!, mileage: 0, replacementMileage: 1_000)
            ]
        )
    }
}
