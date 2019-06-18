//
//  TableViewModelType.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 15/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation
import RealmSwift

protocol TableViewViewModelType {
    
    func filteredPersons(searchText: String)
    
    func fetchPerson(url: [String], completion: @escaping ()->())
    
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType?
    
    func viewModelForSelectedRow() -> DetailViewModelType?
    func selectRow(atIndexPath indexPath: IndexPath)
    
    func getCountPerson() -> Int
}
