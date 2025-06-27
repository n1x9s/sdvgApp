//
//  ContentView.swift
//  sdvg
//
//  Created by Nikita Sergeev on 27.06.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showDragDrop = false // Изменим по умолчанию на false, чтобы сразу показывать GIF
    @State private var alwaysOnTop = true
    @State private var currentGifName = "gif" // По умолчанию показываем gif.gif
    @StateObject private var windowManager = WindowManager()
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("GIF Player")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if !showDragDrop {
                        Text(currentGifName == "gif" ? "📁 gif.gif" : "🎨 Демо")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    resetToTopRight()
                }) {
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help("Переместить в правый верхний угол")
                
                Button(action: {
                    alwaysOnTop.toggle()
                    toggleAlwaysOnTop(alwaysOnTop)
                }) {
                    Image(systemName: alwaysOnTop ? "pin.fill" : "pin")
                        .foregroundColor(alwaysOnTop ? .blue : .secondary)
                }
                .buttonStyle(.plain)
                .help(alwaysOnTop ? "Отключить поверх всех окон" : "Включить поверх всех окон")
                
                Button(action: {
                    NSApplication.shared.terminate(nil)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
                .help("Закрыть")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(NSColor.controlBackgroundColor))
            
            // Основная область
            Group {
                if showDragDrop {
                    DragDropGIFView()
                } else {
                    AutoGIFView(gifName: currentGifName)
                        .background(Color.black.opacity(0.05))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(8)
            .padding(8)
            
            // Нижняя панель
            HStack {
                if showDragDrop {
                    Button("Автогифка") {
                        showDragDrop = false
                        currentGifName = "gif"
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                } else {
                    HStack(spacing: 4) {
                        Button("Демо") {
                            currentGifName = "demo"
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        
                        Button("Загрузить") {
                            showDragDrop = true
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
                
                Spacer()
                
                Text("v1.0")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(width: 300, height: 370)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 10)
        .onAppear {
            // Устанавливаем окно поверх всех при запуске
            toggleAlwaysOnTop(alwaysOnTop)
            
            // Проверяем, есть ли gif.gif файл
            checkForAutoGIF()
        }
    }
    
    private func toggleAlwaysOnTop(_ enabled: Bool) {
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                window.level = enabled ? .floating : .normal
                window.collectionBehavior = enabled ? 
                    [.canJoinAllSpaces, .fullScreenAuxiliary] : 
                    [.canJoinAllSpaces]
                    
                // Сохраняем возможность перемещения окна
                window.isMovable = true
                window.isMovableByWindowBackground = true
            }
        }
    }
    
    private func checkForAutoGIF() {
        // Проверяем наличие gif.gif в Bundle
        if Bundle.main.path(forResource: "gif", ofType: "gif") != nil {
            currentGifName = "gif"
            showDragDrop = false
            return
        }
        
        // Проверяем в корне проекта (для разработки)
        let projectRoot = findProjectRoot()
        let gifPath = projectRoot + "/gif.gif"
        
        if FileManager.default.fileExists(atPath: gifPath) {
            currentGifName = "gif"
            showDragDrop = false
        }
    }
    
    private func findProjectRoot() -> String {
        var currentPath = FileManager.default.currentDirectoryPath
        
        while currentPath != "/" {
            let projectFiles = try? FileManager.default.contentsOfDirectory(atPath: currentPath)
            if projectFiles?.contains(where: { $0.hasSuffix(".xcodeproj") }) == true {
                return currentPath
            }
            currentPath = (currentPath as NSString).deletingLastPathComponent
        }
        
        return FileManager.default.currentDirectoryPath
    }
    
    private func resetToTopRight() {
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                windowManager.resetWindowToTopRight(window)
            }
        }
    }
}

#Preview {
    ContentView()
}
