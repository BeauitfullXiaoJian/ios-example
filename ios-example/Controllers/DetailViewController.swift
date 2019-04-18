//
//  DetailViewController.swift
//  ios-example
//
//  Created by  anasit on 2019/4/17.
//  Copyright © 2019  anasit. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mTextView: UILabel!
    var paramsStr:String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mTextView.text = paramsStr
    }
}
