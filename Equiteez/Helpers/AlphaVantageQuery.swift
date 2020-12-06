//
//  AlphaVantageQuery.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/11/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import Alamofire
import SwiftyJSON

class AlphaVantageQuery {
    
    static let key = "LAOWU3O5LGKPTBQA"
    static let baseURL = "https://www.alphavantage.co/query?"
    
    class func getExchangeRate(from: String, amount: Double, to: String, completionHandler: @escaping (Double) -> ()) {
        let URL = baseURL + "function=CURRENCY_EXCHANGE_RATE&from_currency=" + from + "&to_currency=" + to + "&apikey=" + key
        
        Alamofire.request(URL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let result = json["Realtime Currency Exchange Rate"]
                
                let rate = result["5. Exchange Rate"].doubleValue
                let value = amount * rate
                completionHandler(value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
