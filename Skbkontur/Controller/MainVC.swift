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
    
    let url1 = "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/generated-01.json"
    let url2 = "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/generated-02.json"
    let url3 = "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/generated-03.json"
    
    //Информация о загруженных данных 1 источника
    var countLoadingItems1 = 50
    var lastCountLoadingItems1 = 0
    var count1 = 0
    
    //Информация о загруженных данных 2 источника
    var countLoadingItems2 = 50
    var lastCountLoadingItems2 = 0
    var count2 = 0
    
    //Информация о загруженных данных 3 источника
    var countLoadingItems3 = 50
    var lastCountLoadingItems3 = 0
    var count3 = 0
    
    let formatter = DateFormatter()
    
    let queue1 = DispatchQueue.global(qos: .utility)
    let queue2 = DispatchQueue.global(qos: .utility)
    let queue3 = DispatchQueue.global(qos: .utility)
    
    //Объявление объекта refreshControl
    var refreshControl = UIRefreshControl()
    
    //Объявление индикатора загрузки
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .black
        return spinner
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var newPerson = Person()
    private var lastStart = LastStart()
    private var persons: Results<Person>!
    private var lastStarts: Results<LastStart>!
    private var filteredPersons: Results<Person>!
    
    private var searchBaIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBaIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRefreshControl()
        
        self.view.addSubview(self.loadingIndicator)
        formatter.dateFormat = "dd.MM.yyyy"
        
        persons = realm.objects(Person.self)
        lastStarts = realm.objects(LastStart.self)
        
        //Проверка на наличие данных в таблице Person
        if persons.count > 0 {
            //Проверка на наличие данных в таблице LastStart
            if lastStarts.count > 0 {
                //Проверка времени, с момента последней загрузки данных
                if  -(lastStarts.last!.lastDateTimeStart.timeIntervalSince(Date()) / 60) > 1 {
                    StorageManage.removeAllData()
                    lastStart.lastDateTimeStart = Date()
                    StorageManage.saveObjectLastDateTime(lastStart)
                    self.showLoader()
                    queue1.async{
                        self.getData1(url: self.url1)
                    }
                    queue2.async {
                        self.getData2(url: self.url2)
                    }
                    queue3.async {
                        self.getData3(url: self.url3)
                    }
                }
            } else {
                StorageManage.removeAllData()
                lastStart.lastDateTimeStart = Date()
                StorageManage.saveObjectLastDateTime(lastStart)
                self.showLoader()
                queue1.async{
                    self.getData1(url: self.url1)
                }
                queue2.async {
                    self.getData2(url: self.url2)
                }
                queue3.async {
                    self.getData3(url: self.url3)
                }
            }
        } else {
            self.showLoader()
            queue1.async{
                self.getData1(url: self.url1)
            }
            queue2.async {
                self.getData2(url: self.url2)
            }
            queue3.async {
                self.getData3(url: self.url3)
            }
        }
        
        //Настройка SearchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск по ФИО или тел."
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }
    
    //Обработка перехода
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let person: Person
            if isFiltering {
                person = filteredPersons.sorted(byKeyPath: "name")[indexPath.row]
            } else {
                person = persons.sorted(byKeyPath: "name")[indexPath.row]
            }
            let detailVC = segue.destination as! DetailVC
            detailVC.currentPerson = person
        }
    }
    
    //Загрузка данных из 1-го источника
    func getData1(url: String) {
        let session = URLSession.shared
        count1 = 0
        session.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data else {
                self.showError()
                self.hideLoader()
                self.countLoadingItems1 = 0
                return
            }
            DispatchQueue.main.async {
                do{
                    let array: [PersonModel] = try JSONDecoder().decode([PersonModel].self, from: data)
                    for dic : PersonModel in array {
                        if self.count1 < self.lastCountLoadingItems1 {
                            self.count1+=1
                            continue
                        } else {
                            
                            if self.count1 == self.countLoadingItems1 {
                                self.lastCountLoadingItems1 = self.countLoadingItems1
                                self.hideLoader()
                                return
                            }
                            
                            self.newPerson.id = dic.id ?? ""
                            self.newPerson.name = dic.name ?? ""
                            self.newPerson.phone = dic.phone ?? ""
                            self.newPerson.height = dic.height ?? 0.0
                            self.newPerson.temperament = dic.temperament ?? ""
                            self.newPerson.biography = dic.biography ?? ""
                            self.newPerson.educationPeriodStart = dic.educationPeriod?.start ?? ""
                            self.newPerson.educationPeriodEnd = dic.educationPeriod?.end ?? ""
                            
                            StorageManage.saveObjectsPerson(self.newPerson)
                            self.count1 += 1
                            self.tableView.reloadData()
                            self.newPerson = Person()
                        }
                        self.hideLoader()
                        self.refreshControl.endRefreshing()
                    }
                } catch let parceErr{
                    self.countLoadingItems1 = 0
                    self.showError()
                    self.hideLoader()
                    print(parceErr)
                }
            }
            
            }.resume()
        
    }
    
    //Загрузка данных из 2-го источника
    func getData2(url: String) {
        let session = URLSession.shared
        count2 = 0
        session.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data else {
                self.showError()
                self.hideLoader()
                self.countLoadingItems2 = 0
                return
            }
            DispatchQueue.main.async {
                do{
                    let array: [PersonModel] = try JSONDecoder().decode([PersonModel].self, from: data)
                    for dic : PersonModel in array {
                        if self.count2 < self.lastCountLoadingItems2 {
                            self.count2+=1
                            continue
                        } else {
                            
                            if self.count2 == self.countLoadingItems2 {
                                self.lastCountLoadingItems2 = self.countLoadingItems2
                                self.hideLoader()
                                return
                            }
                            
                            self.newPerson.id = dic.id ?? ""
                            self.newPerson.name = dic.name ?? ""
                            self.newPerson.phone = dic.phone ?? ""
                            self.newPerson.height = dic.height ?? 0.0
                            self.newPerson.temperament = dic.temperament ?? ""
                            self.newPerson.biography = dic.biography ?? ""
                            self.newPerson.educationPeriodStart = dic.educationPeriod?.start ?? ""
                            self.newPerson.educationPeriodEnd = dic.educationPeriod?.end ?? ""
                            
                            StorageManage.saveObjectsPerson(self.newPerson)
                            self.count2 += 1
                            self.tableView.reloadData()
                            self.newPerson = Person()
                        }
                        self.hideLoader()
                        self.refreshControl.endRefreshing()
                    }
                } catch let parceErr{
                    self.countLoadingItems2 = 0
                    self.showError()
                    self.hideLoader()
                    print(parceErr)
                }
            }
            
            }.resume()
        
    }
    
    //Загрузка данных из 3-го источника
    func getData3(url: String) {
        let session = URLSession.shared
        count3 = 0
        session.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data else {
                self.showError()
                self.hideLoader()
                self.countLoadingItems3 = 0
                return
            }
            DispatchQueue.main.async {
                do{
                    let array: [PersonModel] = try JSONDecoder().decode([PersonModel].self, from: data)
                    for dic : PersonModel in array {
                        if self.count3 < self.lastCountLoadingItems3 {
                            self.count3+=1
                            continue
                        } else {
                            
                            if self.count3 == self.countLoadingItems3 {
                                self.lastCountLoadingItems3 = self.countLoadingItems3
                                self.hideLoader()
                                return
                            }
                            
                            self.newPerson.id = dic.id ?? ""
                            self.newPerson.name = dic.name ?? ""
                            self.newPerson.phone = dic.phone ?? ""
                            self.newPerson.height = dic.height ?? 0.0
                            self.newPerson.temperament = dic.temperament ?? ""
                            self.newPerson.biography = dic.biography ?? ""
                            self.newPerson.educationPeriodStart = dic.educationPeriod?.start ?? ""
                            self.newPerson.educationPeriodEnd = dic.educationPeriod?.end ?? ""
                            
                            StorageManage.saveObjectsPerson(self.newPerson)
                            self.count3 += 1
                            self.tableView.reloadData()
                            self.newPerson = Person()
                        }
                        self.hideLoader()
                        self.refreshControl.endRefreshing()
                    }
                } catch let parceErr{
                    self.countLoadingItems3 = 0
                    self.showError()
                    self.hideLoader()
                    print(parceErr)
                }
            }
            
            }.resume()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                if indexPath.row + 20 >= (self.countLoadingItems1 + self.countLoadingItems2 + self.countLoadingItems3)  {
                    countLoadingItems1 += 50
                    countLoadingItems2 += 50
                    countLoadingItems3 += 50
                    DispatchQueue.main.async {
                        self.showLoader()
                        self.queue1.async{
                            self.getData1(url: self.url1)
                        }
                        self.queue2.async {
                            self.getData2(url: self.url2)
                        }
                        self.queue3.async {
                            self.getData3(url: self.url3)
                        }
                    }
                }
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
    
    //Обновление записей
    func addRefreshControl(){
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        refreshControl.tintColor = UIColor.black
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление данных ...")
    }
    
    @objc func refreshList(){
        DispatchQueue.main.async {
            self.lastCountLoadingItems1 = 0
            self.lastCountLoadingItems2 = 0
            self.lastCountLoadingItems3 = 0
            StorageManage.removeAllData()
            self.lastStart = LastStart()
            self.lastStart.lastDateTimeStart = Date()
            StorageManage.saveObjectLastDateTime(self.lastStart)
            self.tableView.reloadData()
            self.queue1.async{
                self.getData1(url: self.url1)
            }
            self.queue2.async {
                self.getData2(url: self.url2)
            }
            self.queue3.async {
                self.getData3(url: self.url3)
            }
        }
        
    }
    
    func showError(){
        self.errorView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.errorView.isHidden = true
        })
    }

}


//Расширение для работы с таблицей
extension MainVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPersons.count
        }
        return persons.isEmpty ? 0 : persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! CustomVC
        
        var person = Person()
        
        if isFiltering {
            person = filteredPersons.sorted(byKeyPath: "name")[indexPath.row]
        } else {
            person = persons.sorted(byKeyPath: "name")[indexPath.row]
        }
        
        cell.nameLable.text = person.name
        cell.phoneNumberLabel.text = person.phone
        cell.temperamentLabel.text = person.temperament
        
        
        return cell
    }
    
}

//Расширение для работы с поиском
extension MainVC: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchController.searchBar.text!)
    }
    
    private func filterContent(_ searchText: String){
        filteredPersons = persons.filter("name CONTAINS[c] %@ OR phone CONTAINS[c] %@", searchText ,searchText)
        tableView.reloadData()
    }
    
}
