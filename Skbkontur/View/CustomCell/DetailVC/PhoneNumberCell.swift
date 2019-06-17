//
//  PhoneNumberCell.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 12/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class PhoneNumberCell: UITableViewCell {

    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var phoneLabel: UILabel!
    
    weak var viewModel: DetailViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return}
            phoneLabel.text = viewModel.phone
        }
    }
}
