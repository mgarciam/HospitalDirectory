//
//  PreRegisterViewController.swift
//  Bene
//
//  Created by Marilyn García on 8/1/16.
//  Copyright © 2016 davidmar. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class PreRegisterViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        loadWebView()
    }
 
    @IBAction func refreshWebView(sender: AnyObject) {
        loadWebView()
    }
    
    func loadWebView() {
        let url = NSURL(string: "http://www.benehospital.com.mx/index.php/pre-admision")
        webView.loadRequest(NSURLRequest(URL: url!))
    }
}
