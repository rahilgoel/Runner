import SwiftUI

struct GroupsView: View {
    @EnvironmentObject private var store: RunnerStore

    var body: some View {
        NavigationStack {
            List(store.data.groups) { group in
                VStack(alignment: .leading, spacing: 8) {
                    Text(group.name)
                        .font(.headline)
                    Label(group.meetupDay, systemImage: "clock")
                    Label(group.location, systemImage: "mappin.and.ellipse")
                    Label(group.paceRange, systemImage: "speedometer")
                    Text(group.contact)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Local Groups")
        }
    }
}
