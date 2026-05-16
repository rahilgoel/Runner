import SwiftUI

struct EquipmentView: View {
    @EnvironmentObject private var store: RunnerStore

    var body: some View {
        NavigationStack {
            List(store.data.equipment) { item in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.category)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(item.remainingMiles.formattedMiles)
                            .font(.callout.bold())
                            .foregroundStyle(item.remainingMiles < 50 ? .red : .primary)
                    }
                    ProgressView(value: min(item.mileage / item.replacementMileage, 1))
                        .tint(item.remainingMiles < 50 ? .red : .orange)
                    Text("\(item.mileage.formattedMiles) logged of \(item.replacementMileage.formattedMiles) replacement target")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text("Purchased \(item.purchaseDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Equipment")
        }
    }
}
