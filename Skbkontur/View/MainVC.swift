//
//  MainVC.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 12/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
import RealmSwift

class MainVC: UIViewController {
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    static var countLoadUrls = 0
    
    //Поиск
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBaIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBaIsEmpty
    }
    
    private var viewModel: TableViewViewModelType?
    //Объявление индикатора загрузки
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .black
        return spinner
    }()
    //Объявление объекта refreshControl
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Настройка SearchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по ФИО или тел."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //Добавление на view loadingIndicator
        self.view.addSubview(self.loadingIndicator)
        viewModel = ViewModel()
        addRefreshControl()
        checkLastLoad()
    }
    
    //Функция загрузки данных
    private func getData(loader: Bool){
        guard let viewModel = self.viewModel else {return}
        MainVC.countLoadUrls = 0
        if loader {
            showLoader()
        }
        viewModel.fetchPerson(url: GlobalFunc.urls) { error in
            if error {
                self.showError()
            }
            //Если данные со всех url загружены
            if MainVC.countLoadUrls == GlobalFunc.urls.count - 1 {
                self.hideLoader()
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    viewModel.setLastLoad()
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //Функция проверки даты последней загрузки данных
    private func checkLastLoad(){
        guard let viewModel = self.viewModel else {return}
        if viewModel.checkLastLoad() {
            getData(loader: true)
        }
    }
    
    //Добавление RefreshControl
    func addRefreshControl(){
        DispatchQueue.main.async {
            self.tableView.addSubview(self.refreshControl)
            self.refreshControl.addTarget(self, action: #selector(self.refreshList), for: .valueChanged)
            self.refreshControl.tintColor = UIColor.black
            self.refreshControl.attributedTitle = NSAttributedString(string: "Обновление данных ...")
        }
    }
    
    //Функция при срабатывании refreshList
    @objc func refreshList(){
        if !isFiltering && !loadingIndicator.isAnimating {
            getData(loader: false)
        } else {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    //Функция показа лоадера
    func showLoader(){
        DispatchQueue.main.async(){
            self.view.addSubview(self.loadingIndicator)
            self.loadingIndicator.startAnimating()
            NSLayoutConstraint.activate([self.loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                         self.loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
            self.view.bringSubviewToFront(self.loadingIndicator)
        }
    }
    
    //Функция скрытия лоадера
    func hideLoader(){
        DispatchQueue.main.async(){
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.removeFromSuperview()
        }
    }
    
    //Обработчик перехода
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier, let viewModel = viewModel else {return}

        if identifire == "detail" {
            if let dvc = segue.destination as? DetailVC {
                dvc.viewModel = viewModel.viewModelForSelectedRow()
            }
        }
    }
    
    //Функция показа сообщения с ошибкой
    func showError(){
        DispatchQueue.main.async {
            self.errorView.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.errorView.isHidden = true
        })
    }

}

//Расширение для работы с таблицей
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {return 0}
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? CustomVC
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {return}
        
        viewModel.selectRow(atIndexPath: indexPath)
        performSegue(withIdentifier: "detail", sender: nil)
    }
    
}

//Расширение для работы с поиском
extension MainVC: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchController.searchBar.text!)
    }
    
    private func filterContent(_ searchText: String){
        viewModel?.filteredPersons(searchText: searchText)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
