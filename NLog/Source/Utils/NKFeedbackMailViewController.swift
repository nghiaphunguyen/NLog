//
//  LogMailViewController.swift
//  KnackerTemplate
//
//  Created by Nghia Nguyen on 2/13/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import MessageUI
import UIKit

public class NKFeedBackMailViewController: MFMailComposeViewController, MFMailComposeViewControllerDelegate {
    
    public static var userEmail: String?
    public static var userId: String?
    
    public func setup(logString: String) -> NKFeedBackMailViewController {
        self.mailComposeDelegate = self
        
        let userEmailHtlmString = NKFeedBackMailViewController.userEmail != nil ? "</br>User emai: \(NKFeedBackMailViewController.userEmail!)" : ""
        
        let userIdHtlmString = NKFeedBackMailViewController.userId != nil ? "</br>User id: \(NKFeedBackMailViewController.userId!)" : ""
        
         let body = "</br></br>_______________</br>App Name: \(NKAppInfo.Name)</br>App Version: \(NKAppInfo.Version) - \(NKAppInfo.Build)\(userIdHtlmString)\(userEmailHtlmString)</br>Device Info: \(NKDeviceInfo.Model) - \(NKDeviceInfo.Version)" //NPN TODO: add device info
        
        self.setMessageBody(body, isHTML: true)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let dateString = dateFormatter.stringFromDate(NSDate())
        
        if let window = UIApplication.sharedApplication().windows.first , screenShotData = UIImagePNGRepresentation(window.nk_snapshot()) {
            self.addAttachmentData(screenShotData, mimeType: "image/png", fileName: "screenshot-\(NKAppInfo.Name)-\(dateString).png")
        }
        
        if let data = logString.dataUsingEncoding(NSUTF8StringEncoding) {
            self.addAttachmentData(data, mimeType: "text/plain", fileName: "log-\(NKAppInfo.Name)-\(dateString).txt")
        }
        
        return self
    }
    
    public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UIView {
    func nk_snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        self.layer.renderInContext(context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!
    }

}

struct NKAppInfo {
    static let Name = (NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String) ?? ""
    static let Build = (NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? Int) ?? 0
    static let Version = (NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0"
    static let Identifier = (NSBundle.mainBundle().infoDictionary?["CFBundleIdentifier"] as? String) ?? ""
}

struct NKDeviceInfo {
    static let Version = UIDevice.currentDevice().systemVersion
    static let Model = UIDevice.currentDevice().model
}
