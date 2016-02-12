//
//  NLogViewController.swift
//  NLog
//
//  Created by Nghia Nguyen on 2/12/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import UIKit
import RealmSwift

public class NLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    static let kCellIdentifier = "LogCell"
    
    var logEntrys: Results<NLogEntry>?
    var rootLogEntrys: Results<NLogEntry>?
    
    var token: RealmSwift.NotificationToken?
    
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.blackColor()
        return tableView
    }()
    
    lazy var searchTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = UIColor.whiteColor()
        textField.placeholder = "Filter..."
        textField.clearButtonMode = .WhileEditing
        textField.addTarget(self, action: "searchTextFieldChangedValue", forControlEvents: .EditingChanged)
        return textField
    }()
    
    //MARK: Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        let realm = Realm.createLogRealm()
        self.token = realm?.addNotificationBlock({ (notification, realm) -> Void in
            self.tableView.reloadData()
        })
        
        self.rootLogEntrys = NLogEntry.getAll()
        self.logEntrys = self.rootLogEntrys
        self.tableView.reloadData()
    }
    
    //MARK: private functions
    func setupView() {
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(self.searchTextField)
        self.searchTextField.pinTopConstraintView(offset: StatusBarHeight + self.navigationBarHeight)
            .pinLeadingConstraintView()
            .pinTrailingConstraintView()
            .heightConstraint(50)
        
        self.view.addSubview(self.tableView)
        self.tableView.alignTopConstraintView(self.searchTextField)
            .pinLeadingConstraintView()
            .pinBottomConstraintView()
            .pinTrailingConstraintView()
    }
    
    //MARK: Events
    func searchTextFieldChangedValue() {
        let key = self.searchTextField.text ?? ""
        self.logEntrys = self.rootLogEntrys?.filter("tag contains '\(key)' OR message contains '\(key)'")
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
        }
        
        if let logEntry = logEntrys?[indexPath.row] {
            cell?.textLabel?.font = UIFont.systemFontOfSize(10)
            cell?.textLabel?.text = logEntry.desc
            cell?.textLabel?.textColor = UIColor(hex: logEntry.color)
        }
        
        return cell!
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
}

extension UIViewController {
    var navigationBarHeight: CGFloat {
        return self.navigationController?.navigationBar.height ?? 0
    }
}

var StatusBarHeight: CGFloat {
    return 20
}
