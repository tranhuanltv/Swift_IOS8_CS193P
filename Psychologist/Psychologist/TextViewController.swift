//
//  TextViewController.swift
//  Psycholog
//
//  Created by HuanTran on 11/8/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = text
        }
    }
    
    override var preferredContentSize : CGSize {
        get {
            if textView != nil && presentingViewController != nil {
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            } else {
                return super.preferredContentSize
            }
            
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    var text : String = "" {
        didSet {
            textView?.text = text
        }
    }
}
