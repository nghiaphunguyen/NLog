//
//  NLogDetailViewController.swift
//  NLog
//
//  Created by Nghia Nguyen on 2/18/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit

class NLogDetailViewController: UIViewController {
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.editable = false
        textView.showsHorizontalScrollIndicator = false
        textView.backgroundColor = UIColor.blackColor()
        return textView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("Close", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: #selector(NLogDetailViewController.tappedCloseButton), forControlEvents: .TouchUpInside)
        return button
    }()
    
    lazy var logEntry: NLogEntry? = nil
    
    func tappedCloseButton() {
        if let navigationController = self.navigationController {
            navigationController.popViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
        
        if let logEntry = self.logEntry {
            self.textView.text = logEntry.fullDescWithStackTrace
            self.textView.textColor = UIColor(hex: logEntry.color)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(NLogDetailViewController.tappedSaveButton))
    }
    
    func tappedSaveButton() {
        let logString = self.logEntry?.fullDescWithStackTrace ?? ""
        
        self.presentViewController(NKFeedBackMailViewController().setup(logString), animated: true, completion: nil)
    }
    
    func setUpView() {
        self.view.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(self.closeButton)
        self.closeButton.nk_heightConstraint(40).nk_pinLeadingConstraintView().nk_pinBottomConstraintView().nk_pinTrailingConstraintView()
        
        self.view.addSubview(self.textView)
        self.textView.nk_pinTopConstraintView(offset: StatusBarHeight + self.navigationBarHeight).nk_pinLeadingConstraintView().nk_pinTrailingConstraintView().nk_alignBottomConstraintView(self.closeButton)
    }
    
}