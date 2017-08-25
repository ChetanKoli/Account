//
//  PaymentAccount.swift
//  Account
//
//  Created by Chetan Koli on 8/23/17.
//  Copyright © 2017 TCS. All rights reserved.
//

import Foundation

class PaymentAccount: Account
{
    //Note:
    //In future if any new propoerty added to Payment Account then this class will be modifed  
    
    init(accountId: Int, accountNumber: String, iban: String, isVisible: Bool) {
        
        super.init(accountId: accountId, accountNumber: accountNumber, iban: iban, accountType: .Payment, isVisible: isVisible)
    }
    
    
}
