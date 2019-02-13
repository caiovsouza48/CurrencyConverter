//
//  Seeds.swift
//  CurrencyConverterTests
//
//  Created by Caio de Souza on 12/02/19.
//  Copyright © 2019 Caio de Souza. All rights reserved.
//
@testable import CurrencyConverter
import XCTest


struct Seeds {
    struct Currencies {
        static let euroBase = "EUR"
        static let date = "2018-09-06"
        static let euroBasedRates : [String : Decimal] = [
        "AUD" : 1.61,
        "BGN" : 1.96,
        "BRL" : 4.8022, // sad reactions :(
        "CAD" : 1.5371,
        "CHF" : 1.1299,
        "CNY" : 7.9623,
        "CZK" : 25.771,
        "DKK" : 7.4728,
        "GBP" : 0.90018,
        "HKD" : 9.1521,
        "HRK" : 7.450,
        "HUF" : 327.2,
        "IDR" : 17361.0,
        "ILS" : 4.1796,
        "INR" : 83.899,
        "ISK" : 128.08,
        "JPY" : 129.83,
        "KRW" : 1307.6,
        "MXN" : 22.414,
        "MYR" : 4.8224,
        "NOK" : 9.7971,
        "NZD" : 1.7671,
        "PHP" : 62.727,
        "PLN" : 4.3276,
        "RON" : 4.6485,
        "RUB" : 79.747,
        "SEK" : 10.614,
        "SGD" : 1.60,
        "THB" : 38.2,
        "TRY" : 7.64,
        "USD" : 1.16,
        "ZAR" : 17.8
        ]
        
        static let euroApiResponse = CurrencyRevolutApiResponse(base: euroBase, date: date, rates: euroBasedRates)
        static let euroDisplayedRates = Seeds.Currencies.euroApiResponse.rates.map { (arg) -> HomeCurrencyConverter.FetchCurrencies.ViewModel.DisplayedRate in
            let (key, value) = arg
            return HomeCurrencyConverter.FetchCurrencies.ViewModel.DisplayedRate(
                currencyAbbreviation: key,
                currencyValue: value * 1.0)
        }
    }
}
