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
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DetailViewCellViewModelType? {
        return DetailViewCellViewModel(person: person)
    }
    
    func numberOfRows() -> Int {
        return 3
    }
    
    func viewModelForSelectedRow() {
        guard let selectedIndexPath = selectedIndexPath else {return}
        if selectedIndexPath.row == 1 {
            GlobalFunc.call(phone: person.phone)
        }
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func getPersonPhone() -> String {
        return person.phone
    }
    
//    //Функция для совершения вызова
//    public func call(){
//        guard let url = URL(string: "tel://\(person.phone.replacingOccurrences(of: " ", with: ""))") else {return}
//        if UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
//    }
}
