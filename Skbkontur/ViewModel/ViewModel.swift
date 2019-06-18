//
//  ViewModel.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 15/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation
import RealmSwift


class ViewModel: TableViewViewModelType {
    
    private var persons: Results<Person>!
    private var filteredPersons: Results<Person>!
    private var selectedIndexPath: IndexPath?
    private var isFiltering: Bool = false
    
    //Функция получения данных
    func fetchPerson(url: [String], completion: @escaping(Bool) -> ()){
        MainVC.countLoadUrls = 0
        for i in url {
            let loadFactory = LoadFactory.produseLoad()
            loadFactory.getDataPerson(url: i) { error in
                completion(error)
            }
        }
    }
    
    //Функция получения количества строк
    func numberOfRows() -> Int {
        let realm = try! Realm()
        persons = realm.objects(Person.self).sorted(byKeyPath: "name")
        if isFiltering {
            return filteredPersons?.count ?? 0
        }
        return persons?.count ?? 0
    }
    
    //Функция получения ячейки
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        var person = Person()
        if isFiltering {
            person = filteredPersons![indexPath.row]
        } else {
            person = persons![indexPath.row]
        }
        
        return TableViewCellViewModel(person: person)
    }
    
    //Функция формирования DetailView для выбранной ячейки
    func viewModelForSelectedRow() -> DetailViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else {return nil}
        if isFiltering {
            return DetailViewModel(person: filteredPersons![selectedIndexPath.row])
        }
        return DetailViewModel(person: persons![selectedIndexPath.row])
    }
    
    //Функция получения IndexPath выбранной ячейки
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    //Функция фильтрации данных во время поиска
    func filteredPersons(searchText: String) {
        isFiltering = searchText.count > 0
        self.filteredPersons = persons?.filter("name CONTAINS[c] %@ OR phone CONTAINS[c] %@", searchText ,searchText)
    }
    
    //Функция получения количества записей
    func getCountPerson() -> Int {
        let realm = try! Realm()
        persons = realm.objects(Person.self).sorted(byKeyPath: "name")
        if isFiltering {
            return filteredPersons?.count ?? 0
        }
        return persons?.count ?? 0
    }
    
    //Функция проверки даты последней загрузки данных
    func checkLastLoad() -> Bool {
        let realm = try! Realm()
        let lastLoadDate = realm.objects(LastLoadDate.self)
        if lastLoadDate.isEmpty {
            return true
        } else {
            return -(lastLoadDate.last!.lastDateTimeStart.timeIntervalSince(Date()) / 60) > 1
        }
    }
    
    //Функция записи даты последней загрузки данных
    func setLastLoad() {
        let lastLoadDate = LastLoadDate()
        lastLoadDate.id = "1"
        lastLoadDate.lastDateTimeStart = Date()
        StorageManage.saveObjectLastDateTime(lastLoadDate)
    }
}
