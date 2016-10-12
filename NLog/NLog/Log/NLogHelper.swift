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

var AppName = (Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? ""

extension DateFormatter {
    static func logDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss.SSS"
        return dateFormatter
    }
}

extension Thread {
    var number: Int {
        let strings = self.description.components(separatedBy: "number = ")
        if strings.count < 2 {
            return 0
        }
        
        return Int(strings[1].components(separatedBy: ",").first ?? "") ?? 0
    }
}

extension String {
    subscript(r: Range<Int>) -> String {
        let startIndex = self.characters.index(self.startIndex, offsetBy: min(self.characters.count, r.lowerBound))
        let endIndex = self.characters.index(self.startIndex, offsetBy: min(self.characters.count, r.upperBound))
        
        return self[startIndex..<endIndex]
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
    guard let url = Realm.Configuration().fileURL else {
        return nil
    }
    
    let logUrl = url.deletingLastPathComponent()
        .appendingPathComponent("log.realm")
    
    let config = Realm.Configuration(fileURL: logUrl, schemaVersion: 1)
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
