//
//  Log.swift
//  KnackerTemplate
//
//  Created by Nghia Nguyen on 1/15/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import UIKit

public class NLog: NSObject {
    //MARK: Private
    static var dateFormat = NSDateFormatter.logDateFormatter()
    
    static var AppName = (NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String) ?? ""
    
    private static func log(level: Level,
        tag: String,
        _ message: String,
        var color: UIColor?,
        file: String,
        function: String,
        line: Int) {
            
            guard NLog.levels.contains(level) else {
                return
            }
            
            if color == nil {
                color = NLog.levelColors[level] ?? UIColor.whiteColor()
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
                color = NLog.levelColors[level] ?? UIColor.whiteColor()
            }
            
            if replaceNLog != nil {
                replaceNLog?(level: level,
                    tag: tag,
                    message: message,
                    color: color!,
                    file: file,
                    function: function,
                    line: line)
            }
            
            let logEntry = NLogEntry(level: level.rawValue, message: message, tag: tag, color: color?.hex ?? 0,
                file: file, function: function, line: line)
            logEntry.save()
            
            print(logEntry.shortDesc)
    }
    
    //MARK: Public static funcs
    public enum Level: String {
        case Info =  "Info"
        case Error = "Error"
        case Debug = "Debug"
        case Warning = "Waring"
        case Server = "Server"
    }
    
    public enum DisplayType: Int {
        case Full
        case Short
    }
    
    public static var levelColors: [Level : UIColor] = [
        .Info: UIColor(hex: 0x3498db),
        .Error: UIColor(hex: 0xe74c3c),
        .Debug: UIColor(hex: 0xf1c40f),
        .Warning: UIColor(hex: 0xffff),
        .Server: UIColor(hex: 0xecf0f1)]
    
    public static var rollingFrequency: Double = 24 * 3600 { // 1 day
        didSet {
            NLogEntry.deleteBeforeDate(NSDate().timeIntervalSince1970 - self.rollingFrequency)
        }
    }
    
    public static let kDebugLevels: [Level] = [.Debug, .Info, .Error, .Warning, .Server]
    public static let kReleaseLevels: [Level] = [.Info, .Error, .Warning]
    
    public static var levels: [Level] = NLog.kDebugLevels
    
    public static var limitDisplayedCharacters = 1000
    
    public static var filters: [String]? = nil
    
    public static var replaceNLog: ((level: Level,
    tag: String,
    message: String,
    color: UIColor,
    file: String,
    function: String,
    line: Int) -> Void)?
    
    public static func saveToFile(level: Level? = nil, tag: String = "",
        filter: String = "",limit: Int? = nil, path: String) -> Bool {
            let mes = self.getLogString(level, tag: tag, filter: filter, limit: limit)
            
            do {
                try mes.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
                return true
            } catch _ {
                return false
            }
            
    }
    
    public static func getLogString(level: Level? = nil,
        tag: String = "",
        filter: String = "",
        var limit: Int? = nil) -> String {
            var mes = ""
            
            let levelString = level == nil ? "" : level!.rawValue
            
            guard let allLogs = NLogEntry.getAll()?
                .filter("level contains '\(levelString)'")
                .filter("tag contains '\(tag)'")
                .filter("message contains '\(filter)'") else {
                    return mes
            }
            
            for log in allLogs {
                mes += log.fullDesc + "\n"
                
                limit = limit.map({$0 - 1})
                
                if limit == 0 {
                    break
                }
            }
            return mes
    }
    
    public static func debug(
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
    
    public static func info(
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
    
    public static func warning(
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
    
    public static func error(
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
    
    public static func server(
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
        let strings = self.description.componentsSeparatedByString("number = ")
        if strings.count < 2 {
            return 0
        }
        
        return Int(strings[1].componentsSeparatedByString(",").first ?? "") ?? 0
    }
}