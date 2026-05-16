import SwiftUI

@main
struct RunnerApp: App {
    @StateObject private var store = RunnerStore()

    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(store)
        }
    }
}
