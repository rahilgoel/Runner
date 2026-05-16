import SwiftUI

struct TrailsView: View {
    @EnvironmentObject private var store: RunnerStore

    var body: some View {
        NavigationStack {
            List(store.data.trails) { trail in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(trail.name)
                            .font(.headline)
                        Spacer()
                        Text(trail.difficulty)
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(difficultyColor(for: trail.difficulty).opacity(0.18), in: Capsule())
                    }
                    Text("\(trail.distanceMiles.formattedMiles) • \(trail.location)")
                        .font(.subheadline)
                    Text(trail.notes)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Running Trails")
        }
    }

    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "moderate": return .yellow
        default: return .red
        }
    }
}
