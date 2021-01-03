//
//  Balance.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 12/22/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import CoreData

class Transfer: NSManagedObject {
    @NSManaged public var walletBalance: Double
    @NSManaged public var dateUpdated: Double
}

extension Transfer {
    static func getSortedFetchRequest() -> NSFetchRequest<Transfer> {
        let request = Transfer.fetchRequest() as! NSFetchRequest<Transfer>
        request.sortDescriptors = [NSSortDescriptor(key: "dateUpdated", ascending: false)]
        return request
    }
}
