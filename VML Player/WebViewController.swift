//
//  WebViewController.swift
//  VML Player
//
//  Created by Jordan Carroll on 26/05/2021.
//

import UIKit
import WebKit

class WebViewController: ViewController, UIWebViewDelegate {
    var name = ""
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        let contentController = WKUserContentController()
        contentController.add(self, name: "postToiOS")
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.userContentController = contentController
        self.webView = WKWebView( frame: self.view.bounds, configuration: config)
        self.view.addSubview(self.webView)
    }
    
    override func viewDidLoad() {
        let url = Bundle.main.url(forResource: "index", withExtension: "html")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
    }
}

extension WebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let dataObject: NSMutableDictionary = NSMutableDictionary()
        dataObject.setValue("bd701550-4076-11eb-8207-c1d8512464a1", forKey: "vml_id")
        dataObject.setValue(self.name, forKey: "name")
        let jsonData = try! JSONSerialization.data(withJSONObject: dataObject)
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
        self.webView.evaluateJavaScript("frameInit('\(jsonString!)')")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}

extension WebViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let callBackString = message.body as! String
        if message.name == "postToiOS" {
            self.sumbitToiOS(callback: callBackString)
        }
    }
    
    func sumbitToiOS(callback: String){
        //refresh token
        print("postToiOS")
    }
}
