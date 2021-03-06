//
//  HomeCurrencyConverterPresenter.swift
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

protocol HomeCurrencyConverterPresentationLogic{
    func presentCurrencies(response: HomeCurrencyConverter.FetchCurrencies.Response)
    func presentUpdateUserInputAmount(response: HomeCurrencyConverter.UpdateCurrencyAmount.Response)
}

class HomeCurrencyConverterPresenter: HomeCurrencyConverterPresentationLogic{
    weak var viewController: HomeCurrencyConverterDisplayLogic?
  
    // MARK: Present Currencies
  
    func presentCurrencies(response: HomeCurrencyConverter.FetchCurrencies.Response){
        let displayedRates = response.currenciesData.rates.map { (arg) -> HomeCurrencyConverter.FetchCurrencies.ViewModel.DisplayedRate in
            let (key, value) = arg
            return HomeCurrencyConverter.FetchCurrencies.ViewModel.DisplayedRate(
                currencyAbbreviation: key,
                currencyValue: value * response.currentUserInputAmount)
        }
        let viewModel = HomeCurrencyConverter.FetchCurrencies.ViewModel(rates: displayedRates)
        viewController?.displayCurrencies(viewModel: viewModel)
    }
    
    // MARK: UpdateUserInputAmount
    func presentUpdateUserInputAmount(response: HomeCurrencyConverter.UpdateCurrencyAmount.Response){
        let viewModel = HomeCurrencyConverter.UpdateCurrencyAmount.ViewModel(currentUserInputAmount: response.currentUserInputAmount)
        viewController?.displayUserInputAmount(viewModel: viewModel)
    }
}
