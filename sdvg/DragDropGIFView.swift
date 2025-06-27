//
//  DragDropGIFView.swift
//  sdvg
//
//  Created by Nikita Sergeev on 27.06.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct DragDropGIFView: View {
    @State private var gifData: Data?
    @State private var isHovering = false
    
    var body: some View {
        VStack {
            if let gifData = gifData {
                GIFDisplayView(gifData: gifData)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                    
                    Text("Перетащите GIF сюда")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("или нажмите для выбора файла")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 2, dash: [8])
                        )
                        .foregroundColor(isHovering ? .blue : .secondary)
                )
                .scaleEffect(isHovering ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isHovering)
                .onTapGesture {
                    selectGIFFile()
                }
            }
        }
        .onDrop(of: [UTType.gif], isTargeted: $isHovering) { providers in
            handleDrop(providers: providers)
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        guard let provider = providers.first else { return false }
        
        provider.loadDataRepresentation(forTypeIdentifier: UTType.gif.identifier) { data, error in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    self.gifData = data
                }
            }
        }
        return true
    }
    
    private func selectGIFFile() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType.gif]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                let data = try Data(contentsOf: url)
                self.gifData = data
            } catch {
                print("Ошибка загрузки файла: \(error)")
            }
        }
    }
}

struct GIFDisplayView: NSViewRepresentable {
    let gifData: Data
    
    func makeNSView(context: Context) -> NSImageView {
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.animates = true
        return imageView
    }
    
    func updateNSView(_ nsView: NSImageView, context: Context) {
        if let image = NSImage(data: gifData) {
            nsView.image = image
        }
    }
}
