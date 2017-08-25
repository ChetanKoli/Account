//
//  ViewModel.swift
//  Account
//
//  Created by Chetan Koli on 8/23/17.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

enum AccountRequest {
    case All
    case OnlyVisible
}

protocol AccountDetailsViewModelProtocol {
    
    func didAccountDetailsModelUpdated(_ success: Bool)
}

class AccountDetailsViewModel
{
    var delegate: AccountDetailsViewModelProtocol?
    
    fileprivate var accountDetails = AccountDetails()
    
    fileprivate var accountArray = [Account]()
    fileprivate var onlyVisibleAccountArray: [Account]?
    
    init() {
    }
    
    //MARK: - Data generation method
    
    //Method for loading, and reading JSON data and generating Model data
    func generateJSONData() {
        
        DispatchQueue.global().async {
            
            AccountDetailsDataManager().getAccountDetailsData(completion: { (accountDetails) in
                
                let success: Bool
                
                if let accountDetails = accountDetails {
                    self.accountDetails = accountDetails
                    success = true
                } else {
                    success = false
                }
                
                if let delegate = self.delegate {
                    delegate.didAccountDetailsModelUpdated(success)
                }
            })
        }
        
    }
    
    //MARK: - Model data providing methods
    
    //Method for setting Account array as per All Accounts or Only Visibile Account type selection
    func accountRequest(_ accountRequest: AccountRequest) {
        
        switch accountRequest {
        case .OnlyVisible:
            
            accountArray = onlyVisibleAccountArray ?? generateOnlyVisibleAccountArray()
            
        default:
            accountArray = self.accountDetails.accounts ?? [Account]()
        }
    }
    
    func  numberOfAccounts() -> Int {
        return accountArray.count
    }
    
    func accountName(forIndexPath indexPath: IndexPath) -> String {
        
        let accountName = accountArray[indexPath.row].accountName ?? ""
        
        return ApplicationHelper.checkString(accountName)
    }
    
    func accountBalanace(forIndexPath indexPath: IndexPath) -> String {
        
        var accountBalance = ""
        
        let account = accountArray[indexPath.row]
        
        if let accountBalanaceInCent = account.accountBalanceInCents, let currencyCode = account.accountCurrency?.rawValue {
            accountBalance = ApplicationHelper.generateCurrencyForBalance(accountBalanaceInCent, currencyCode: currencyCode) ?? ""
        }
        
        return ApplicationHelper.checkString(accountBalance)
    }
    
    func accountType(forIndexPath indexPath: IndexPath) -> String {
        
        let account = accountArray[indexPath.row]
        
        return ApplicationHelper.checkString(account.accountType.rawValue)
    }
    
    func iban(forIndexPath indexPath: IndexPath) -> String {
        
        let account = accountArray[indexPath.row]
        
        return ApplicationHelper.checkString(account.iban)
    }
    
    func accountNumber(forIndexPath indexPath: IndexPath) -> String {
        
        return accountArray[indexPath.row].accountNumber
    }
    
    //MARK: - Private
    
    //Method for generating Accounts which are 'visible' only once
    fileprivate func generateOnlyVisibleAccountArray() -> [Account] {
        
        var onlyVisibleAccountArray = [Account]()
        
        guard let accounts = accountDetails.accounts else {
            return onlyVisibleAccountArray
        }
        
        for account in accounts {
            
            if account.isVisible {
                
                onlyVisibleAccountArray.append(account)
            }
        }
        //Save into global variable so that #function will not call again
        self.onlyVisibleAccountArray = onlyVisibleAccountArray

        return onlyVisibleAccountArray
    }
    
        
}
