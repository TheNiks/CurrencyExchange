//
//  CurrencyExchangeVC.swift
//  CurrencyExchange
//
//  Created by Nikunj Modi on 18/11/22.
//

import UIKit
import RxCocoa
import RxSwift

class CurrencyExchangeVC: MainViewController {

    @IBOutlet weak var exchangeCard: UIView!
    @IBOutlet weak var fromDropDown: PickerTextField!
    @IBOutlet weak var toDropDown: PickerTextField!
    
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var convertedCurrencyTextField: UITextField!
    @IBOutlet weak var inputCurrencyTextField: UITextField!
    
    var currencyExchangeViewModel = CurrencyExchangeVM()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exchangeCard.layer.cornerRadius = 10.0
        self.title = "CURRENCY_CONVERTER_TITLE".localized(withComment: "Currency Converter title")
        self.detailsButton.setTitle("DETAILS".localized(), for: .normal)
        self.swapButton.setTitle("", for: .normal)
        self.detailsButton.isEnabled = false
        self.setupViewModelBindings()
        self.currencyExchangeViewModel.getValidCurrencySymbols()
        self.inputCurrencyTextField.inputAccessoryView = toolBar()
        fromDropDown.tintColor = .white
    }
    

    func toolBar() -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor(red: 60/255, green: 79/255, blue: 94/255, alpha: 0.8)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "DONE_BUTTON_TITLE".localized(), style: .done, target: self, action: #selector(doneButtonPressed))
        let cancelButton = UIBarButtonItem(title: "CANCEL_BUTTON_TITLE".localized(), style: .plain, target: self, action: #selector(cancelButtonPressed))
        doneButton.tintColor = .white
        cancelButton.tintColor = .white
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc func doneButtonPressed(){
        self.inputCurrencyTextField.endEditing(true)
    }

    @objc func cancelButtonPressed(){
        self.inputCurrencyTextField.endEditing(true)
    }
    
    func setupViewModelBindings() {
        
        currencyExchangeViewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        currencyExchangeViewModel.currencySymbols
        .observe(on: MainScheduler.instance)
        .bind(to: fromDropDown.pickerItems)
        .disposed(by: disposeBag)

        currencyExchangeViewModel.currencySymbols.observe(on: MainScheduler.instance)
            .bind(to: toDropDown.pickerItems)
            .disposed(by: disposeBag)
        
        currencyExchangeViewModel.convertedValue.observe(on: MainScheduler.instance)
            .bind(to: convertedCurrencyTextField.rx.text)
            .disposed(by: disposeBag)
        
        currencyExchangeViewModel.convertedValue.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [ weak self ] value in
                guard let self = self else { return }
                self.detailsButton.isEnabled = true
            })
            .disposed(by: disposeBag)
        
        currencyExchangeViewModel.currencySymbols.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
            self.callCurrencyConversionAPI()
                
            }).disposed(by: disposeBag)
        
        inputCurrencyTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext:{ [weak self] in
                guard let self = self else { return }
                self.callCurrencyConversionAPI()
            }).disposed(by: disposeBag)
        
        currencyExchangeViewModel.error.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self ] error in
                guard let self = self else { return }
                self.parseNetworkError(error: error)
                
            }).disposed(by: disposeBag)
        
        fromDropDown.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.callCurrencyConversionAPI()
            }).disposed(by: disposeBag)
        
        toDropDown.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.callCurrencyConversionAPI()
            }).disposed(by: disposeBag)
        
        let _ = swapButton.rx.tap.bind {
            let temp = self.fromDropDown.text
            self.fromDropDown.text = self.toDropDown.text
            self.toDropDown.text = temp
            
            self.inputCurrencyTextField.text = "1"
            self.callCurrencyConversionAPI()
        }
        
        let _ = detailsButton.rx.tap.bind {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            // Instantiate View Controller
            let viewController = storyboard.instantiateViewController(withIdentifier: "CurrencyExchangeDetailsVC") as! CurrencyExchangeDetailsVC
            viewController.fromCurrencyCode = self.fromDropDown.text!
            viewController.fromCurrencyValue = self.inputCurrencyTextField.text!
            viewController.toCurrencyCode = self.toDropDown.text!
            viewController.toCurrencyValue = self.convertedCurrencyTextField.text!

            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        
    }
    
    func callCurrencyConversionAPI() {
        currencyExchangeViewModel.getConvertedCurrency(fromSymbol: fromDropDown.text!, toSymbol: toDropDown.text!, valueToConvert: inputCurrencyTextField.text!)
    }

}
