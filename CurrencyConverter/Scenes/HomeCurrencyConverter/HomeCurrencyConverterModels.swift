//
//  HomeCurrencyConverterModels.swift
//  CurrencyConverter
//
//  Created by Caio de Souza on 10/02/19.
//  Copyright (c) 2019 Caio de Souza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum HomeCurrencyConverter{
    // MARK: Use cases
  
    // MARK: Fetch Currencies
    enum FetchCurrencies{
        struct Request{
            let base: String
        }
    
        struct Response{
            let currentUserInputAmount: Decimal
            let currenciesData: CurrencyRevolutApiResponse
        }
    
        struct ViewModel{
            struct DisplayedRate{
                let currencyAbbreviation: String
                let currencyValue: Decimal
            }
            let rates: [DisplayedRate]
        }
    }
    
    // MARK: Update Currency Amount
    enum UpdateCurrencyAmount{
        struct Request{
            let amount: Decimal
        }
        
        struct Response{
            let currentUserInputAmount : Decimal
        }
        
        struct ViewModel{
            let currentUserInputAmount : Decimal
        }
    }
}