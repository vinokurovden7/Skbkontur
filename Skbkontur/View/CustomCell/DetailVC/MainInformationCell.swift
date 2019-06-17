//
//  MainInformationCell.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 12/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class MainInformationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var educationPeriodLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    
    weak var viewModel: DetailViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return}
            nameLabel.text = viewModel.name
            educationPeriodLabel.text = viewModel.dateEducation
            temperamentLabel.text = viewModel.temperament
        }
    }
    
}
