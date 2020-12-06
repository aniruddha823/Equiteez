//
//  StockDetailsVC.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 1/7/20.
//  Copyright © 2020 Aniruddha Prabhu. All rights reserved.
//

import UIKit
import Charts
import FaveButton
import CoreData

class StockSegmentedVC: UIViewController {
    
    @IBOutlet weak var stockDetailView: UIView!
    @IBOutlet weak var stockFinancialsView: UIView!
    
    var detailContainer: StockDetailsVC?
    var financialsContainer: StockFinancialsVC?
    var ticker = ""
    
    @IBAction func switchStockViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            stockDetailView.alpha = 1
            stockFinancialsView.alpha = 0
            print("in details")
        } else {
            stockDetailView.alpha = 0
            stockFinancialsView.alpha = 1
            print("in fins")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoDetails" {
            detailContainer = segue.destination as? StockDetailsVC
            detailContainer?.ticker = ticker
        } else if segue.identifier == "gotoFinancials" {
            financialsContainer = segue.destination as? StockFinancialsVC
            financialsContainer?.ticker = ticker
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.25, animations: {
                self.stockDetailView.alpha = 1
                self.stockFinancialsView.alpha = 0
        })
    }
    
    override func viewDidLoad() {
        print(ticker)
    }
    
}

class StockDetailsVC: UIViewController {
    
    var ticker = ""
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)
        ticker = ticker.uppercased()
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.register(UINib(nibName: "DetailsCell", bundle: nil), forCellWithReuseIdentifier: "DetailsCell")
        collectionView.register(UINib(nibName: "GraphCell", bundle: nil), forCellWithReuseIdentifier: "GraphCell")
        collectionView.register(UINib(nibName: "StatsCell", bundle: nil), forCellWithReuseIdentifier: "StatsCell")
        collectionView.register(UINib(nibName: "InformationCell", bundle: nil), forCellWithReuseIdentifier: "InformationCell")

        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationItem.title = ticker
    }
    
    func setupShadow(cell: UICollectionViewCell) -> UICollectionViewCell {
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

extension StockDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCell", for: indexPath) as! DetailsCell
            cell1.setupCell(ticker: ticker)
            
            return setupShadow(cell: cell1)
        } else if indexPath.row == 1 {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "GraphCell", for: indexPath) as! GraphCell
            cell2.setupCell(ticker: ticker)
            
            return setupShadow(cell: cell2)
        } else if indexPath.row == 2 {
            let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "StatsCell", for: indexPath) as! StatsCell
            cell3.setupCell(ticker: ticker)
            
            return setupShadow(cell: cell3)
        } else {
            let cell4 = collectionView.dequeueReusableCell(withReuseIdentifier: "InformationCell", for: indexPath) as! InformationCell
            cell4.setupCell(ticker: ticker)
            
            return setupShadow(cell: cell4)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            return CGSize(width: collectionView.frame.width - 20, height: 120)
        } else if indexPath.row == 1 {
            return CGSize(width: collectionView.frame.width - 20, height: 300)
        } else if indexPath.row == 2 {
            return CGSize(width: collectionView.frame.width - 20, height: 150)
        } else {
            return CGSize(width: collectionView.frame.width - 20, height: 200)
        }
    }
}
