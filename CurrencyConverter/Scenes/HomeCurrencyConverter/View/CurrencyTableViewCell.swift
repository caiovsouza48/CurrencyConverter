//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Caio de Souza on 10/02/19.
//  Copyright © 2019 Caio de Souza. All rights reserved.
//

import UIKit

protocol CurrencyTableViewCellDelegate : class{
    func didTapTextFieldForCell(_ cell: CurrencyTableViewCell)
    func didEditTextFieldForCell(_ cell: CurrencyTableViewCell)
}

class CurrencyTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var currencyAbreviationLabel: UILabel!
    @IBOutlet weak var currencyAmountTextField: UICurrencyTextField!
    @IBOutlet weak var currencyFullNameLabel: UILabel!
    @IBOutlet weak var textBottomLineView: UIView!
    weak var delegate: CurrencyTableViewCellDelegate?
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.countryImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        countryImageView.layer.cornerRadius = countryImageView.frame.width / 2.0
        countryImageView.clipsToBounds = true
        currencyAmountTextField.delegate = self
        currencyAmountTextField.currencyTextFieldDelegate = self
    }
    
    func config(withRate rate: HomeCurrencyConverter.FetchCurrencies.ViewModel.DisplayedRate){
        countryImageView.image = UIImage(named: rate.currencyAbbreviation.lowercased())
        currencyAbreviationLabel.text = rate.currencyAbbreviation
        let currencyLocale = Locale(identifier: rate.currencyAbbreviation)
        currencyFullNameLabel.text = (currencyLocale as NSLocale).displayName(forKey:NSLocale.Key.currencyCode, value: rate.currencyAbbreviation)
        // Currency Format
        if rate.currencyValue == 0.0{
            currencyAmountTextField.textColor = UIColor.lightGray
        }
        currencyAmountTextField.text = formattedForCurrency(decimalValue: rate.currencyValue)
    }
    
    func formattedForCurrency(decimalValue: Decimal) -> String?{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        formatter.currencyDecimalSeparator = NSLocale.current.decimalSeparator
        return formatter.string(for: decimalValue)
    }
}

// MARK: UITextFieldDelegate
extension CurrencyTableViewCell : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textBottomLineView.backgroundColor = UIColor(red: 247/255.0,
                                                     green: 114/255.0,
                                                     blue: 116/255.0,
                                                     alpha: 1.0)
        if let currencyTextField = textField as? UICurrencyTextField{
            currencyTextField.canResign = false
            delegate?.didTapTextFieldForCell(self)
            delegate?.didEditTextFieldForCell(self)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        textBottomLineView.backgroundColor = UIColor(red: 125/255.0,
                                                     green: 122/255.0,
                                                     blue: 119/255.0,
                                                     alpha: 1.0)
        if let currencyTextField = textField as? UICurrencyTextField{
            currencyTextField.canResign = true
        }
    }
}

// MARK: CurrencyTextFieldDelegate
extension CurrencyTableViewCell : CurrencyTextFieldDelegate{
    func didFinishEditingChanged() {
        delegate?.didEditTextFieldForCell(self)
    }

}
