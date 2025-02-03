import SwiftUI
import FamilyControls

@main
struct pocus_appApp: App {
    @StateObject var viewModel = HomeViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: viewModel)
                .onAppear {
                    viewModel.requestScreenTimeAuthorization()
                }
        }
    }
}

