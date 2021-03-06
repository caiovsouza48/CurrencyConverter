//
//  HomeCurrencyConverterWorkerTests.swift
//  CurrencyConverter
//
//  Created by Caio de Souza on 12/02/19.
//  Copyright (c) 2019 Caio de Souza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import CurrencyConverter
import XCTest
import enum Alamofire.Result

class HomeCurrencyConverterWorkerTests: XCTestCase{
    
    // MARK: Subject under test
    var sut: HomeCurrencyConverterWorker!
    static var testApiResponseRates: [String: Decimal]!
  
    // MARK: Test lifecycle
  
    override func setUp(){
        super.setUp()
        setupHomeCurrencyConverterWorker()
    }
  
    override func tearDown(){
        super.tearDown()
    }
    
    // MARK: Test setup
  
    func setupHomeCurrencyConverterWorker(){
        sut = HomeCurrencyConverterWorker(service: HomeCurrencyConverterServiceSpy())
    }
  
    
    // MARK: - Test doubles
    class HomeCurrencyConverterServiceSpy : HomeCurrencyConverterService{
        // MARK: Method call expectatios
        var doFetchCurrenciesCalled = false
        
        func doFetchCurrencies(base: String, completionHandler: @escaping CurrencyConverterRestAPICompletionHandler) {
            doFetchCurrenciesCalled = true
            completionHandler(Result<CurrencyRevolutApiResponse>.success(Seeds.Currencies.euroApiResponse))
            
        }
    }
    // MARK: Tests
  
    func testDoFetchCurrencies(){
        // Given
        let serviceSpy = sut.service as! HomeCurrencyConverterServiceSpy
    
        // When
        var fetchedRates : [String: Decimal] = [:]
        let expect = expectation(description: "Wait for doFetchCurrencies() to return")
        serviceSpy.doFetchCurrencies(base: "EUR", completionHandler: { (result) in
            fetchedRates = result.value?.rates ?? [:]
            expect.fulfill()
        })
        waitForExpectations(timeout: 1.1)
    
        // Then
        XCTAssert(serviceSpy.doFetchCurrenciesCalled, "Calling doFetchCurrencies() should ask the data store for a list of Currencies")
        XCTAssertEqual(fetchedRates.count, Seeds.Currencies.euroBasedRates.count, "doFetchCurrencies() should return a list of currencies")
    }
}

