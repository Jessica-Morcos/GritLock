//
//  AppDelegate.swift
//  GritLock
//
//  Created by Jessica Morcos  on 2025-02-17.
//


import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var orientationLock: UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }
}