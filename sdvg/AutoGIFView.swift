//
//  AutoGIFView.swift
//  sdvg
//
//  Created by Nikita Sergeev on 27.06.2025.
//

import SwiftUI
import AppKit

struct AutoGIFView: NSViewRepresentable {
    let gifName: String
    @State private var fileMonitor: DispatchSourceFileSystemObject?
    
    func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.animates = true
        return imageView
    }
    
    func updateNSView(_ nsView: NSImageView, context: Context) {
        loadGIF(into: nsView)
        setupFileMonitoring(for: nsView, context: context)
    }
    
    private func loadGIF(into imageView: NSImageView) {
        // Сначала пробуем загрузить из Bundle
        if let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif"),
           let image = NSImage(contentsOfFile: gifPath) {
            DispatchQueue.main.async {
                imageView.image = image
            }
            return
        }
        
        // Если в Bundle нет, пробуем загрузить из корня проекта (для разработки)
        let projectRoot = findProjectRoot()
        let gifPath = projectRoot + "/\(gifName).gif"
        
        if FileManager.default.fileExists(atPath: gifPath),
           let image = NSImage(contentsOfFile: gifPath) {
            DispatchQueue.main.async {
                imageView.image = image
            }
            return
        }
        
        // Если ничего не найдено, показываем демо
        DispatchQueue.main.async {
            createDemoAnimation(for: imageView)
        }
    }
    
    private func setupFileMonitoring(for imageView: NSImageView, context: Context) {
        let projectRoot = findProjectRoot()
        let gifPath = projectRoot + "/\(gifName).gif"
        
        guard FileManager.default.fileExists(atPath: gifPath) else { return }
        
        let fileDescriptor = open(gifPath, O_EVTONLY)
        guard fileDescriptor >= 0 else { return }
        
        fileMonitor = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: .write,
            queue: DispatchQueue.global(qos: .background)
        )
        
        fileMonitor?.setEventHandler { [weak imageView] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard let imageView = imageView else { return }
                if let newImage = NSImage(contentsOfFile: gifPath) {
                    imageView.image = newImage
                }
            }
        }
        
        fileMonitor?.resume()
    }
    
    private func findProjectRoot() -> String {
        var currentPath = FileManager.default.currentDirectoryPath
        
        // Ищем папку, содержащую .xcodeproj
        while currentPath != "/" {
            let projectFiles = try? FileManager.default.contentsOfDirectory(atPath: currentPath)
            if projectFiles?.contains(where: { $0.hasSuffix(".xcodeproj") }) == true {
                return currentPath
            }
            currentPath = (currentPath as NSString).deletingLastPathComponent
        }
        
        // Если не нашли, возвращаем текущую папку
        return FileManager.default.currentDirectoryPath
    }
    
    private func createDemoAnimation(for imageView: NSImageView) {
        let size = CGSize(width: 200, height: 200)
        let colors: [NSColor] = [.systemBlue, .systemGreen, .systemOrange, .systemPurple, .systemRed]
        var images: [NSImage] = []
        
        for (index, color) in colors.enumerated() {
            let image = NSImage(size: size)
            image.lockFocus()
            
            NSColor.clear.set()
            NSRect(origin: .zero, size: size).fill()
            
            let radius: CGFloat = 40 + CGFloat(index * 8)
            let rect = NSRect(
                x: size.width/2 - radius,
                y: size.height/2 - radius,
                width: radius * 2,
                height: radius * 2
            )
            
            color.set()
            NSBezierPath(ovalIn: rect).fill()
            
            // Добавляем текст с информацией
            let text = "Нет gif.gif"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 12),
                .foregroundColor: NSColor.white
            ]
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            let textRect = NSRect(x: size.width/2 - 30, y: size.height/2 - 6, width: 60, height: 12)
            attributedString.draw(in: textRect)
            
            image.unlockFocus()
            images.append(image)
        }
        
        if !images.isEmpty {
            let animatedImage = NSImage(size: size)
            for image in images {
                if let representation = image.representations.first {
                    animatedImage.addRepresentation(representation)
                }
            }
            imageView.image = animatedImage
        }
    }
    
    static func dismantleNSView(_ nsView: NSImageView, coordinator: ()) {
        // Очистка ресурсов при удалении view
    }
}
