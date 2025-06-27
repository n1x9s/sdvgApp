//
//  WindowManager.swift
//  sdvg
//
//  Created by Nikita Sergeev on 27.06.2025.
//

import AppKit
import SwiftUI

class WindowManager: ObservableObject {
    private let positionKey = "WindowPosition"
    
    func setupWindow() {
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                // Настраиваем уровень окна (поверх всех)
                window.level = .floating
                window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
                
                // Позиционируем окно в правом верхнем углу (только при первом запуске)
                if !self.hasStoredPosition() {
                    self.positionWindowTopRight(window)
                } else {
                    self.restoreWindowPosition(window)
                }
                
                // Делаем окно перемещаемым
                window.isMovable = true
                window.isMovableByWindowBackground = true
                
                // Сохраняем позицию при перемещении
                self.setupPositionTracking(window)
            }
        }
    }
    
    private func positionWindowTopRight(_ window: NSWindow) {
        guard let screen = NSScreen.main else { return }
        
        let screenFrame = screen.visibleFrame
        let windowSize = window.frame.size
        
        // Отступы от краев экрана
        let marginRight: CGFloat = 20
        let marginTop: CGFloat = 20
        
        // Вычисляем позицию для правого верхнего угла
        let x = screenFrame.maxX - windowSize.width - marginRight
        let y = screenFrame.maxY - windowSize.height - marginTop
        
        // Устанавливаем новую позицию окна
        let newOrigin = NSPoint(x: x, y: y)
        window.setFrameOrigin(newOrigin)
        
        // Сохраняем позицию
        saveWindowPosition(newOrigin)
    }
    
    private func hasStoredPosition() -> Bool {
        return UserDefaults.standard.object(forKey: positionKey) != nil
    }
    
    private func restoreWindowPosition(_ window: NSWindow) {
        guard let positionData = UserDefaults.standard.data(forKey: positionKey),
              let position = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSValue.self, from: positionData) else {
            positionWindowTopRight(window)
            return
        }
        
        let point = position.pointValue
        window.setFrameOrigin(point)
    }
    
    private func saveWindowPosition(_ position: NSPoint) {
        let positionValue = NSValue(point: position)
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: positionValue, requiringSecureCoding: true) {
            UserDefaults.standard.set(data, forKey: positionKey)
        }
    }
    
    private func setupPositionTracking(_ window: NSWindow) {
        // Отслеживаем перемещения окна
        NotificationCenter.default.addObserver(
            forName: NSWindow.didMoveNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            self?.saveWindowPosition(window.frame.origin)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Публичный метод для сброса позиции окна
    func resetWindowToTopRight(_ window: NSWindow) {
        positionWindowTopRight(window)
    }
}
