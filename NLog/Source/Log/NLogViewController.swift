//
//  NLogViewController.swift
//  NLog
//
//  Created by Nghia Nguyen on 2/12/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit
import RealmSwift

open class NLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate{
    static let kCellIdentifier = "LogCell"
    
    var logEntrys: Results<NLogEntry>?
    var rootLogEntrys: Results<NLogEntry>?
    
    var token: RealmSwift.NotificationToken?
    
    var currentLevel = ""
    var currentTag = ""
    
    lazy var logLevels: [String] = {
        var levels = ["|All|"]
        for level in NLog.levels {
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
        tableView.backgroundColor = UIColor.black
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
        textField.backgroundColor = UIColor.black
        textField.inputView = self.logLevelPicker
        textField.text = self.logLevels.first
        textField.textColor = UIColor.white
        textField.textAlignment = .center
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
        textField.backgroundColor = UIColor.black
        textField.inputView = self.tagPicker
        textField.text = self.tags.first
        textField.textColor = UIColor.white
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var searchTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Search..."
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(NLogViewController.searchTextFieldChangedValue), for: .editingChanged)
        return textField
    }()
    
    //MARK: Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        self.rootLogEntrys = NLogEntry.getAll()
        self.logEntrys = self.rootLogEntrys
        self.tableView.reloadData()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NLogViewController.tappedOutsizeKeyboard))
        tapRecognizer.delegate = self
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func tappedOutsizeKeyboard() {
        self.view.endEditing(true)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(NLogViewController.tappedActionButton))
        
        let realm = Realm.createLogRealm()
        self.token = realm?.addNotificationBlock({ (notification, realm) -> Void in
            self.tableView.reloadData()
        })
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let token = self.token {
            token.stop()
        }
    }
    
    //MARK: private functions
    func tappedActionButton() {
        let sendFeedbackAlertAction = UIAlertAction(title: "Send feedback", style: UIAlertActionStyle.default) { (action) -> Void in
            self.sendFeedback()
        }
        
        let clearAlertAction = UIAlertAction(title: "Clear logs", style: UIAlertActionStyle.destructive) { (action) -> Void in
            self.clearLogs()
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(sendFeedbackAlertAction)
        alertController.addAction(clearAlertAction)
        alertController.addAction(cancelAlertAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func clearLogs() {
        NLogEntry.deleteBeforeDate(Date().timeIntervalSince1970)
        self.tableView.reloadData()
    }
    
    func sendFeedback() {
        
        let sendFeedbackBlock: (_ stackTrace: Bool) -> Void = { (stackTrace) in
            let logString = NLog.getLogString(level: NLog.Level(rawValue: self.currentLevel), tag: self.currentTag, filter: self.searchTextField.text ?? "", limit: nil, stackTrace: stackTrace)
            
            self.present(NKFeedBackMailViewController().setup(logString), animated: true, completion: nil)
        }
        
        let actionNonStackTrace = UIAlertAction(title: "Non Stack Trace", style: UIAlertActionStyle.default) { (_) -> Void in
            sendFeedbackBlock(false)
        }
        
        let actionStackTrace = UIAlertAction(title: "With Stack Trace", style: UIAlertActionStyle.default) { (_) -> Void in
            sendFeedbackBlock(true)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        let alertViewController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertViewController.addAction(actionNonStackTrace)
        alertViewController.addAction(actionStackTrace)
        alertViewController.addAction(actionCancel)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.searchTextField)
        self.view.addSubview(self.logLevelTextField)
        self.view.addSubview(self.tagTextField)
        self.view.addSubview(self.tableView)
        
        var alignTop = StatusBarHeight + self.navigationBarHeight
        if self.navigationController?.navigationBar.isTranslucent == false {
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
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logEntrys?.count ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).kCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: type(of: self).kCellIdentifier)
            cell?.textLabel?.numberOfLines = 0
            cell?.backgroundColor = UIColor.black
            cell?.accessoryType = .disclosureIndicator
        }
        
        if let logEntry = logEntrys?[indexPath.row] {
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 10)
            cell?.textLabel?.text = logEntry.shortDesc
            cell?.textLabel?.textColor = UIColor(hex: logEntry.color)
        }
        
        return cell!
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let logEntry = logEntrys?[indexPath.row] {
            let logDetailViewController = NLogDetailViewController()
            logDetailViewController.logEntry = logEntry
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(logDetailViewController, animated: true)
            } else {
                self.present(logDetailViewController, animated: true, completion: nil)
            }
            
        }
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //MARK: UIPickerView
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.logLevelPicker {
            return self.logLevels.count
        }
        
        return self.tags.count
    }
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.logLevelPicker {
            return self.logLevels[row]
        }
        
        return self.tags[row]
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.logLevelPicker {
            let value = self.logLevels[row].replacingOccurrences(of: "|", with: "")
            self.currentLevel =  value == "All" ? "" : value
            self.logLevelTextField.text = self.logLevels[row]
        } else {
            let value = self.tags[row].replacingOccurrences(of: "#", with: "")
            self.currentTag = value == "All" ? "" : value
            self.tagTextField.text = self.tags[row]
        }
        
        self.searchTextFieldChangedValue()
        self.view.endEditing(true)
    }
    
    //MARK: GestureRegconizer
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableView) == true {
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
