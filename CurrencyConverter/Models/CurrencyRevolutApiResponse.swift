//
//  CurrencyRevolutApiResponse.swift
//  CurrencyConverter
//
//  Created by Caio de Souza on 10/02/19.
//  Copyright © 2019 Caio de Souza. All rights reserved.
//

import UIKit

struct CurrencyRevolutApiResponse : Codable, CustomStringConvertible {
    let base: String
    let date: String
    let rates: [String: Decimal]
    
    var description: String{
        return "****** CurrencyRevolutApiResponse Object *****\nBase: \(base)\nDate: \(date)\nRates:\(rates)"
    }
}
