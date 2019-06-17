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
                    pers.temperament = person.temperament
                    pers.id = person.id
                    pers.phone = person.phone
                    realm.add(pers, update: true)
                }
            }
            completion()
            MainVC.countLoadUrls+=1
        }
    }
    
    static func saveObjectLastDateTime(_ lastDateTime: LastStart){
        DispatchQueue.global(qos: .utility).async {
            let realm = try! Realm()
            try! realm.write {
                realm.add(lastDateTime)
            }
        }
    }
    
}

