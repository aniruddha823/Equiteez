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
import SPStorkController
import SPFakeBar

class StockSegmentedVC: UIViewController {
    
    @IBOutlet weak var stockDetailView: UIView!
    @IBOutlet weak var stockFinancialsView: UIView!
    @IBOutlet weak var shareAmountLabel: UILabel!
    @IBOutlet weak var tradeButton: UIButton!
    
    var detailContainer: StockDetailsVC?
    var financialsContainer: StockFinancialsVC?
    var tradeScreen: TradeScreenVC?
    var ticker = ""
    
    @IBAction func switchStockViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            stockDetailView.alpha = 1
            stockFinancialsView.alpha = 0
            print("in details")
        } else if sender.selectedSegmentIndex == 1 {
            stockDetailView.alpha = 0
            stockFinancialsView.alpha = 1
            print("in fins")
        } else {
            print("In the News!!!")
        }
    }
    
    @IBAction func tradeStock(_ sender: Any) {
        performSegue(withIdentifier: "gotoTradeScreen", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoDetails" {
            detailContainer = segue.destination as? StockDetailsVC
            detailContainer?.ticker = ticker
        } else if segue.identifier == "gotoFinancials" {
            financialsContainer = segue.destination as? StockFinancialsVC
            financialsContainer?.ticker = ticker
        } else if segue.identifier == "gotoTradeScreen" {
            tradeScreen = segue.destination as? TradeScreenVC
            tradeScreen?.ticker = ticker
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let fetchRequest: NSFetchRequest<Stock> = Stock.getSortedFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", ticker)
        do {
            let result = try PersistentService.context.fetch(fetchRequest)
            if let savedStock = result.first {
                shareAmountLabel.text = "\(savedStock.sharesOwned)"
            } else { shareAmountLabel.text = "0" }
        } catch { print(error) }
        
        tradeButton.layer.cornerRadius = tradeButton.frame.height / 2

//        UIView.animate(withDuration: 0.25, animations: {
//                self.stockDetailView.alpha = 1
//                self.stockFinancialsView.alpha = 0
//        })
    }
    
    override func viewDidLoad() {
        
    }
    
}

class TradeScreenSegue: UIStoryboardSegue {
    public var transitioningDelegate = SPStorkTransitioningDelegate()
    
    override func perform() {
        transitioningDelegate.customHeight = 700
        
        destination.transitioningDelegate = transitioningDelegate
        destination.modalPresentationStyle = .custom
        super.perform()
    }
}

class StockDetailsVC: UIViewController {
    
    var ticker = ""
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)
        ticker = ticker.uppercased()
        self.title = ticker
//        print("nav title: \(navigationItem.title)")
        
        let nv = Bundle.main.loadNibNamed("NameView", owner: nil, options: nil)?.first as! NameView
        nv.setupCell(ticker: ticker)
        
        if detailsStackView.arrangedSubviews.count == 5, let view = detailsStackView.arrangedSubviews.first {
            
            detailsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        detailsStackView.insertArrangedSubview(setupShadow(view: nv), at: 0)
    }
    
    @IBOutlet weak var detailsStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dv = Bundle.main.loadNibNamed("DetailsView", owner: nil, options: nil)?.first as! DetailsView
        dv.setupCell(ticker: ticker)
        
        let gv = Bundle.main.loadNibNamed("GraphView", owner: nil, options: nil)?.first as! GraphView
        gv.setupCell(ticker: ticker)
        
        let sv = Bundle.main.loadNibNamed("StatsView", owner: nil, options: nil)?.first as! StatsView
        sv.setupCell(ticker: ticker)
        
        let iv = Bundle.main.loadNibNamed("InformationView", owner: nil, options: nil)?.first as! InformationView
        iv.setupCell(ticker: ticker)
        
        detailsStackView.addArrangedSubview(setupShadow(view: dv))
        detailsStackView.addArrangedSubview(setupShadow(view: gv))
        detailsStackView.addArrangedSubview(setupShadow(view: sv))
        detailsStackView.addArrangedSubview(setupShadow(view: iv))
    }
    
    func setupShadow(view: UIView) -> UIView {
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        view.layer.shadowColor = UIColor(named: "shadcol")?.resolvedColor(with: self.traitCollection).cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 0)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
        
        return view
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
