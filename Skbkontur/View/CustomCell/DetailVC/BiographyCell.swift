//
//  BiographyCell.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 12/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit

class BiographyCell: UITableViewCell {

    @IBOutlet weak var biographyLabel: UILabel!
    
    weak var viewModel: DetailViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else {return}
            biographyLabel.text = viewModel.biography
        }
    }
}
