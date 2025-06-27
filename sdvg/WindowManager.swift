//
//  WindowManager.swift
//  sdvg
//
//  Created by Nikita Sergeev on 27.06.2025.
//

import AppKit
import SwiftUI

class WindowManager: ObservableObject {
    func setupWindow() {
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                window.level = .floating
                window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            }
        }
    }
}
