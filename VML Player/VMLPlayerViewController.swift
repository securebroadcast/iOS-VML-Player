//
//  WebViewController.swift
//  VML Player
//
//  Created by Jordan Carroll on 26/05/2021.
//

import UIKit
import WebKit

class PlayerEvent: Codable {
    var event: String?
    var player_time: Float?
    var meta_data: String?
}

protocol VMLPlayerDelegate {
    func playerDidPostEvent(event: PlayerEvent)
}

class VMLPlayerViewController: ViewController, UIWebViewDelegate {
    
    var playerData: NSMutableDictionary?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        UserDefaults.standard.register(defaults: ["UserAgent" : "Chrome Safari"])
        webView.configuration.userContentController.add(self, name: "appCallback")
        let url = Bundle.main.url(forResource: "index", withExtension: "html")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
    }
}

extension VMLPlayerViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let jsonData = try! JSONSerialization.data(withJSONObject: playerData)
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
        self.webView.evaluateJavaScript("frameInit('\(jsonString!)')")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}

extension VMLPlayerViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let messageData = message.body as! String
        if message.name == "appCallback" {
            self.handleMessage(data: messageData)
        }
    }
    
    func handleMessage(data: String){
        let jsonData = data.data(using: .utf8)!
        let playerResponseData = try! JSONDecoder().decode(PlayerEvent.self, from: jsonData)
    }
}

