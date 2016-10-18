//
//  NLogTag.swift
//  NLog
//
//  Created by Nghia Nguyen on 3/2/16.
//  Copyright © 2016 knacker. All rights reserved.
//

import Foundation
import RealmSwift

class NLogTag: Object {
    dynamic var id = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func getAllTags() -> Results<NLogTag>? {
        guard let realm = Realm.createLogRealm() else {
            return nil
        }
        
        return realm.objects(NLogTag.self)
    }
}
