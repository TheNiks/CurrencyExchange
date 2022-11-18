//
//  StringExtension.swift
//  CurrencyExchange
//
//  Created by Nikunj Modi on 19/11/22.
//

import Foundation

extension String {
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}
