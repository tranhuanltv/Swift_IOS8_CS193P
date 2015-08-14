//
//  ViewController.swift
//  Calculate
//
//  Created by HuanTran on 6/12/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    
    var userIsInMiddleOfTyping = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        println("digit = \(digit)")
        
        if (userIsInMiddleOfTyping) {
            display.text = display.text! + digit
        } else {
            userIsInMiddleOfTyping = true
            display.text = digit
        }
    }
 
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if (userIsInMiddleOfTyping) {
            enter()
        }

        if let result = brain.performOperation(operation) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    
    var brain = CalculatorBrain()
    
    @IBAction func enter() {
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        
    }
    
    var displayValue : Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue;
        }
        set {
            display.text  = "\(newValue)"
            userIsInMiddleOfTyping = false
        }
    }
}

