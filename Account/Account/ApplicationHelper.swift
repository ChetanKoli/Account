//
//  AccountConstants.swift
//  Account
//
//  Created by Chetan Koli on 8/24/17.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

struct JSONKey {
    static let AccountsArray = "accounts"
    static let AccountID = "accountId"
    static let AccountType = "accountType"
    static let AccountName = "accountName"
    static let AccountBalance = "accountBalanceInCents"
    static let AccountNumber = "accountNumber"
    static let AccountIBAN = "iban"
    static let AccountIsVisible = "isVisible"
    static let AccountCurrency = "accountCurrency"
    static let LinkedAccountId = "linkedAccountId"
}

struct Resource {
    static let AccountJSONResourceName = "AccountDetailJSON"
    static let ResourceExtensionJSON = "json"
}

struct TableCellIdentifier {
    static let AccountDetailCell = "AccountDetailTableViewCellIdentifier"
    static let AccountDetailTodayExtensionCell = "AccountDetailTodayExtensionTableViewCellIdentifier"
}

struct Alert {
    static let CancelTitle = "Cancel"
    static let ErrorTitle = "Error"
}

struct Message {
    static let LoadingMessage = "Loading..."
    static let NoDataMessage = "No Data Found"
}


class ApplicationHelper {
    
    class func checkString(_ string: String) -> String {
        //If string is empty then replace it with "-"
        return string == "" ? "-" : string
    }
    
    class func generateCurrencyForBalance(_ balance: Int, currencyCode: String) -> String? {
        //Format plain number into Currency format
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        let locale = NSLocale(localeIdentifier: currencyCode)
        formatter.currencySymbol = locale.displayName(forKey: NSLocale.Key.currencySymbol, value: currencyCode)
        
        return formatter.string(from: NSNumber(integerLiteral: balance))
        
    }

}
