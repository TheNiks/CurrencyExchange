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
import Highcharts

class CurrencyExchangeDetailsVC: MainViewController {

    @IBOutlet weak var historicalView: UIView!
    @IBOutlet weak var otherCurrencyView: UIView!
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var chartBaseView: UIView!
    var chartView: HIChartView!
    
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
        
        currencyExchangeDetailViewModel
            .historicalDataModel
            .observe(on: MainScheduler.instance)
            .bind { model in
                self.addChart(historicalData: model)
            }
            .disposed(by: disposeBag)
       
    }
}

extension CurrencyExchangeDetailsVC {
    func addChart(historicalData: [HistoricalDataModel]) {
       chartView = HIChartView(frame: CGRect(x: chartBaseView.bounds.origin.x+10,
                                                  y: chartBaseView.bounds.origin.y+10,
                                                  width: chartBaseView.bounds.size.width-20,
                                              height: chartBaseView.frame.height-20))
        
       let formateData = historicalData.map { [$0.dateString, Double($0.toCurrencyValue) ?? 0.0] }
       let options = HIOptions()

       let chart = HIChart()
       chart.type = "column"
       options.chart = chart

       let exporting = HIExporting()
       exporting.enabled = false
       options.exporting = exporting

       let title = HITitle()
       title.text = "3 days Historical Data"
       options.title = title

       let xAxis = HIXAxis()
       xAxis.type = "category"
       xAxis.labels = HILabels()
       xAxis.labels.rotation = -45
       xAxis.labels.style = HICSSObject()
       xAxis.labels.style.fontSize = "8px"
       xAxis.labels.style.fontFamily = "Verdana, sans-serif"
       options.xAxis = [xAxis]

       let yAxis = HIYAxis()
       yAxis.min = 0
       yAxis.title = HITitle()
       yAxis.title.text = "Currency Rate"
       options.yAxis = [yAxis]

       let legend = HILegend()
       legend.enabled = false
       options.legend = legend

       let tooltip = HITooltip()
       tooltip.pointFormat = "Currency Rate: <b>{point.y:.3f}</b>"
       options.tooltip = tooltip

       let historical = HIColumn()
       historical.data = formateData as [Any]

       options.series = [historical]
       chartView.options = options
       chartBaseView.addSubview(chartView)
    }
}
