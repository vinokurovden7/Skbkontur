//
//  DetailVC.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 12/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

class DetailVC: UIViewController {
    
    var viewModel: DetailViewModelType?
    
    //Обработчик нажатия на значок телефона
    @IBAction func phoneButton(_ sender: UIButton) {
        guard let viewModel = viewModel else {return}
        GlobalFunc.call(phone: viewModel.getPersonPhone())
    }

}

//Расширение для работы с таблицей
extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainIformationCell") as? MainInformationCell
            guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
            let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneNuberCell") as? PhoneNumberCell
            guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
            let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BiographyCell") as? BiographyCell
            guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
            let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainIformationCell") as? MainInformationCell
            guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
            let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
            tableViewCell.viewModel = cellViewModel
            return tableViewCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {return}
        viewModel.selectRow(atIndexPath: indexPath)
    }
    
}
