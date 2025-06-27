//
//  GIFView.swift
//  sdvg
//
//  Created by Nikita Sergeev on 27.06.2025.
//

import SwiftUI
import WebKit

struct GIFView: NSViewRepresentable {
    let gifName: String
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        guard let gifPath = Bundle.main.path(forResource: gifName, ofType: "gif"),
              let gifData = NSData(contentsOfFile: gifPath) else {
            print("GIF не найден: \(gifName).gif")
            return
        }
        
        let html = """
        <html>
        <head>
            <style>
                body {
                    margin: 0;
                    padding: 0;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    background: transparent;
                }
                img {
                    max-width: 100%;
                    max-height: 100%;
                    object-fit: contain;
                }
            </style>
        </head>
        <body>
            <img src="data:image/gif;base64,\(gifData.base64EncodedString())" />
        </body>
        </html>
        """
        
        nsView.loadHTMLString(html, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // GIF загружен
        }
    }
}
