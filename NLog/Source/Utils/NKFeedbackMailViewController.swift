//
//  LogMailViewController.swift
//  KnackerTemplate
//
//  Created by Nghia Nguyen on 2/13/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import MessageUI
import UIKit

open class NKFeedBackMailViewController: MFMailComposeViewController, MFMailComposeViewControllerDelegate {
    
    open static var userEmail: String?
    open static var userId: String?
    
    open func setup(_ logString: String) -> NKFeedBackMailViewController {
        self.mailComposeDelegate = self
        
        let userEmailHtlmString = NKFeedBackMailViewController.userEmail != nil ? "</br>User emai: \(NKFeedBackMailViewController.userEmail!)" : ""
        
        let userIdHtlmString = NKFeedBackMailViewController.userId != nil ? "</br>User id: \(NKFeedBackMailViewController.userId!)" : ""
        
         let body = "</br></br>_______________</br>App Name: \(NKAppInfo.Name)</br>App Version: \(NKAppInfo.Version) - \(NKAppInfo.Build)\(userIdHtlmString)\(userEmailHtlmString)</br>Device Info: \(NKDeviceInfo.Model) - \(NKDeviceInfo.Version)" //NPN TODO: add device info
        
        self.setMessageBody(body, isHTML: true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        let dateString = dateFormatter.string(from: Date())
        
        if let window = UIApplication.shared.windows.first , let screenShotData = UIImagePNGRepresentation(window.nk_snapshot()) {
            self.addAttachmentData(screenShotData, mimeType: "image/png", fileName: "screenshot-\(NKAppInfo.Name)-\(dateString).png")
        }
        
        if let data = logString.data(using: String.Encoding.utf8) {
            self.addAttachmentData(data, mimeType: "text/plain", fileName: "log-\(NKAppInfo.Name)-\(dateString).txt")
        }
        
        return self
    }
    
    open func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIView {
    func nk_snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!
    }

}

struct NKAppInfo {
    static let Name = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""
    static let Build = (Bundle.main.infoDictionary?["CFBundleVersion"] as? Int) ?? 0
    static let Version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0"
    static let Identifier = (Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String) ?? ""
}

struct NKDeviceInfo {
    static let Version = UIDevice.current.systemVersion
    static let Model = UIDevice.current.model
}
