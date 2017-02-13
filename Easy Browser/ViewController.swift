//
//  ViewController.swift
//  Easy Browser
//
//  Created by Akbar Mirza on 2/10/17.
//  Copyright © 2017 Akbar Mirza. All rights reserved.
//

import UIKit
import WebKit // for WKWebView

class ViewController: UIViewController {
    
    // Properties
    // create a WebView
    var webView: WKWebView!
    // create a ProgressView
    var progressView: UIProgressView!
    // create an array of safe websites to load
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() {
        // initialize our web view
        webView = WKWebView()
        // set the navigation delegate for our webView
        webView.navigationDelegate = self
        // set our root view to webView
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // creating a BarButtonItem that creates a flexible space (it can't be tapped)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // create a new ProgressView with the default style
        progressView = UIProgressView(progressViewStyle: .default)
        // set the size of our progressView to fit the size of the content
        progressView.sizeToFit()
        // create a new BarButtonItem using the customView parameter
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // creating a refresh button that calls the reload() method on our webView
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // setting our view controller's toolbar items to 
        // an array containing the flexible space and refresh button
        toolbarItems = [progressButton, spacer, refresh]
        // show the toolbar
        navigationController?.isToolbarHidden = false
        
        // create a new url
        let url = URL(string: "https://" + websites[0])!
        // create a new URLRequest for that url and load it in webview
        webView.load(URLRequest(url: url))
        // allows users to swipe to move back and forward in browser
        webView.allowsBackForwardNavigationGestures = true
        // add ourselves as an observer on the estimatedProgress property
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func openTapped() {
        let ac = UIAlertController(title: "Open page_", message: nil, preferredStyle: .actionSheet)
        
        // add our safe websites as actions
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // if our estimatedProgress property has changed
        if keyPath == "estimatedProgress" {
            // update our progressView to reflect the change
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        // setting url to the URL of the navigation
        let url = navigationAction.request.url
        
        // unwrap the value of url.host
        if let host = url!.host {
            // iterate through our list of websites
            for website in websites {
                // check if each safe website exists somewhere in the host name
                if host.range(of: website) != nil {
                    // if it exists, allow the decisionhandler to load
                    decisionHandler(.allow)
                    // use return statement to exit method
                    return
                }
            }
        }
        
        // if there is no host set, cancel loading of decisionHandler
        decisionHandler(.cancel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: WKNavigationDelegate {
    
}
