//
//  Utility.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 9/10/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let url = URL(string: urlString) else { return }
        uiView.load(URLRequest(url: url))
    }
    
}
