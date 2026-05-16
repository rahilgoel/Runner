import SwiftUI

struct EventsView: View {
    @EnvironmentObject private var store: RunnerStore

    var body: some View {
        NavigationStack {
            List(store.upcomingEvents) { event in
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.name)
                        .font(.headline)
                    Text("\(event.distance) • \(event.location)")
                        .font(.subheadline)
                    Label(event.date.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                        .foregroundStyle(.secondary)
                    if let url = URL(string: event.registrationURL) {
                        Link("Registration", destination: url)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Upcoming Events")
            .overlay {
                if store.upcomingEvents.isEmpty {
                    ContentUnavailableView("No events yet", systemImage: "calendar.badge.plus", description: Text("Add local races and community runs here soon."))
                }
            }
        }
    }
}
