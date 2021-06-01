//
//  WebViewController.swift
//  VML Player
//
//  Created by Jordan Carroll on 26/05/2021.
//

import UIKit
import WebKit

public class PlayerEvent: Codable {
    var event: String? // Event Types: PLAYING, PAUSED, ELEMENT_CLICKED, COMPLETE, READY
    var player_time: Float?
    var meta_data: String? // IF Event is ELEMENT_CLICKED, meta_data = the Element ID that was clicked
}

public protocol VMLPlayerDelegate {
    func playerDidPostEvent(event: PlayerEvent)
}

public class VMLPlayerViewController: UIViewController, UIWebViewDelegate {
    
    var playerData: NSMutableDictionary?
    var delegate: VMLPlayerDelegate?
    @IBOutlet weak var webView: WKWebView!
    
    public init(withData data: NSMutableDictionary, delegate: VMLPlayerDelegate) {
        let bundle = Bundle(for: VMLPlayerViewController.self)
        super.init(nibName: "VMLPlayerViewController", bundle: bundle)
        playerData = data
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        UserDefaults.standard.register(defaults: ["UserAgent" : "Chrome Safari"])
        webView.configuration.userContentController.add(self, name: "appCallback")
        webView.scrollView.isScrollEnabled = false
        let bundle = Bundle(for: VMLPlayerViewController.self)
        let url = bundle.url(forResource: "index", withExtension: "html")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
    }
}

extension VMLPlayerViewController : WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let jsonData = try! JSONSerialization.data(withJSONObject: playerData ?? NSMutableDictionary())
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
        self.webView.evaluateJavaScript("frameInit('\(jsonString!)')")
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}

extension VMLPlayerViewController : WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let messageData = message.body as! String
        if message.name == "appCallback" {
            self.handleMessage(data: messageData)
        }
    }
    
    func handleMessage(data: String){
        let jsonData = data.data(using: .utf8)!
        let playerResponseData = try! JSONDecoder().decode(PlayerEvent.self, from: jsonData)
        self.delegate?.playerDidPostEvent(event: playerResponseData)
    }
}
