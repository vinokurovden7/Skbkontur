//
//  DetailViewModelType.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 15/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation

protocol DetailViewModelType {    
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> DetailViewCellViewModelType?
    
    func viewModelForSelectedRow()
    func selectRow(atIndexPath indexPath: IndexPath)
    
    func getPersonPhone() -> String
}
