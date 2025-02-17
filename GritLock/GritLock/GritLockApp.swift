//
//  GritLockApp.swift
//  GritLock
//
//  Created by Jessica Morcos  on 2025-02-17.
//

import SwiftUI
import FamilyControls

@main
struct GritLockApp: App {
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
