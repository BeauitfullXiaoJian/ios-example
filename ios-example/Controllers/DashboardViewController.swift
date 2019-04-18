//
//  DashboardViewController.swift
//  ios-example
//
//  Created by  anasit on 2019/4/17.
//  Copyright © 2019  anasit. All rights reserved.
//

import UIKit
import WebKit

class DashboardViewController: UIViewController{

    @IBOutlet weak var mWebView: WKWebView!
    @IBOutlet weak var mRefresher: UIActivityIndicatorView!
    @IBOutlet weak var mLoader: UIProgressView!
    var progressAttrName = "estimatedProgress";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWebView();
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if ((object as AnyObject).isEqual(mWebView) && (keyPath! == progressAttrName)) {
            mLoader.progress = Float(mWebView.estimatedProgress);
            mLoader.isHidden = mLoader.progress >= 1;
            mRefresher.isHidden = mLoader.progress >= 0.7;
        }
    }
    
    func initWebView(){
        NSLog("初始化浏览器");
        let url =  URL(string: "https://blog.cool1024.com");
        let request = URLRequest(url: url!);
        mWebView.addObserver(self,
                             forKeyPath: progressAttrName,
                             options: [NSKeyValueObservingOptions.new],
                             context: nil);
        mWebView.load(request);
    }
    
    deinit {
        mWebView.removeObserver(self, forKeyPath: progressAttrName)
    }
}
