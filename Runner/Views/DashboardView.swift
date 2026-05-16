import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var store: RunnerStore

    var body: some View {
        TabView {
            ProgressDashboardView()
                .tabItem { Label("Progress", systemImage: "figure.run") }

            EventsView()
                .tabItem { Label("Events", systemImage: "calendar") }

            GroupsView()
                .tabItem { Label("Groups", systemImage: "person.3") }

            TrailsView()
                .tabItem { Label("Trails", systemImage: "map") }

            EquipmentView()
                .tabItem { Label("Gear", systemImage: "shoeprints.fill") }
        }
        .tint(.orange)
    }
}

#Preview {
    DashboardView()
        .environmentObject(RunnerStore())
}
