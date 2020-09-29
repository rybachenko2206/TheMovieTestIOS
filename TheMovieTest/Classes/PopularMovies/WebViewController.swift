//
//  WebViewController.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 28.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, Storyboardable {
    
    // MARK: - Outlets
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    static var storyboardName: Storyboard { return .main }
    
    var url: URL?

    
    // MARK: - Overriden funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        if let loadURL = url {
            let request = URLRequest(url: loadURL)
            webView.load(request)
        }
    }
    

    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }    

}
