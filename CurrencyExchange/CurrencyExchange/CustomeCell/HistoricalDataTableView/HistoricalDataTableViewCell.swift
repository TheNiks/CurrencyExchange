//
//  HistoricalDataTableViewCell.swift
//  CurrencyExchange
//
//  Created by Nikunj Modi on 20/11/22.
//

import UIKit

class HistoricalDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    public var cellModel : HistoricalDataModel! {
        didSet {
            self.dateLabel.text = StringConstants.onKey + StringConstants.emptySpaceString + cellModel.dateString
            self.valueLabel.text = cellModel.fromCurrencyValue + StringConstants.emptySpaceString + cellModel.fromCurrencySymbol + StringConstants.epsilonString + cellModel.toCurrencyValue + StringConstants.emptySpaceString + cellModel.toCurrencySymbol
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        dateLabel.text = StringConstants.emptyString
        valueLabel.text = StringConstants.emptyString
    }

}
