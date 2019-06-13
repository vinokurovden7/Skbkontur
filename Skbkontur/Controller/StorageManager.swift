//
//  StorageManager.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 12/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManage{
    
    static func saveObjectsPerson(_ person: Person){
        try! realm.write {
            realm.add(person)
        }
    }
    
    static func saveObjectLastDateTime(_ lastDateTime: LastStart){
        try! realm.write {
            realm.add(lastDateTime)
        }
    }
    
    static func removePersonData(_ person: Person){
        try! realm.write {
            realm.delete(person)
        }
    }
    
    static func removeAllData(){
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
