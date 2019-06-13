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
    
    var phoneNumber: String = ""

    let formatter = DateFormatter()
    var currentPerson:Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "dd.MM.yyyy"
        
    }
    
    @IBAction func phoneButton(_ sender: UIButton) {
        call()
    }
    
    func getDate(strDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from:strDate)!
        return formatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            call()
        } else {
           
        }
    }
    
    func call(){
        guard let url = URL(string: "tel://\(phoneNumber.replacingOccurrences(of: " ", with: ""))") else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}

extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainIformationCell") as! MainInformationCell
            cell.nameLabel.text = currentPerson?.name
            cell.educationPeriodLabel.text = "\(getDate(strDate: currentPerson!.educationPeriodStart)) - \(getDate(strDate: currentPerson!.educationPeriodEnd))"
            cell.temperamentLabel.text = currentPerson?.temperament
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneNuberCell") as! PhoneNumberCell
            cell.phoneLabel.text = currentPerson?.phone
            phoneNumber = currentPerson!.phone
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BiographyCell") as! BiographyCell
            cell.biographyLabel.text = currentPerson?.biography
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainIformationCell") as! MainInformationCell
            return cell
        }
    }
    
    
}
