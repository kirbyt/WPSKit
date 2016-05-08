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
  
  @IBOutlet private var textView: WPSTextView!
  @IBOutlet private var borderedTextView: WPSTextView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    applyTextViewStyle(borderedTextView)
  }

  private func applyTextViewStyle(textView: WPSTextView) {
    textView.backgroundColor = UIColor.whiteColor()
    textView.layer.borderColor = UIColor.blackColor().CGColor
    textView.layer.borderWidth = 5
    textView.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
  }
  
}
