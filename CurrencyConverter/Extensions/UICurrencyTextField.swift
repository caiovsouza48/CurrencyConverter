//
//  UICurrencyTextField.swift
//  CurrencyConverter
//
//  Created by Caio de Souza on 11/02/19.
//  Copyright © 2019 Caio de Souza. All rights reserved.
//

import Foundation
import UIKit

// Extensions
extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
extension Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
}
extension String {
    var digits: [UInt8] {
        return map(String.init).compactMap(UInt8.init)
    }
}
extension Collection where Element == UInt8 {
    var string: String { return map(String.init).joined() }
    var decimal: Decimal { return Decimal(string: string) ?? 0 }
}
extension Decimal {
    var number: NSDecimalNumber { return NSDecimalNumber(decimal: self) }
}

protocol CurrencyTextFieldDelegate : class{
    func didFinishEditingChanged()
}

// MARK: Currency Text Field
class UICurrencyTextField: UITextField {
    
    
    var string: String {
        return text ?? ""
        
    }
    var decimal: Decimal {
        return string.digits.decimal /
            Decimal(pow(10, Double(Formatter.currency.maximumFractionDigits)))
    }
    var decimalNumber: NSDecimalNumber {
        return decimal.number
        
    }
    var doubleValue: Double {
        return decimalNumber.doubleValue
        
    }
    
    var integerValue: Int {
        return decimalNumber.intValue
        
    }
    let maximum: Decimal = 999_999_999.99
    var formatter : NumberFormatter!
    private var lastValue: String?
    
    // Unresignable
    var canResign : Bool = true
    
    // Delegate
    weak var currencyTextFieldDelegate : CurrencyTextFieldDelegate?
    
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder() && canResign
    }
    
    
    override func willMove(toSuperview newSuperview: UIView?) {
        // Setting Up FOrmatter
        formatter = NumberFormatter(numberStyle: .currency)
        formatter.currencySymbol = ""
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        keyboardType = .numberPad
        textAlignment = .center
        editingChanged()
    }
    override func deleteBackward() {
        text = string.digits.dropLast().string
        editingChanged()
    }
    
    @objc func editingDidBegin(_ textField: UITextField? = nil){
        textAlignment = .right
    }
    
    
    @objc func editingChanged(_ textField: UITextField? = nil) {
        guard decimal <= maximum else {
            text = lastValue
            return
        }
        let formatter = Formatter.currency
        formatter.currencySymbol = ""
        text = formatter.string(for: decimal)
        lastValue = text
        currencyTextFieldDelegate?.didFinishEditingChanged()
    }
    
    @objc func editingDidEnd(_ textField: UITextField? = nil){
        textAlignment = .center
    }
}
