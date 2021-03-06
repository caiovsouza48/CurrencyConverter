//
//  HomeCurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Caio de Souza on 10/02/19.
//  Copyright (c) 2019 Caio de Souza. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeCurrencyConverterDisplayLogic: class{
    func displayCurrencies(viewModel: HomeCurrencyConverter.FetchCurrencies.ViewModel)
    func displayUserInputAmount(viewModel: HomeCurrencyConverter.UpdateCurrencyAmount.ViewModel)
}

class HomeCurrencyConverterViewController: UIViewController, HomeCurrencyConverterDisplayLogic{

    var interactor: HomeCurrencyConverterBusinessLogic?
    var timer: Timer!
    var rates: [HomeCurrencyConverter.FetchCurrencies.ViewModel.DisplayedRate] = []
    var currentBase: String = "EUR"
    var isEditingARow: Bool = false
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: Setup
  
    private func setup(){
        let viewController = self
        let interactor = HomeCurrencyConverterInteractor()
        let presenter = HomeCurrencyConverterPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
  
  
    // MARK: View lifecycle
  
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.register(CurrencyTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        setupTimer()
    }
    
    // MARK: Timer Setup
    func setupTimer(){
        timer = Timer(timeInterval: 1.0, repeats: true, block: { (timer) in
            self.doFetchCurrencies(base: self.currentBase)
        })
        // Save some Battery
        timer.tolerance = 0.2
        RunLoop.current.add(timer, forMode: .common)
    }
  
    // MARK: Do Fetch Currencies

  
    func doFetchCurrencies(base: String){
        let request = HomeCurrencyConverter.FetchCurrencies.Request(base: self.currentBase)
        self.interactor?.doFetchCurrencies(request: request)
        
    }
  
    func displayCurrencies(viewModel: HomeCurrencyConverter.FetchCurrencies.ViewModel){
        self.rates = viewModel.rates
        updateRows()
        
    }
    
    // MARK: Display User Amount Input
    func displayUserInputAmount(viewModel: HomeCurrencyConverter.UpdateCurrencyAmount.ViewModel) {
        self.rates = self.rates.map {
            HomeCurrencyConverter.FetchCurrencies.ViewModel.DisplayedRate(
                currencyAbbreviation: $0.currencyAbbreviation,
                currencyValue: $0.currencyValue * viewModel.currentUserInputAmount)
        }
        updateRows()
    }
    
    // MARK: Utilities Functions
    
    /// Update All Rows Except the one I'm Editing or reload all if not editing
    func updateRows(){
        var rowsToUpdate : [IndexPath] = []
        if let _rowsToUpdate = tableView.indexPathsForVisibleRows,
            isEditingARow{
            // Update All Rows Except the one I'm Editing
            rowsToUpdate = _rowsToUpdate
            rowsToUpdate.remove(at: 0)
            self.tableView.reloadRows(at: rowsToUpdate, with: UITableView.RowAnimation.none)
        }
        else{
            // If im not editing an IndexPath, then reload All
            self.tableView.reloadData()
        }
    }
    
    // MARK: Dealoc
    deinit {
        timer.invalidate()
        timer = nil
    }
}

// MARK: CurrencyTableViewCellDelegate

extension HomeCurrencyConverterViewController : CurrencyTableViewCellDelegate{

    func didTapTextFieldForCell(_ cell: CurrencyTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell){
            tableView(tableView, didSelectRowAt: indexPath)
        }
    }
    func didEditTextFieldForCell(_ cell: CurrencyTableViewCell) {
        let decimalAmount = Decimal(string: cell.currencyAmountTextField.text ?? "0")
        let request = HomeCurrencyConverter.UpdateCurrencyAmount.Request(amount: decimalAmount!)
        interactor?.doUpdateUserInputAmount(request: request)
    }
    
}

 // MARK: UITableViewDataSource
extension HomeCurrencyConverterViewController : UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CurrencyTableViewCell
        let currentRate = rates[indexPath.row]
        cell.config(withRate: currentRate)
        cell.delegate = self
        return cell
    }
}
 // MARK: UITableViewDelegate
extension HomeCurrencyConverterViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CurrencyTableViewCell
        let firstIndexPath = IndexPath(row: 0, section: 0)
        self.isEditingARow = true
        tableView.moveRow(at: indexPath, to: firstIndexPath)
        // TODO: somwehow Animated: True is Bugged
        tableView.scrollToRow(at: firstIndexPath, at: .top, animated: false)
        self.currentBase = cell.currencyAbreviationLabel.text!
        // We need to Force a fetch again to prevent duplicated cells while moving a cell due to old request reloading 
        self.doFetchCurrencies(base: self.currentBase)
        cell.currencyAmountTextField.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        defer { isEditingARow = false }
        guard let cell = tableView.cellForRow(at: indexPath) as? CurrencyTableViewCell else {
            return
        }
        cell.currencyAmountTextField.canResign = true
    }
}
