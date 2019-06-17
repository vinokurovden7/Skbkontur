//
//  StorageManager.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 12/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import RealmSwift

class StorageManage{
    
    static func saveObjectsPerson(_ persons: [Person], completion: @escaping ()->()){
        DispatchQueue.global(qos: .utility).async {
            let realm = try! Realm()
            for person in persons {
                let pers = Person()
                try! realm.write {
                    pers.name = person.name
                    pers.biography = person.biography
                    pers.educationPeriodEnd = person.educationPeriodEnd
                    pers.educationPeriodStart = person.educationPeriodStart
                    pers.height = person.height
                    pers.id = person.id
                    pers.phone = person.phone
                    realm.add(pers, update: true)
                    completion()
                }
            }
        }
    }
    
    static func saveObjectLastDateTime(_ lastDateTime: LastStart){
        let realm = try! Realm()
        try! realm.write {
            realm.add(lastDateTime)
        }
    }
    
    static func removePersonData(_ person: Person){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(person)
        }
    }
    
    static func removeAllData(){
        DispatchQueue.global(qos: .utility).async {
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
        }
    }
    
}

