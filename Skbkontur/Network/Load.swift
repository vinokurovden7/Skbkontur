//
//  Load.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 15/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation
import RealmSwift

class Load {
    
    private var newPerson = Person()
    private var viewModel: TableViewViewModelType?
    private var persons: [Person] = []
    
    //Функция получения данных из url
    func getDataPerson(url: String, completion: @escaping (Bool) -> ()) {
        let session = URLSession.shared
        DispatchQueue.global(qos: .utility).async {
            session.dataTask(with: URL(string: url)!) { (data, response, error) in
                do{
                    guard let data = data else {return}
                    let array: [PersonModel] = try JSONDecoder().decode([PersonModel].self, from: data)
                    for dicionary : PersonModel in array {
                        
                        self.newPerson.id = dicionary.id
                        self.newPerson.name = dicionary.name
                        self.newPerson.phone = dicionary.phone
                        self.newPerson.height = dicionary.height
                        self.newPerson.temperament = dicionary.temperament
                        self.newPerson.biography = dicionary.biography
                        self.newPerson.educationPeriodStart = dicionary.educationPeriod.start
                        self.newPerson.educationPeriodEnd = dicionary.educationPeriod.end
                        
                        self.persons.append(self.newPerson)
                        self.newPerson = Person()
                    }
                    //Запись полученного массива в Realm
                    StorageManage.saveObjectsPerson(self.persons){
                        completion(false)
                    }
                    
                } catch let error{
                    MainVC.countLoadUrls+=1
                    completion(true)
                    print(error)
                }
            }.resume()
        }
    }
}
