//
//  HomeCurrencyConverterInteractor.swift
//  CurrencyConverter
//
//  Created by Caio de Souza on 10/02/19.
//  Copyright (c) 2019 Caio de Souza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
import Foundation

protocol HomeCurrencyConverterBusinessLogic{
    func doUpdateUserInputAmount(request: HomeCurrencyConverter.UpdateCurrencyAmount.Request)
    func doFetchCurrencies(request: HomeCurrencyConverter.FetchCurrencies.Request)
}


class HomeCurrencyConverterInteractor: HomeCurrencyConverterBusinessLogic{

    var presenter: HomeCurrencyConverterPresentationLogic?
    var worker: HomeCurrencyConverterWorker? = HomeCurrencyConverterWorker(service: HomeCurrencyConverterRestApi())
    var currentUserInputAmount: Decimal = 1.0
  
    // MARK: Do Fetch Currencies
    
    func doFetchCurrencies(request: HomeCurrencyConverter.FetchCurrencies.Request){
        self.worker?.doFetchCurrencies(base: request.base, successHandler: { (apiResponse) in
            
        let response = HomeCurrencyConverter.FetchCurrencies.Response(currentUserInputAmount: self.currentUserInputAmount,
                                                                      currenciesData: apiResponse)
        self.presenter?.presentCurrencies(response: response)
            
        }, failureHandler: { (error) in
            print("Error on \(#file) -> Function \(#function) -> \(error.localizedDescription)")
        })
    }
    
    // MARK: Do Update User Input Amount
    func doUpdateUserInputAmount(request: HomeCurrencyConverter.UpdateCurrencyAmount.Request) {
        currentUserInputAmount = request.amount
        let response = HomeCurrencyConverter.UpdateCurrencyAmount.Response(currentUserInputAmount: currentUserInputAmount)
        self.presenter?.presentUpdateUserInputAmount(response: response)
    }
    
}
