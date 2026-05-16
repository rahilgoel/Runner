import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject private var store: RunnerStore
    @State private var showingAddRun = false

    var body: some View {
        NavigationStack {
            List {
                Section("Overview") {
                    HStack(spacing: 12) {
                        StatCard(title: "This Week", value: store.weeklyMileage.formattedMiles, systemImage: "calendar.badge.clock")
                        StatCard(title: "Total", value: store.totalMileage.formattedMiles, systemImage: "sum")
                    }
                    HStack(spacing: 12) {
                        StatCard(title: "Avg Pace", value: store.averagePace.formattedPace, systemImage: "speedometer")
                        StatCard(title: "Runs", value: "\(store.data.runs.count)", systemImage: "list.bullet")
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)

                Section("Recent Runs") {
                    ForEach(store.data.runs) { run in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(run.distanceMiles.formattedMiles)
                                    .font(.headline)
                                Spacer()
                                Text(run.date, style: .date)
                                    .foregroundStyle(.secondary)
                            }
                            Text("\(run.durationMinutes.formattedMinutes) • \(run.paceMinutesPerMile.formattedPace) • \(run.mood.rawValue)")
                                .font(.subheadline)
                            if !run.notes.isEmpty {
                                Text(run.notes)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Runner Hub")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset Demo") { store.seedSampleData() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAddRun = true } label: {
                        Label("Add Run", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddRun) {
                AddRunView()
                    .environmentObject(store)
            }
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(.orange)
            Text(value)
                .font(.title2.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18))
    }
}

struct AddRunView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: RunnerStore
    @State private var distance = ""
    @State private var duration = ""
    @State private var mood: RunMood = .steady
    @State private var notes = ""

    private var canSave: Bool {
        (Double(distance) ?? 0) > 0 && (Double(duration) ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Run Details") {
                    TextField("Distance in miles", text: $distance)
                        .keyboardType(.decimalPad)
                    TextField("Duration in minutes", text: $duration)
                        .keyboardType(.decimalPad)
                    Picker("Mood", selection: $mood) {
                        ForEach(RunMood.allCases) { mood in
                            Text(mood.rawValue).tag(mood)
                        }
                    }
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Add Run")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.addRun(distanceMiles: Double(distance) ?? 0, durationMinutes: Double(duration) ?? 0, mood: mood, notes: notes)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
