//
//  GlobalFunc.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 18/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import UIKit
class GlobalFunc {
    
    static let urls = ["https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/generated-01.json",
                "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/generated-02.json",
                "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/generated-03.json"]
    
    //Функция для совершения вызова
    static func call(phone: String){
        guard let url = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: ""))") else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
