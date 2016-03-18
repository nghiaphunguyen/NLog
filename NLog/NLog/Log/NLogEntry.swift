//
//  NLogEntry.swift
//  KnackerTemplate
//
//  Created by Nghia Nguyen on 2/11/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import RealmSwift

class NLogEntry: Object {
    dynamic var id = ""
    dynamic var createdAt: Double = 0
    dynamic var level = ""
    dynamic var message = ""
    dynamic var tag: String = ""
    dynamic var color: Int = 0
    dynamic var file: String = ""
    dynamic var function: String = ""
    dynamic var stackTrace: String = ""
    dynamic var line: Int = 0
    
    private var desc: String {
        var displayMessage = ""
        
        if let lv = NLog.Level(rawValue: level) {
            switch lv {
            case .Debug:
                displayMessage += "|Debug|"
            case .Error:
                displayMessage += "|Error|"
            case .Info:
                displayMessage += "|Info|"
            case .Warning:
                displayMessage += "|Warning|"
            case .Server:
                displayMessage += "|Server|"
            }
        }
        
        displayMessage += tag == "" ? " " : (" #" + tag + ": ")
        
        displayMessage += message
        return displayMessage
    }
    
    private func descLog(desc: String) -> String {
        let currentThreadNumber = NSThread.currentThread().number
        var log = NLog.dateFormat.stringFromDate(NSDate(timeIntervalSince1970: self.createdAt))
        log += " \(AppName)[\(currentThreadNumber == 1 ? "MainThread" : "\(currentThreadNumber)")] "
        
        return "\(log) \((file as NSString).lastPathComponent) - \(line) - \(function)\n\(desc)\n"
    }
    
    var fullDesc: String {
        return descLog(self.desc)
    }
    
    var fullDescWithStackTrace: String {
        return self.fullDesc + "=====================================\n" + self.stackTrace + "=====================================\n"
    }
    
    var shortDesc: String {
        return descLog(self.desc[0..<NLog.limitDisplayedCharacters])
    }
    
    convenience init(level: String, message: String, tag: String, color: Int, file: String, function: String, line: Int, stackTrace: String) {
        self.init()
        let now = NSDate().timeIntervalSince1970
        self.id = "\(now)"
        self.level = level
        self.createdAt = now
        self.message = message
        self.tag = tag
        self.color = color
        self.file = file
        self.function = function
        self.line = line
        self.stackTrace = stackTrace
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func save() {
        guard let realm = Realm.createLogRealm() else {
            return
        }
        
        let tag = NLogTag()
        tag.id = self.tag
        
        try! realm.write({ () -> Void in
            realm.add(self, update: true)
            realm.add(tag, update: true)
        })
    }
    
    static func getAll() -> Results<NLogEntry>? {
        guard let realm = Realm.createLogRealm() else {
            return nil
        }
        
        return realm.objects(NLogEntry).sorted("createdAt", ascending: false)
    }
    
    static func deleteBeforeDate(timestamp: Double) {
        guard let realm = Realm.createLogRealm() else {
            return
        }
        
        try! realm.write({ () -> Void in
            realm.delete(realm.objects(NLogEntry).filter("createdAt <= \(timestamp)"))
        })
    }
}

