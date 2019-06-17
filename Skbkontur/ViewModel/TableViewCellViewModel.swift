//
//  TableViewCellViewModel.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 15/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation

class TableViewCellViewModel: TableViewCellViewModelType {
    
    private var person: Person
    var name: String {
        return person.name
    }
    var phone: String {
        return person.phone
    }
    var temperament: String {
        return person.temperament
    }
    
    init(person: Person) {
        self.person = person
    }
    
}
