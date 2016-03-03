# NLog
**NLog** is a fast, simple and more powerful logging Framework for iOS.

# INSTALLATION

### Pod
```bash
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
  case Warning = "Waring"
  case Server = "Server"
}
```

### Print log
``` swift
NLog.d("Hello world!") //DEBUG Log
```

##### Print log with tag
```swift
NLog.s("Authentication failed", "OWNER_SERVER") // Tag = OWNER_SERVER
```

### Optional setup
```swift
NLog.rollingFrequency = 3600 * 24 * 7 // auto-remove log out of a week.
NLog.limitDisplayedCharacters = 1000 // limit chracteristic displayed on console log
NLog.displayedLevels = [.Debug, .Error, .Server] // only allow this levels - Default is allow all.
NLog.filters = ["Apple", "Orange", "Banana"] // only allow logs contain filters.

NLog.replaceNLog = {(level, tag, message, color, file, function, line) in
    //maybe in some case, you don't wanna use us, can use this.
}
```

### Get log string
