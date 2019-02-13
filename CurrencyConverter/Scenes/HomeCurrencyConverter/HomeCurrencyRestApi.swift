//
//  homeCurrencyRestApi.swift
//  CurrencyConverter
//
//  Created by Caio de Souza on 10/02/19.
//  Copyright © 2019 Caio de Souza. All rights reserved.
//

import Foundation
import Alamofire

class HomeCurrencyConverterRestApi: HomeCurrencyConverterService{
    
    func doFetchCurrencies(base: String, completionHandler: @escaping CurrencyConverterRestAPICompletionHandler) {
        Alamofire.request("https://revolut.duckdns.org/latest?base=\(base)")
            .responseData { response in
                debugPrint(response)
                let decoder = JSONDecoder()
                let result: Result<CurrencyRevolutApiResponse> = decoder.decodeResponse(from: response)
                completionHandler(result)
        }
        
    }
    
    
}
