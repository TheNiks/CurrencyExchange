//
//  PickerTextField.swift
//  CurrencyExchange
//
//  Created by Nikunj Modi on 20/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class PickerTextField: UITextField {

    private let pickerView = UIPickerView(frame: .zero)
    private let disposeBag = DisposeBag()
    public var pickerItems: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    public private(set) var toolbar: UIToolbar?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBindings()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupBindings()
    }
    
    private func commonInit() {
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.barTintColor = UIColor(red: 60/255, green: 79/255, blue: 94/255, alpha: 0.8)
            toolBar.sizeToFit()
        
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            let label = UILabel(frame: .zero)
            label.text = "Currency Code".localized()
            label.textAlignment = .center
            label.textColor = .white
            let customBarButton = UIBarButtonItem(customView: label)
            toolBar.setItems([space, customBarButton, space], animated: false)
            toolBar.isUserInteractionEnabled = true

            self.toolbar = toolBar
            self.inputAccessoryView = toolBar
    }
    
    func setupBindings() {
        self.inputView = pickerView
        self.commonInit()
        pickerItems.bind(to: self.pickerView.rx.itemTitles) { (row, element) in
            return element
        }.disposed(by: disposeBag)
        
        
        let _ = pickerView.rx.itemSelected
            .subscribe(onNext: { (row, value) in
                self.text = self.pickerItems.value[row]
                self.resignFirstResponder()
            })
    }
}
