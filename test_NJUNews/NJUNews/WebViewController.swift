//
//  WebViewController.swift
//  NJUNews
//
//  Created by AIBN on 2020/12/28.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    let webView = WKWebView()
    var news : TeachingNews?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = webView
        // Do any additional setup after loading the view.
        
        if let news = news{
            let text = "https://jw.nju.edu.cn" + news.href
            if let url = URL(string: text){
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
}
