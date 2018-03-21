//
//  AlertsTableViewCell.swift
//  Key word alert
//
//  Created by Borui Zhou on 2018-03-12.
//  Copyright © 2018 Borui Zhou. All rights reserved.
//


import UIKit

enum CellState {
    case expanded
    case collapsed
}

class AlertsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    
    @IBOutlet weak var dateLabel:UILabel!
    
    var item: RSSItem! {
        didSet {
            titleLabel.text = item.title
            dateLabel.text = item.pubDate
        }
    }
}
