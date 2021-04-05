//
//  Transaction.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 12/22/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import CoreData

class Trade: NSManagedObject {
    @NSManaged public var type: String
    @NSManaged public var ticker: String
    @NSManaged public var sharePrice: Double
    @NSManaged public var shareAmount: Int64
    @NSManaged public var netShares: Int64
    @NSManaged public var dateAcquired: Double
    @NSManaged public var walletBalancePost: Double
}

extension Trade {
    static func getSortedFetchRequest() -> NSFetchRequest<Trade> {
        let request = Trade.fetchRequest() as! NSFetchRequest<Trade>
        request.sortDescriptors = [NSSortDescriptor(key: "dateAcquired", ascending: false)]
        
        return request
    }
}
