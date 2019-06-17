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

    private let realm = try! Realm()
    //private var persons: [Person]?
    private var persons: Results<Person>!
    private var filteredPersons: Results<Person>!
    //private let load = Load()
    private var selectedIndexPath: IndexPath?
    private var newPerson = Person()
    private var isFiltering: Bool = false
    
    func fetchPerson(url: [String], reload: Bool, completion: @escaping(Bool) -> ()){
        for i in url {
            let loadFactory = LoadFactory.produseLoad()
            loadFactory.getData(url: i, reload: reload) { loads in
                completion(loads)
            }
        }
        
//        load.getData(urls: url) {
//        //self.persons = self.realm.objects(Person.self)
//            completion()
//        }
    }
    
    func numberOfRows() -> Int {
        persons = realm.objects(Person.self)
        if isFiltering {
            return filteredPersons?.count ?? 0
        }
        return persons?.count ?? 0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelType? {
        var person = Person()
        if isFiltering {
            person = filteredPersons!.sorted(byKeyPath: "name")[indexPath.row]
        } else {
            person = persons!.sorted(byKeyPath: "name")[indexPath.row]
        }
        
        return TableViewCellViewModel(person: person)
    }
    
    func viewModelForSelectedRow() -> DetailViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else {return nil}
        if isFiltering {
            return DetailViewModel(person: filteredPersons!.sorted(byKeyPath: "name")[selectedIndexPath.row])
        }
        return DetailViewModel(person: persons!.sorted(byKeyPath: "name")[selectedIndexPath.row])
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func filteredPersons(searchText: String) {
        isFiltering = searchText.count > 0
        self.filteredPersons = persons?.sorted(byKeyPath: "name").filter("name CONTAINS[c] %@ OR phone CONTAINS[c] %@", searchText ,searchText)
    }
    
    func getCountPerson() -> Int {
        persons = realm.objects(Person.self)
        if isFiltering {
            return filteredPersons?.count ?? 0
        }
        return persons?.count ?? 0
    }
}
