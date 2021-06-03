//
//  WebViewController.swift
//  VML Player
//
//  Created by Jordan Carroll on 26/05/2021.
//

import UIKit
import WebKit

public enum EventType: String {
    case playing = "PLAYING"
    case paused = "PAUSED"
    case element_clicked = "ELEMENT_CLICKED"
    case completed = "COMPLETE"
    case ready = "READY"
}

public class PlayerEvent: Decodable {
    public var event: String? // Event Types: PLAYING, PAUSED, ELEMENT_CLICKED, COMPLETE, READY
    public var player_time: Float?
    public var meta_data: String? // IF Event is ELEMENT_CLICKED, meta_data = the Element ID that was clicked
}

public struct PlayerControls: Encodable {
    
    var autoplay: Bool
    var autoloop: Bool
    var showPlayerControls: Bool
    
    public init(autoplay: Bool, autoloop: Bool, showPlayerControls: Bool) {
        self.autoplay = autoplay
        self.autoloop = autoloop
        self.showPlayerControls = showPlayerControls
    }
}

public protocol VMLPlayerDelegate {
    func playerDidPostEvent(event: PlayerEvent)
}

public class VMLPlayerViewController: UIViewController, UIWebViewDelegate {
    
    var playerData: NSMutableDictionary?
    var playerControls: PlayerControls = PlayerControls(autoplay: false, autoloop: false, showPlayerControls: false)
    var delegate: VMLPlayerDelegate?
    var webView: WKWebView!
    
    public init(withData data: NSMutableDictionary, delegate: VMLPlayerDelegate, playerControls: PlayerControls?) {
        let bundle = Bundle(for: VMLPlayerViewController.self)
        super.init(nibName: "VMLPlayerViewController", bundle: bundle)
        playerData = data
        self.delegate = delegate
        
        if let controls = playerControls {
            self.playerControls = controls
        }
        
        setupPlayerView()
    }
    
    public func setupPlayerView() {
        
        UserDefaults.standard.register(defaults: ["UserAgent" : "Chrome Safari"])
        
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.userContentController.removeScriptMessageHandler(forName: "appCallback")
        configuration.userContentController.add(self, name: "appCallback")
        configuration.userContentController.addUserScript(self.getZoomDisableScript())
        
        let bundle = Bundle(for: VMLPlayerViewController.self)
        let url = bundle.url(forResource: "index", withExtension: "html")!
        let request = URLRequest(url: url)
        
        webView = WKWebView(frame: CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height), configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.loadFileURL(url, allowingReadAccessTo: url)
        webView.navigationDelegate = self
        webView.load(request)        
    }
    
    private func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        self.view.addSubview(webView)
        setupWKWebViewConstraints()
    }
    
    func setupWKWebViewConstraints() {
        let paddingConstant:CGFloat = 0
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: paddingConstant).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -paddingConstant).isActive = true
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: paddingConstant).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -paddingConstant).isActive = true
    }
    
    public func play() {
        self.webView.evaluateJavaScript("playVideo()")
    }
    
    public func pause() {
        self.webView.evaluateJavaScript("pauseVideo()")        
    }
}

extension VMLPlayerViewController : WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let jsonData = try! JSONSerialization.data(withJSONObject: playerData ?? NSMutableDictionary())
        let playerDataString = String(data: jsonData, encoding: String.Encoding.utf8)
        let playerControls = try! JSONEncoder().encode(playerControls)
        let jsonPlayerControls = String(data: playerControls, encoding: String.Encoding.utf8)

        self.webView.evaluateJavaScript("frameInit('\(playerDataString!)', '\(jsonPlayerControls!)')")
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


