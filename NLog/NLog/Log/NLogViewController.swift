//
//  NLogViewController.swift
//  NLog
//
//  Created by Nghia Nguyen on 2/12/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit
import RealmSwift

public class NLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate{
    static let kCellIdentifier = "LogCell"
    
    var logEntrys: Results<NLogEntry>?
    var rootLogEntrys: Results<NLogEntry>?
    
    var token: RealmSwift.NotificationToken?
    
    var currentLevel = ""
    var currentTag = ""
    
    lazy var logLevels: [String] = {
        var levels = ["|All|"]
        for level in NLog.displayedLevels {
            levels.append("|" + level.rawValue + "|")
        }
        
        return levels
    }()
    
    lazy var tags: [String] = {
        var result = ["#All"]
        
        if let tags = NLogTag.getAllTags() {
            for tag in tags {
                if tag.id != "" {
                    result.append("#" + tag.id)
                }
            }
        }
        return result
    }()
    
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.blackColor()
        return tableView
    }()
    
    lazy var logLevelPicker: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    lazy var logLevelTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.blackColor()
        textField.inputView = self.logLevelPicker
        textField.text = self.logLevels.first
        textField.textColor = UIColor.whiteColor()
        textField.textAlignment = .Center
        return textField
    }()
    
    lazy var tagPicker: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    lazy var tagTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.blackColor()
        textField.inputView = self.tagPicker
        textField.text = self.tags.first
        textField.textColor = UIColor.whiteColor()
        textField.textAlignment = .Center
        return textField
    }()
    
    lazy var searchTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = UIColor.whiteColor()
        textField.placeholder = "Search..."
        textField.clearButtonMode = .WhileEditing
        textField.addTarget(self, action: "searchTextFieldChangedValue", forControlEvents: .EditingChanged)
        return textField
    }()
    
    //MARK: Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        self.rootLogEntrys = NLogEntry.getAll()
        self.logEntrys = self.rootLogEntrys
        self.tableView.reloadData()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "tappedOutsizeKeyboard")
        tapRecognizer.delegate = self
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func tappedOutsizeKeyboard() {
        self.view.endEditing(true)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let realm = Realm.createLogRealm()
        self.token = realm?.addNotificationBlock({ (notification, realm) -> Void in
            self.tableView.reloadData()
        })
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let token = self.token {
            let realm = Realm.createLogRealm()
            realm?.removeNotification(token)
        }
    }
    
    //MARK: private functions
    func setupView() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(self.searchTextField)
        self.view.addSubview(self.logLevelTextField)
        self.view.addSubview(self.tagTextField)
        self.view.addSubview(self.tableView)
        
        var alignTop = StatusBarHeight + self.navigationBarHeight
        if self.navigationController?.navigationBar.translucent == false {
            alignTop = 0
        }
        
        self.searchTextField.nk_pinTopConstraintView(offset: alignTop)
            .nk_pinLeadingConstraintView()
            .nk_pinTrailingConstraintView()
            .nk_heightConstraint(40)
        
        self.logLevelTextField.nk_alignTopConstraintView(self.searchTextField)
            .nk_pinLeadingConstraintView()
            .nk_heightConstraintView(self.searchTextField)
            .nk_widthConstraintView(nil, multiplier: 0.5)
        
        self.tagTextField.nk_pinTopConstraintView(self.logLevelTextField)
            .nk_alignLeadingConstraintView(self.logLevelTextField)
            .nk_pinTrailingConstraintView()
            .nk_heightConstraintView(self.searchTextField)
        
        self.tableView.nk_alignTopConstraintView(self.logLevelTextField)
            .nk_pinLeadingConstraintView()
            .nk_pinBottomConstraintView()
            .nk_pinTrailingConstraintView()
    }
    
    //MARK: Events
    func searchTextFieldChangedValue() {
        let key = self.searchTextField.text ?? ""
        self.logEntrys = self.rootLogEntrys?.filter("tag contains '\(key)' OR message contains '\(key)'").filter("level contains '\(currentLevel)'").filter("tag contains '\(currentTag)'")
        self.tableView.reloadData()
    }
    
    //MARK: UITableViewDataSource
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logEntrys?.count ?? 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(self.dynamicType.kCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: self.dynamicType.kCellIdentifier)
            cell?.textLabel?.numberOfLines = 0
            cell?.backgroundColor = UIColor.blackColor()
            cell?.accessoryType = .DisclosureIndicator
        }
        
        if let logEntry = logEntrys?[indexPath.row] {
            cell?.textLabel?.font = UIFont.systemFontOfSize(10)
            cell?.textLabel?.text = logEntry.shortDesc
            cell?.textLabel?.textColor = UIColor(hex: logEntry.color)
        }
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let logEntry = logEntrys?[indexPath.row] {
            let logDetailViewController = NLogDetailViewController()
            logDetailViewController.logEntry = logEntry
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(logDetailViewController, animated: true)
            } else {
                self.presentViewController(logDetailViewController, animated: true, completion: nil)
            }
            
        }
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    //MARK: UIPickerView
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.logLevelPicker {
            return self.logLevels.count
        }
        
        return self.tags.count
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.logLevelPicker {
            return self.logLevels[row]
        }
        
        return self.tags[row]
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.logLevelPicker {
            let value = self.logLevels[row].stringByReplacingOccurrencesOfString("|", withString: "")
            self.currentLevel =  value == "All" ? "" : value
            self.logLevelTextField.text = self.logLevels[row]
        } else {
            let value = self.tags[row].stringByReplacingOccurrencesOfString("#", withString: "")
            self.currentTag = value == "All" ? "" : value
            self.tagTextField.text = self.tags[row]
        }
        
        self.searchTextFieldChangedValue()
        self.view.endEditing(true)
    }
    
    //MARK: GestureRegconizer
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view?.isDescendantOfView(self.tableView) == true {
            self.view.endEditing(true)
            return false
        }
        
        return true
    }
}

extension UIViewController {
    var navigationBarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0
    }
}

var StatusBarHeight: CGFloat {
    return 20
}
