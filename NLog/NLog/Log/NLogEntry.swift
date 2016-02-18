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
    dynamic var line: Int = 0
    
    private var desc: String {
        var displayMessage = ""
        
        if let lv = NLog.Level(rawValue: level) {
            switch lv {
            case .Debug:
                displayMessage += "D/"
            case .Error:
                displayMessage += "E/"
            case .Info:
                displayMessage += "I/"
            case .Warning:
                displayMessage += "W/"
            case .Server:
                displayMessage += "S/"
            }
        }
        
        displayMessage += tag == "" ? " " : (tag + ": ")
        
        displayMessage += message
        return displayMessage
    }
    
    var fullDesc: String {
        var log = NLog.dateFormat.stringFromDate(NSDate(timeIntervalSince1970: self.createdAt))
        log += " \(NLog.AppName)[\(NSThread.currentThread().number)] "
        
        return "\(log) \((file as NSString).lastPathComponent) - \(line) - \(function)\n\n\(self.desc)\n"
    }
    
    var shortDesc: String {
        return fullDesc[0..<NLog.limitDisplayedCharacters]
    }
    
    convenience init(level: String, message: String, tag: String, color: Int, file: String, function: String, line: Int) {
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
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func save() {
        guard let realm = Realm.createLogRealm() else {
            return
        }
        
        try! realm.write({ () -> Void in
            realm.add(self, update: true)
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

extension Realm {
    static func createLogRealm() -> Realm? {
        guard let path = Realm.Configuration().path else {
            return nil
        }
        
        guard let logPath = NSURL.fileURLWithPath(path).URLByDeletingLastPathComponent?
            .URLByAppendingPathComponent("log.realm").path else {
            return nil
        }
        
        let config = Realm.Configuration(path: logPath)
        let realm: Realm? = try! Realm(configuration: config)
        
        return realm
    }
}

extension String {
    subscript(r: Range<Int>) -> String {
        let startIndex = self.startIndex.advancedBy(min(self.characters.count, r.startIndex))
        let endIndex = self.startIndex.advancedBy(min(self.characters.count, r.endIndex))
        
        return self[Range(start: startIndex, end: endIndex)]
    }
}
