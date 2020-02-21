//
//  WebViewController.swift
//  tingting
//
//  Created by 김선우 on 2/22/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var url = ""
    
    override func loadView() {
        super.loadView()
        let request = URLRequest(url:URL(string: url)!)
        self.webView.load(request)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WebViewController {
    static func initiate(url: String) -> WebViewController {
        
        let vc = WebViewController.withStoryboard(storyboard: .user)
        vc.url = url
        
        return vc
    }
}
