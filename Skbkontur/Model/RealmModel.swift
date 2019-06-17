//
//  RealmModel.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 12/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import RealmSwift

class Person: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var phone = ""
    @objc dynamic var height: Float = 0.0
    @objc dynamic var biography = ""
    @objc dynamic var temperament = ""
    @objc dynamic var educationPeriodStart: String = ""
    @objc dynamic var educationPeriodEnd: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, name:String, phone:String, height:Float, biography:String, temperament:String, educationPeriodStart:String, educationPeriodEnd: String){
        self.init()
        self.name = name
        self.phone = phone
        self.height = height
        self.biography = biography
        self.temperament = temperament
        self.educationPeriodStart = educationPeriodStart
        self.educationPeriodEnd = educationPeriodEnd
        
    }
    
}

class LastStart: Object {
    @objc dynamic var lastDateTimeStart: Date = Date()
    
    convenience init(lastDateTimeStart: Date) {
        self.init()
        self.lastDateTimeStart = lastDateTimeStart
    }
}
