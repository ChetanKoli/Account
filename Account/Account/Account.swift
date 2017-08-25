//
//  Account.swift
//  Account
//
//  Created by Chetan Koli on 8/23/17.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

public enum AccountType: String
{
    case Saving = "SAVING"
    case Payment = "PAYMENT"
}

enum CurrencyType: String
{
    case EUR = "EUR"
    case IND = "IND"
}

class Account
{
    var accountId: Int
    var accountBalanceInCents: Int?
    var accountCurrency: CurrencyType?
    var accountName: String?
    var accountNumber: String
    var accountType: AccountType
    var alias: String?
    var isVisible: Bool
    var iban: String
    
    
    init(accountId: Int, accountNumber: String, iban: String, accountType: AccountType, isVisible: Bool) {
        
        self.accountId = accountId
        self.accountNumber = accountNumber
        self.iban = iban
        self.accountType = accountType
        self.isVisible = isVisible
        
    }
    
}
