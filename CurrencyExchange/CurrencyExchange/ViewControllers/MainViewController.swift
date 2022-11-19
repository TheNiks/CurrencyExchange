//
//  MainViewController.swift
//  CurrencyExchange
//
//  Created by Nikunj Modi on 18/11/22.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    func parseNetworkError(error: NetworkError) {
        var errorMessage = ""
        switch error {
        case .invalidURL(let message):
            errorMessage = message
        case .invalidResponse(let message):
            errorMessage = message
        case .decodingError(let message):
            errorMessage = message
        case .genericError(let message):
            errorMessage = message
        case .internetError(let message):
            errorMessage = message
        
        }
        
        showErrorView(errorMessage: errorMessage)
    }
    
    func showErrorView(errorMessage: String) {
        let errorDialogMessage = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorDialogMessage.addAction(ok)
        self.present(errorDialogMessage, animated: true, completion: nil)
    }
}
