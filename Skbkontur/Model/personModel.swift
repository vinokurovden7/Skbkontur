//
//  personModel.swift
//  Skbkontur
//
//  Created by Денис Винокуров on 12/06/2019.
//  Copyright © 2019 Денис Винокуров. All rights reserved.
//

import Foundation

struct PersonModel: Decodable {
    let id: String?
    let name: String?
    let phone: String?
    let height: Float?
    let biography: String?
    let temperament: String?
    let educationPeriod: EducationModel?
}

struct EducationModel: Decodable {
    let start: String?
    let end: String?
}
