//
//  SimpleGIFView.swift
//  sdvg
//
//  Created by Nikita Sergeev on 27.06.2025.
//

import SwiftUI
import AppKit

struct SimpleGIFView: NSViewRepresentable {
    let gifName: String
    
    func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.animates = true
        return imageView
    }
    
    func updateNSView(_ nsView: NSImageView, context: Context) {
        if let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif"),
           let image = NSImage(contentsOfFile: gifPath) {
            nsView.image = image
        } else {
            // Если GIF не найден, создаем простую анимацию
            createDemoAnimation(for: nsView)
        }
    }
    
    private func createDemoAnimation(for imageView: NSImageView) {
        // Создаем простую демо-анимацию с цветными кругами
        let size = CGSize(width: 200, height: 200)
        let colors: [NSColor] = [.red, .green, .blue, .yellow, .purple]
        var images: [NSImage] = []
        
        for (index, color) in colors.enumerated() {
            let image = NSImage(size: size)
            image.lockFocus()
            
            // Очищаем фон
            NSColor.clear.set()
            NSRect(origin: .zero, size: size).fill()
            
            // Рисуем цветной круг
            let radius: CGFloat = 50 + CGFloat(index * 10)
            let rect = NSRect(
                x: size.width/2 - radius,
                y: size.height/2 - radius,
                width: radius * 2,
                height: radius * 2
            )
            
            color.set()
            NSBezierPath(ovalIn: rect).fill()
            
            image.unlockFocus()
            images.append(image)
        }
        
        // Создаем анимированное изображение
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
}
