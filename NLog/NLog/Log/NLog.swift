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
                return
            }
            
            let stackTrace = NSThread.callStackSymbols()
            var stackTraceString = ""
            
            if stackTrace.count > 2 {
                stackTraceString = Array(stackTrace[2...min(stackTrace.count, NLog.maxStackTrace)]).toString
            }
            
            let logEntry = NLogEntry(level: level.rawValue, message: message, tag: tag, color: color?.hex ?? 0,
                file: file, function: function, line: line, stackTrace: stackTraceString)
            logEntry.save()
            
            
            if let color = color where NLog.enableXcodeColors {
                NLog.printLog(logEntry.shortDesc, withColor: color)
            } else {
                print(logEntry.shortDesc)
            }
            
    }
    
    private static func printLog(log: String, withColor color: UIColor) {
        let rgb = color.rgb
        
        let prefix = "\u{001b}["
        let colorLog = prefix + "fg\(rgb.r),\(rgb.g),\(rgb.b);\(log)\(prefix);\n"
        print(colorLog)
    }
    
    //MARK: Public static funcs
    public struct Emotion {
        static let Success = ""
        static let Fail = ""
        static let Processing = ""
        static let Warning = ""
        static let Error = ""
    }
    
    public enum Level: String {
        case Info =  "Info"
        case Error = "Error"
        case Debug = "Debug"
        case Warning = "Warning"
        case Server = "Server"
    }
    
    public enum DisplayType: Int {
        case Full
        case Short
    }
    
    //Turn it on if you install XcodeColors plugin
    // ses also at https://github.com/robbiehanson/XcodeColors
    public static var enableXcodeColors = false
    
    public static var levelColors: [Level : UIColor] = [
        .Info: UIColor(hex: 0x9CCC65),
        .Error: UIColor(hex: 0xEF5350),
        .Debug: UIColor(hex: 0xffffff),
        .Warning: UIColor(hex: 0xFFCA28),
        .Server: UIColor(hex: 0x29B6F6)]
    
    public static var rollingFrequency: Double = 24 * 3600 { // 1 day
        didSet {
            NLogEntry.deleteBeforeDate(NSDate().timeIntervalSince1970 - self.rollingFrequency)
        }
    }
    
    public static let kDebugLevels: [Level] = [.Debug, .Info, .Error, .Warning, .Server]
    public static let kReleaseLevels: [Level] = [.Info, .Error, .Warning]
    
    public static var levels: [Level] = NLog.kDebugLevels
    
    public static var limitDisplayedCharacters = 1000
    
    public static var maxStackTrace = 7
    
    public static var filters: [String]? = nil
    
    public static var replaceNLog: ((level: Level,
    tag: String,
    message: String,
    color: UIColor,
    file: String,
    function: String,
    line: Int) -> Void)?
    
    public static func saveToFile(path path: String, level: Level? = nil, tag: String = "",
        filter: String = "",limit: Int? = nil, stackTrace: Bool = false) -> Bool {
            let mes = self.getLogString(level: level, tag: tag, filter: filter, limit: limit, stackTrace: stackTrace)
            
            do {
                try mes.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
                return true
            } catch _ {
                return false
            }
            
    }
    
    public static func getLogString(level level: Level? = nil,
        tag: String = "",
        filter: String = "",
        var limit: Int? = nil,
        stackTrace: Bool = false) -> String {
            var mes = ""
            
            let levelString = level == nil ? "" : level!.rawValue
            
            guard let allLogs = NLogEntry.getAll()?
                .filter("level contains '\(levelString)'")
                .filter("tag contains '\(tag)'")
                .filter("message contains '\(filter)'") else {
                    return mes
            }
            
            for log in allLogs {
                
                let logString = stackTrace ? log.fullDescWithStackTrace : log.fullDesc
                mes += logString + "\n"
                
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
