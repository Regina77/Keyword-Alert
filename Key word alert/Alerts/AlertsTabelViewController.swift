//
//  AlertsTabelViewController.swift
//  Key word alert
//
//  Created by Borui Zhou on 2018-03-12.
//  Copyright © 2018 Borui Zhou. All rights reserved.
//

// TODO: no table views, just notifications

import UIKit
import CoreData

class AlertsTableViewController: UITableViewController
{
    private var rssItems: [RSSItem]?
    private var cellStates: [CellState]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        fetchData()
        FeedParser().searchKeywords()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    private func fetchData()
    {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://forums.redflagdeals.com/feed/forum/9") { (rssItems) in
            self.rssItems = rssItems
            self.cellStates = Array(repeating: .collapsed, count: rssItems.count)
            
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let rssItems = rssItems else {
            return 0
        }
        
        // rssItems
        return rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AlertsTableViewCell
        if let item = rssItems?[indexPath.item] {
            cell.item = item
            cell.selectionStyle = .none
            
            if let cellStates = cellStates {
                cell.titleLabel.numberOfLines = (cellStates[indexPath.row] == .expanded) ? 0 : 4
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! AlertsTableViewCell
        
        tableView.beginUpdates()
        cell.titleLabel.numberOfLines = (cell.titleLabel.numberOfLines == 0) ? 3 : 0
        
        cellStates?[indexPath.row] = (cell.titleLabel.numberOfLines == 0) ? .expanded : .collapsed
        
        tableView.endUpdates()
    }
    
}



