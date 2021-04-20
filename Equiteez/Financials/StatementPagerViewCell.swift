//
//  StatementPagerViewCell.swift
//  Equiteez
//
//  Created by Aniruddha Prabhu on 4/4/21.
//  Copyright © 2021 Aniruddha Prabhu. All rights reserved.
//

import UIKit
import FSPagerView
import SwiftDataTables

class StatementPagerViewCell: FSPagerViewCell {
    
    @IBOutlet weak var dataTableView: UIView!
    
    func setup(table: SwiftDataTable) {
        dataTableView.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: dataTableView.topAnchor),
            table.leadingAnchor.constraint(equalTo: dataTableView.leadingAnchor),
            table.bottomAnchor.constraint(equalTo: dataTableView.bottomAnchor),
            table.trailingAnchor.constraint(equalTo: dataTableView.trailingAnchor),
        ])
    }
}

class StatementTitleCell: FSPagerViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
//    func setup(text: String) {
//        titleLabel.text = text
//    }
}
