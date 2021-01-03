//
//  Stock.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 11/26/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Foundation
import CoreData

class Stock: NSManagedObject {
    @NSManaged public var companyCEO: String?
    @NSManaged public var companyDescription: String?
    @NSManaged public var companyLogoURL: String?
    @NSManaged public var companyName: String?
    @NSManaged public var symbol: String?
    @NSManaged public var companyIndustry: String?
    @NSManaged public var companyWebsite: String?
    @NSManaged public var order: Int
    @NSManaged public var sharesOwned: Int
    @NSManaged public var onWatchlist: Bool
    @NSManaged public var companyEmployees: Int
    
}

extension Stock {
    static func getSortedFetchRequest() -> NSFetchRequest<Stock> {
        let request = Stock.fetchRequest() as! NSFetchRequest<Stock>
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        return request
    }
}
