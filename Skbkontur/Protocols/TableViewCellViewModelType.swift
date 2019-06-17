//
//  TableViewCellViewModelType.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 15/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation

protocol TableViewCellViewModelType: class {
    var name: String {get}
    var phone: String {get}
    var temperament: String {get}
}
