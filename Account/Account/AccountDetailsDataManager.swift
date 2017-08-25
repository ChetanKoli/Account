//
//  AccountDetailDataManager.swift
//  Account
//
//  Created by Chetan Koli on 8/23/17.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

class AccountDetailsDataManager
{
    //static let sharedInstance = AccountDetailsDataManager()
    init() {}
    
    //Method for loading JSON, and genrating Model data
    public func getAccountDetailsData(completion:@escaping (AccountDetails?)->Void) {
        
        do {
            //Load JSON
            if let file = Bundle.main.url(forResource: Resource.AccountJSONResourceName, withExtension: Resource.ResourceExtensionJSON) {
                
                let jsonData = try Data(contentsOf: file)
                
                guard let jsonResponseDict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
                    
                    //"Not Proper JSON"
                    completion(nil)
                    
                    return
                }
                //Generate Model data
                if let accountDetails = generateAccountDetails(responseDict: jsonResponseDict) {
                    completion(accountDetails)
                } else {
                    completion(nil)
                }
                
            } else {
                //"No JSON file exists"
                completion(nil)
            }
            
        } catch {
            //error.localizedDescription
            completion(nil)
        }
    }
    
    fileprivate func generateAccountDetails(responseDict: [String: Any]) -> AccountDetails? {
        
        let accountDetails = AccountDetails()
        
        guard let accountsArray = responseDict[JSONKey.AccountsArray] as? [[String: Any]] else {
            
            return nil
        }
        
        var accountArray = [Account]()
        
        for accountDict in accountsArray {
            
            guard let accountId = accountDict[JSONKey.AccountID] as? Int, let accountNumber = accountDict[JSONKey.AccountNumber] as? String, let accountType = accountDict[JSONKey.AccountType] as? String, let iban = accountDict[JSONKey.AccountIBAN] as? String, let isVisible = accountDict[JSONKey.AccountIsVisible] as? Bool else {
                
                return nil
            
            }
            
            let account: Account
            
            if let accType = AccountType(rawValue: accountType) {
                
                //Generate Account details from JSON only when Account type is Saving/Payment
                switch accType {
                    
                case .Saving:
                    
                    let savingAccount = SavingAccount(accountId: accountId, accountNumber: accountNumber, iban: iban, isVisible: isVisible)
                    
                    //Saving Account specific detials from JSON
                    if let linkedAccountId = accountDict[JSONKey.LinkedAccountId] as? Int {
                        savingAccount.linkedAccountID = linkedAccountId
                    }

                    account = savingAccount
                    
                case .Payment:
                    
                    account = PaymentAccount(accountId: accountId, accountNumber: accountNumber, iban: iban, isVisible: isVisible)
                }
                //Generic details from JSON
                if let accountName = accountDict[JSONKey.AccountName] as? String {
                    account.accountName = accountName
                }
                
                if let accountBalance = accountDict[JSONKey.AccountBalance] as? Int {
                    account.accountBalanceInCents = accountBalance
                }
                
                if let accountCurrency = accountDict[JSONKey.AccountCurrency] as? String {
                    account.accountCurrency = CurrencyType(rawValue: accountCurrency)
                }
                
                //Note: Remaning details ('alias' etc.) can be added further
                
                accountArray.append(account)
            } else {
                break
            }
        }
        
        if accountArray.count > 0 {
            accountDetails.accounts = accountArray
        }
        
        return accountDetails
    }
}
