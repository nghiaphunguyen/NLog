//
//  Log.swift
//  KnackerTemplate
//
//  Created by Nghia Nguyen on 1/15/16.
//  Copyright © 2016 misfit. All rights reserved.
//

import UIKit

open class NLog: NSObject {
    //MARK: Private
    static let kDateFormat = DateFormatter.logDateFormatter()
    static let kDataQueue = DispatchQueue(label: "nlog_data_queue", attributes: [])
    
    fileprivate static func log(_ level: Level,
        tag: String,
        _ message: String,
        color: UIColor?,
        file: String,
        function: String,
        line: Int) {
            
            guard NLog.levels.contains(level) else {
                return
            }
        
            var color = color
            if color == nil {
                color = NLog.levelColors[level] ?? UIColor.white
            }
            
            if let filters = NLog.filters {
                var check = false
                for filter in filters {
                    if message.contains(filter) || tag.contains(filter) {
                        check = true
                        break
                    }
                }
                if check == false {
                    return
                }
            }
            
            if color == nil {
                color = NLog.levelColors[level] ?? UIColor.white
            }
            
            if replaceNLog != nil {
                replaceNLog?(level,
                    tag,
                    message,
                    color!,
                    file,
                    function,
                    line)
                return
            }
            
            let stackTrace = Thread.callStackSymbols
            var stackTraceString = ""
            
            if stackTrace.count > 2 {
                stackTraceString = Array(stackTrace[2...min(stackTrace.count, NLog.maxStackTrace)]).toString
            }
        
            let logEntry = NLogEntry(level: level.rawValue, message: message, tag: tag, color: color?.hex ?? 0,
                                 file: file, function: function, line: line, stackTrace: stackTraceString)
        
            let printedString = logEntry.shortDesc
            NLog.kDataQueue.async {
                logEntry.save()
            }
            
            if let color = color , NLog.enableXcodeColors {
                NLog.printLog(printedString, withColor: color)
            } else {
                print(printedString)
            }
            
    }
    
    fileprivate static func printLog(_ log: String, withColor color: UIColor) {
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
        case full
        case short
    }
    
    //Turn it on if you install XcodeColors plugin
    // ses also at https://github.com/robbiehanson/XcodeColors
    open static var enableXcodeColors: Bool {
        set {
            if newValue {
                setenv("XcodeColors", "YES", 0);
            } else {
                setenv("XcodeColors", "NO", 0);
            }
        }
        
        get {
            let xcode_colors = getenv("XcodeColors");
            return (xcode_colors != nil && (strcmp(xcode_colors, "YES") == 0))
        }
    }
    
    open static var levelColors: [Level : UIColor] = [
        .Info: UIColor(hex: 0x9CCC65),
        .Error: UIColor(hex: 0xEF5350),
        .Debug: UIColor(hex: 0xffffff),
        .Warning: UIColor(hex: 0xFFCA28),
        .Server: UIColor(hex: 0x29B6F6)]
    
    open static var rollingFrequency: Double = 24 * 3600 { // 1 day
        didSet {
            NLogEntry.deleteBeforeDate(Date().timeIntervalSince1970 - self.rollingFrequency)
        }
    }
    
    open static let kDebugLevels: [Level] = [.Debug, .Info, .Error, .Warning, .Server]
    open static let kReleaseLevels: [Level] = [.Info, .Error, .Warning]
    
    open static var levels: [Level] = NLog.kDebugLevels
    
    open static var limitDisplayedCharacters = 1000
    
    open static var maxStackTrace = 7
    
    open static var filters: [String]? = nil
    
    open static var replaceNLog: ((_ level: Level,
    _ tag: String,
    _ message: String,
    _ color: UIColor,
    _ file: String,
    _ function: String,
    _ line: Int) -> Void)?
    
    open static func saveToFile(path: String, level: Level? = nil, tag: String = "",
        filter: String = "",limit: Int? = nil, stackTrace: Bool = false) -> Bool {
            let mes = self.getLogString(level: level, tag: tag, filter: filter, limit: limit, stackTrace: stackTrace)
            
            do {
                try mes.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
                return true
            } catch _ {
                return false
            }
            
    }
    
    open static func getLogString(level: Level? = nil,
        tag: String = "",
        filter: String = "",
        limit: Int? = nil,
        stackTrace: Bool = false) -> String {
            var mes = ""
            var limit = limit
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
    
    open static func debug(
        _ message: String,
        _ tag: String = "",
        color: UIColor? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line) {
            NLog.log(.Debug,
                tag: tag,
                message,
                color: color,
                file: file,
                function: function,
                line: line)
    }
    
    open static func info(
        _ message: String,
        _ tag: String = "",
        color: UIColor? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line) {
            NLog.log(.Info,
                tag: tag,
                message,
                color: color,
                file: file,
                function: function,
                line: line)
    }
    
    open static func warning(
        _ message: String,
        _ tag: String = "",
        color: UIColor? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line) {
            NLog.log(.Warning,
                tag: tag,
                message,
                color: color,
                file: file,
                function: function,
                line: line)
    }
    
    open static func error(
        _ message: String,
        _ tag: String = "",
        color: UIColor? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line) {
            NLog.log(.Error,
                tag: tag,
                message,
                color: color,
                file: file,
                function: function,
                line: line)
    }
    
    open static func server(
        _ message: String,
        _ tag: String = "",
        color: UIColor? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line) {
            NLog.log(.Server,
                tag: tag,
                message,
                color: color,
                file: file,
                function: function,
                line: line)
    }
}
