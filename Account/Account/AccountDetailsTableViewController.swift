//
//  AccountDetailsTableViewController.swift
//  Account
//
//  Created by Chetan Koli on 8/23/17.
//  Copyright © 2017 TCS. All rights reserved.
//

import UIKit

class AccountDetailsTableViewController: UITableViewController {
    
    @IBOutlet fileprivate var accountDisplaySegment: UISegmentedControl!
    
    fileprivate var accountDetailsViewModel = AccountDetailsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assuming - Data will recieved only once 
        //So that JSON loading and reading done only once i.e on viewDidLoad
        
        //In future Activity Indicator will be added when data is received from server
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        accountDetailsViewModel.generateJSONData()
        accountDetailsViewModel.delegate = self

        //Table view Self sizing functionality
        tableView.estimatedRowHeight = 55
        tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - IBActions
    
    @IBAction func displayAccountDetails(_ sender: Any) {
        
        if let segment = sender as? UISegmentedControl
        {
            switch segment.selectedSegmentIndex {
            case 0:
                accountDetailsViewModel.accountRequest(.All)
            case 1:
                accountDetailsViewModel.accountRequest(.OnlyVisible)
            default:
                return
            }
        }

        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountDetailsViewModel.numberOfAccounts() 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        // Configure the cell...
        return configureAccountCell(atIndexPath: indexPath)
    }
}

extension AccountDetailsTableViewController: AccountDetailsViewModelProtocol {
    
    //MARK: - AccountDetailsViewModelProtocol methods
    func didAccountDetailsModelUpdated(_ success: Bool) {
    
        DispatchQueue.main.async {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            self.accountDisplaySegment.isUserInteractionEnabled = success
            self.accountDisplaySegment.isEnabled = success
            
            if success {
                //Obtained data update UI
                self.displayAccountDetails(self.accountDisplaySegment!)
                
            } else {
                //Unable to fetch data show alert
                let alert = UIAlertController(title: Alert.ErrorTitle, message: Message.NoDataMessage, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: Alert.CancelTitle, style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}

extension AccountDetailsTableViewController {
    
    //MARK: - Class specific methods
    
    fileprivate func configureAccountCell(atIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier.AccountDetailCell, for: indexPath) as? AccountDetailTableViewCell else { return UITableViewCell() }
        
        cell.accountNumberLabel.text = accountDetailsViewModel.accountNumber(forIndexPath: indexPath)
        cell.accountNameLabel.text = accountDetailsViewModel.accountName(forIndexPath: indexPath)
        cell.accountTypeLabel.text = accountDetailsViewModel.accountType(forIndexPath: indexPath)
        cell.accountBalanceLabel.text = accountDetailsViewModel.accountBalanace(forIndexPath: indexPath)
        cell.ibanNumberLabel.text = accountDetailsViewModel.iban(forIndexPath: indexPath)
        
        return cell
    }
}
