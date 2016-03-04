# NLog 1.0.5
**NLog** is a fast, simple and more powerful logging Framework for iOS.

*Inspired by CocoalumberjackLog and RGA Log.*

# CHANGE LOG

**v1.0.5 - 03/04/2016**

1. Add function sending feedback.

# INSTALLATION

### Pod
```bash
use_frameworks!

pod 'NLog'
```

### Carthage
```bash
github 'nghiaphunguyen/NLog'
```

# USAGE

```swift
import NLog
```

### Log levels
```swift
public enum Level: String {
  case Info =  "Info"
  case Error = "Error"
  case Debug = "Debug"
  case Warning = "Warning"
  case Server = "Server"
}
```

### Print log
``` swift
NLog.debug("Hello world!")
```

##### Print log with tag
```swift
NLog.server("Authentication failed", "OWNER_SERVER") // Tag = OWNER_SERVER
```

##### Print log with specific color --- Use to display log in NLogViewController
```swift
NLog.info("More colorful", color: UIColor.blueColor())
```

### Optional setup
```swift
NLog.rollingFrequency = 3600 * 24 * 7 // auto remove log overdue for a week.
NLog.limitDisplayedCharacters = 1000 // limit displayed chracteristics of a message on console log.
NLog.levels = [.Debug, .Error, .Server] // only allow this levels - Default is allow all.
NLog.filters = ["Apple", "Orange", "Banana"] // only allow logs contain filters.

NLog.replaceNLog = {(level, tag, message, color, file, function, line) in
    //maybe in some cases, you don't wanna use us, can use this to replace NLog by another Log you want.
}

NLog.levelColors[.Debug] = UIColor.blueColor() // change the default level color
```

### Query log
```swift
let logString = NLog.getLogString() // get all log

// get with filter
let logStringFiltered = NLog.getLogString(level: .Server, tag: "OWNER_SERVER", filter: "user/me", limit: 1000)
```

### Save log to file
```swift
NLog.saveToFile(path: "../log.txt") // optional filter like query log
```

### NLogViewController
NLog provides the view to see logs like console log and more fuctions:

1. Search messages.
2. Filter level log and tag.
3. See detail of log.
4. Distinguish log level by colors.

![NLogViewController](http://i.imgur.com/F2cPLku.png)
