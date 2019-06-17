//
//  CustomVC.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 12/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class CustomVC: UITableViewCell {

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    
    weak var viewModel: TableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return}
            nameLable.text = viewModel.name
            phoneNumberLabel.text = viewModel.phone
            temperamentLabel.text = viewModel.temperament
        }
    }

}
