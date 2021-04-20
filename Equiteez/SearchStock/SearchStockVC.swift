//
//  SearchStockVC.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/7/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit
import CoreData
import SPStorkController
import SPFakeBar
import SearchTextField

class SearchStockVC: UIViewController {
    
    var savedStocks = [Stock]()
    var passedTicker = ""
    var searchTextFieldItems = [SearchTextFieldItem]()
    let fakenavbar = SPFakeBarView(style: .stork)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var searchStockField: SearchTextField!
    @IBAction func testFetch(_ sender: Any) {
        print(savedStocks.count)
        self.view.makeToast(message: "This is a message to test the functionality of the Toast class.", duration: 2, position: .center)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)
        
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationCapturesStatusBarAppearance = true
        
        searchStockField.layer.cornerRadius = 10
        ViewAppearance.setupShadow(view: searchStockField)
        searchStockField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: (fakenavbar.height + 20)).isActive = true
        searchStockField.maxNumberOfResults = 15
        searchStockField.maxResultsListHeight = 500
        searchStockField.comparisonOptions = [.caseInsensitive]
        
        fetchStockList()
        
        searchStockField.itemSelectionHandler = { filteredResults, itemPosition in
            
            self.passedTicker = filteredResults[itemPosition].title
            self.performSegue(withIdentifier: "gotoMain", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoDetail" {
            let vc = segue.destination as! StockDetailsVC
            vc.ticker = passedTicker
        }
    }
    
    func fetchStockList() {
        FMPquery.getStockList() { (list) in
            for (symbol, name) in list {
                let item = SearchTextFieldItem(title: symbol, subtitle: name)
                self.searchTextFieldItems.append(item)
            }
        
            self.searchStockField.filterItems(self.searchTextFieldItems)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

extension NSManagedObjectContext {
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
