//
//  CurrencyExchangeDetailsVC.swift
//  CurrencyExchange
//
//  Created by Nikunj Modi on 20/11/22.
//

import UIKit
import RxSwift
import RxCocoa
import Charts

class CurrencyExchangeDetailsVC: MainViewController {

    @IBOutlet weak var historicalView: UIView!
    @IBOutlet weak var otherCurrencyView: UIView!
    @IBOutlet weak var innerView: UIView!
    
    var fromCurrencyValue: String = StringConstants.emptyString
    var fromCurrencyCode: String = StringConstants.emptyString
    var toCurrencyCode: String = StringConstants.emptyString
    var toCurrencyValue: String = StringConstants.emptyString
    
    let disposeBag = DisposeBag()
    
    private lazy var dataViewForOtherCurrencyData: CurrencyExchangeDataTableVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        var viewController = storyboard.instantiateViewController(withIdentifier: "CurrencyExchangeDataTableVC") as! CurrencyExchangeDataTableVC
        viewController.informationType = .otherCurrencyData
        self.add(asChildViewController: viewController, to: self.otherCurrencyView)
        return viewController
    }()
    
    private lazy var dataViewForHistoricalCurrencyData: CurrencyExchangeDataTableVC = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewController = storyboard.instantiateViewController(withIdentifier: "CurrencyExchangeDataTableVC") as! CurrencyExchangeDataTableVC
        viewController.informationType = .historicalData
        self.add(asChildViewController: viewController, to: historicalView)
        return viewController
    }()
    
    
    
    var currencyExchangeDetailViewModel = CurrencyExchangeDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        currencyExchangeDetailViewModel.getConvertedCurrency(fromSymbol: fromCurrencyCode, toSymbol: currencyExchangeDetailViewModel.getPopularCurrencySymbols(), valueToConvert: fromCurrencyValue)
        currencyExchangeDetailViewModel.getHistoricalCurrencyData(fromSymbol: fromCurrencyCode, toSymbol: toCurrencyCode, valueToConvert: fromCurrencyValue, convertedLatestValue: toCurrencyValue)
    }
    
    private func setupBindings() {

        currencyExchangeDetailViewModel
            .currencyModel
            .observe(on: MainScheduler.instance)
            .bind(to: dataViewForOtherCurrencyData.currencyData)
            .disposed(by: disposeBag)
        
        currencyExchangeDetailViewModel
            .historicalDataModel
            .observe(on: MainScheduler.instance)
            .bind(to: dataViewForHistoricalCurrencyData.historicalData)
            .disposed(by: disposeBag)
        
        currencyExchangeDetailViewModel.error.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [ weak self ]error in
                guard let self = self else { return }
                self.parseNetworkError(error: error)
                
            }).disposed(by: disposeBag)
       
    }
}
