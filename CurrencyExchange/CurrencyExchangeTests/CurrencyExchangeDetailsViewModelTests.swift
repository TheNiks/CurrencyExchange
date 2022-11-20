//
//  CurrencyDetailsViewModelTests.swift
//  CurrencyExchangeTests
//
//  Created by Nikunj Modi on 20/11/22.
//

import XCTest
@testable import CurrencyExchange

class CurrencyDetailsViewModelTests: XCTestCase {
    var currencyExchangeDetailModel: CurrencyExchangeDetailsVM?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        currencyExchangeDetailModel = CurrencyExchangeDetailsVM()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        currencyExchangeDetailModel = nil
    }
    
    func testConvertCurrency() throws {
        guard let currencyExchangeDetailModel = currencyExchangeDetailModel else {
            return
        }
        let convertedValue = currencyExchangeDetailModel.convertCurrency(fromValue: 1.0, toValue: 1.0, valueToConvert: 2.0)
        
        XCTAssertNotNil(convertedValue)
        XCTAssertEqual(convertedValue, "2.000")
    }
    
    func testGetHistoricalDates() throws {
        guard let currencyExchangeDetailModel = currencyExchangeDetailModel else {
            return
        }
        
        let dates = currencyExchangeDetailModel.getHistoricalDates()
        XCTAssertNotNil(dates)
        XCTAssertEqual(dates.count, 2)
        
    }
    
    func testGetPopularCurrencySymbols() throws {
        guard let currencyExchangeDetailModel = currencyExchangeDetailModel else {
            return
        }
        
        let popularCurrency = currencyExchangeDetailModel.getPopularCurrencySymbols()
        XCTAssertNotNil(popularCurrency)
        XCTAssertGreaterThanOrEqual(popularCurrency.count, 10)
    }
    
    func testCreateOtherCurrencyData() throws {
        guard let currencyExchangeDetailModel = currencyExchangeDetailModel else {
            return
        }
        
        let rates = ["INR" : 1.0, "CAD": 2.0, "EUR": 3.0]
        let toArray = ["INR", "CAD"]
        
        let currencyData = currencyExchangeDetailModel.createOtherCurrencyData(toSymbols: toArray, ratesData: rates, fromSymbol: "EUR", valueToConvert: "2")
        
        XCTAssertNotNil(currencyData)
        XCTAssertEqual(currencyData.count, 2)

    }


    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
