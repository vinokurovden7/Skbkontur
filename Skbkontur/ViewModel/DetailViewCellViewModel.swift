//
//  DetailViewCellViewModel.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 15/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation

class DetailViewCellViewModel: DetailViewCellViewModelType{
    
    //Функция преобразования даты
    func getDate(strDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from:strDate)
        return formatter.string(from: date ?? Date())
    }
    
    private var person: Person
    
    var name: String{
        return person.name
    }
    
    var dateEducation: String{
        return "\(getDate(strDate: person.educationPeriodStart)) - \(getDate(strDate: person.educationPeriodEnd))"
    }
    
    var temperament: String{
        return person.temperament
    }
    
    var phone: String{
        return person.phone
    }
    
    var biography: String{
        return person.biography
    }
    
    init(person: Person) {
        self.person = person
    }
    
    
}
