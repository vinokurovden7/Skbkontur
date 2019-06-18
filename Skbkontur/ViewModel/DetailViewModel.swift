//
//  DetailViewModel.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 15/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class DetailViewModel: DetailViewModelType{
    
    private var selectedIndexPath: IndexPath?
    private var person = Person()
    
    init(person: Person) {
        self.person = person
    }
    
    //Функция получения ячейки
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DetailViewCellViewModelType? {
        return DetailViewCellViewModel(person: person)
    }
    
    //Функция получения количества строк
    func numberOfRows() -> Int {
        return 3
    }
    
    //Функция получения IndexPath выбранной ячейки
    func selectRow(atIndexPath indexPath: IndexPath) {
        if indexPath.row == 1 {
            GlobalFunc.call(phone: person.phone)
        }
    }
    
    //Функция получения номера телефона
    func getPersonPhone() -> String {
        return person.phone
    }
}
