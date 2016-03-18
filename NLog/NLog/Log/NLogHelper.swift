//
//  NLogHelper.swift
//  NLog
//
//  Created by Nghia Nguyen on 3/18/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

var AppName = (NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String) ?? ""

extension NSDateFormatter {
    static func logDateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss.SSS"
        return dateFormatter
    }
}

extension NSThread {
    var number: Int {
        let strings = self.description.componentsSeparatedByString("number = ")
        if strings.count < 2 {
            return 0
        }
        
        return Int(strings[1].componentsSeparatedByString(",").first ?? "") ?? 0
    }
}

extension String {
    subscript(r: Range<Int>) -> String {
        let startIndex = self.startIndex.advancedBy(min(self.characters.count, r.startIndex))
        let endIndex = self.startIndex.advancedBy(min(self.characters.count, r.endIndex))
        
        return self[Range(start: startIndex, end: endIndex)]
    }
}

extension Array {
    var toString: String {
        var result = ""
        for entry in self {
            result += "\(entry)" + "\n"
        }
        
        return result
    }
}

let logConfig: Realm.Configuration? = {
    guard let path = Realm.Configuration().path else {
        return nil
    }
    
    guard let logPath = NSURL.fileURLWithPath(path).URLByDeletingLastPathComponent?
        .URLByAppendingPathComponent("log.realm").path else {
            return nil
    }
    
    let config = Realm.Configuration(path: logPath, schemaVersion: 1)
    return config
}()

extension Realm {
    static func createLogRealm() -> Realm? {
        
        guard let logConfig = logConfig else {
            return nil
        }
        
        let realm: Realm? = try! Realm(configuration: logConfig)
        
        return realm
    }
}

extension UIColor {
    var rgb: (r: Int, g: Int, b: Int) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r: Int(r * 255), g: Int(g * 255), b: Int(b * 255))
    }
}
