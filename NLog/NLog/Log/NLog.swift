//
//  Log.swift
//  KnackerTemplate
//
//  Created by Nghia Nguyen on 1/15/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import UIKit

public class NLog {
    //MARK: Private
    static var dateFormat = NSDateFormatter.logDateFormatter()
    
    static var AppName = (NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String) ?? ""
    
    private static var displayLogs: [Level] = [.Debug, .Info, .Error, .Warning, .Server]
    
    private static func log(level: Level,
        tag: String,
        _ message: String,
        var color: UIColor?,
        file: String,
        function: String,
        line: Int) {
            
            guard NLog.displayLogs.contains(level) else {
                return
            }
            
            if let filters = NLog.filters {
                var check = false
                for filter in filters {
                    if message.containsString(filter) || tag.containsString(filter) {
                        check = true
                        break
                    }
                }
                if check == false {
                    return
                }
            }
            
            if color == nil {
                color = UIColor(hex: level.rawValue)
            }
            
            let logEntry = NLogEntry(level: level.rawValue, message: message, tag: tag, color: color?.hex ?? 0,
                file: file, function: function, line: line)
            logEntry.save()
            
            if NLog.displayType == .Full {
                print(logEntry.fullDesc)
            } else {
                print(logEntry.desc)
            }
    }
    
    //MARK: Public static funcs
    public enum Level: Int {
        case Info =  0x3498db // show Info, Error, Waring log
        case Error = 0xe74c3c // show Error log
        case Debug = 0xf1c40f // show All logs
        case Warning = 0xffff // show waring and error log
        case Server = 0xecf0f1 // push to onwer server
    }
    
    public enum DisplayType: Int {
        case Full
        case Short
    }
    
    public static var rollingFrequency: Double = 24 * 3600 { // 1 day
        didSet {
            NLogEntry.deleteBeforeDate(NSDate().timeIntervalSince1970 - self.rollingFrequency)
        }
    }
    
    public static var level = Level.Debug {
        didSet {
            switch NLog.level {
            case .Debug :
                NLog.displayLogs = [.Debug, .Info, .Error, .Warning, .Server]
            case .Error:
                NLog.displayLogs = [.Error, .Server]
            case .Warning:
                NLog.displayLogs = [.Error, .Warning, .Server]
            case .Info:
                NLog.displayLogs = [.Info, .Error, .Warning, .Server]
            case .Server:
                NLog.displayLogs = [.Server]
            }
        }
    }
    
    public static var displayType = DisplayType.Short
    
    public static var filters: [String]? = nil
    
    public static func saveLogToFile(path: String) -> Bool {
        if let allLogs = NLogEntry.getAll() {
            var mes = ""
            for log in allLogs {
                mes += log.fullDesc + "\n"
            }
            
            do {
               try mes.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
                return true
            } catch _ {
                return false
            }
        }
        
        return false
    }
    
    public static func d(
        message: String,
        _ tag: String = "",
        color: UIColor? = nil,
        file: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__) {
            NLog.log(.Debug,
                tag: tag,
                message,
                color: color,
                file: file,
                function: function,
                line: line)
    }
    
    public static func i(
        message: String,
        _ tag: String = "",
        color: UIColor? = nil,
        file: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__) {
            NLog.log(.Info,
                tag: tag,
                message,
                color: color,
                file: file,
                function: function,
                line: line)
    }
    
    public static func w(
        message: String,
        _ tag: String = "",
        color: UIColor? = nil,
        file: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__) {
            NLog.log(.Warning,
                tag: tag,
                message,
                color: color,
                file: file,
                function: function,
                line: line)
    }
    
    public static func e(
        message: String,
        _ tag: String = "",
        color: UIColor? = nil,
        file: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__) {
            NLog.log(.Error,
                tag: tag,
                message,
                color: color,
                file: file,
                function: function,
                line: line)
    }
    
    public static func s(
        message: String,
        _ tag: String = "",
        color: UIColor? = nil,
        file: String = __FILE__,
        function: String = __FUNCTION__,
        line: Int = __LINE__) {
            NLog.log(.Server,
                tag: tag,
                message,
                color: color,
                file: file,
                function: function,
                line: line)
    }
}

extension NSDateFormatter {
    static func logDateFormatter() -> NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss.SSS"
        return dateFormatter
    }
}

extension NSThread {
    var number: Int {
        return Int(self.description.componentsSeparatedByString("number = ")[1]
            .componentsSeparatedByString(",").first ?? "") ?? 0
    }
}