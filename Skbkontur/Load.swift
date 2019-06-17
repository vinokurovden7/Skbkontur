//
//  Load.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 15/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation
import RealmSwift

class LoadFactory {
    static func produseLoad() -> Load{
        return Load()
    }
}

class Load {
    
    private var newPerson = Person()
    private var viewModel: TableViewViewModelType?
    private var persons: [Person] = []
    
    func getData(url: String, reload: Bool, completion: @escaping (Bool) -> ()) {
        let session = URLSession.shared
        viewModel = ViewModel()
        //Информация о загруженных данных 1 источника
        guard let viewModel = self.viewModel else {return}
        let lastCountLoad = viewModel.getCountPerson()
        var count = 0
        let countLoad = lastCountLoad + 20
        DispatchQueue.global(qos: .utility).async {
            session.dataTask(with: URL(string: url)!) { (data, response, error) in
                do{
                    guard let data = data else {return}
                    let array: [PersonModel] = try JSONDecoder().decode([PersonModel].self, from: data)
                    for dicionary : PersonModel in array {
                        if count < lastCountLoad  && !reload {
                            count+=1
                            continue
                        } else {
                            if count == countLoad {
                                StorageManage.saveObjectsPerson(self.persons){
                                    completion(true)
                                }
                                return
                            }
                            count+=1
                            self.newPerson.id = dicionary.id
                            self.newPerson.name = dicionary.name
                            self.newPerson.phone = dicionary.phone
                            self.newPerson.height = dicionary.height
                            self.newPerson.temperament = dicionary.temperament
                            self.newPerson.biography = dicionary.biography
                            self.newPerson.educationPeriodStart = dicionary.educationPeriod.start
                            self.newPerson.educationPeriodEnd = dicionary.educationPeriod.end
                            
                            //StorageManage.saveObjectsPerson(self.newPerson)
                            self.persons.append(self.newPerson)
                            self.newPerson = Person()
                        }
                    }
                    completion(false)
                    
                } catch let error{
                    print(error)
                }
            }.resume()
        }
    }
}
