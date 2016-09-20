//
//  WPSTextViewController.swift
//  WPSKit
//
//  Created by Kirby Turner on 5/8/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import UIKit
import WPSKit

class WPSTextViewController: UIViewController {
  
  @IBOutlet fileprivate var textView: WPSTextView!
  @IBOutlet fileprivate var borderedTextView: WPSTextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    applyTextViewStyle(borderedTextView)
  }

  fileprivate func applyTextViewStyle(_ textView: WPSTextView) {
    textView.backgroundColor = UIColor.white
    textView.layer.borderColor = UIColor.black.cgColor
    textView.layer.borderWidth = 5
    textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
  }
  
}
