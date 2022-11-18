//
//  CurrencyExchangeVC.swift
//  CurrencyExchange
//
//  Created by Nikunj Modi on 18/11/22.
//

import UIKit

class CurrencyExchangeVC: MainViewController {

    @IBOutlet weak var exchangeCard: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        exchangeCard.layer.cornerRadius = 10.0
        self.title = "CURRENCY_CONVERTER_TITLE".localized(withComment: "Currency Converter title")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
