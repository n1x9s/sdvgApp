//
//  sdvgApp.swift
//  sdvg
//
//  Created by Nikita Sergeev on 27.06.2025.
//

import SwiftUI

@main
struct sdvgApp: App {
    @StateObject private var windowManager = WindowManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color.clear)
                .onAppear {
                    windowManager.setupWindow()
                }
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 300, height: 370)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact)
    }
}
