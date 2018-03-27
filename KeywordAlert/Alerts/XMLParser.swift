//
//  XMLParser.swift
//  Key word alert
//
//  Created by Borui Zhou on 2018-03-12.
//  Copyright © 2018 Borui Zhou. All rights reserved.
//

// TODO: attach url to the title

import Foundation
import CoreData
import HTMLString
import SwiftSoup

struct RSSItem {
    var title: String
    var pubDate: String
    var url: String
    var content: String
}

// download xml from a server
// parse xml to foundation objects
// call back

class FeedParser: NSObject, XMLParserDelegate
{
    var rssItems: [RSSItem] = []
    private var currentElement = ""
    private var currentURL: String = ""
    var mainContent: String = ""
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentContent: String = "" {
        didSet {
            currentContent = currentContent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    
    private var parserCompletionHandler: (([RSSItem]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([RSSItem]) -> Void)?)
    {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            /// parse xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
    {
        currentElement = elementName
        if currentElement == "entry" {
            currentTitle = ""
            currentPubDate = ""
            currentContent = ""
        }
        
        if currentElement == "content" {
            currentURL = attributeDict["xml:base"]!
        }
        //print(currentURL)
        //print("*** \(elementName): \n \(attributeDict) \n \n ")
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
        //print("\(string)\n======")
        switch currentElement {
            
        case "title":
            currentTitle += string
            currentTitle = currentTitle.removingHTMLEntities
            
        case "published" :
            currentPubDate += string
            
        //TODO: exclude irrelevent contents like iamge description
        case "content" :
            //if currentElement !=
            currentContent += string
            currentContent = currentContent.removingHTMLEntities
            
            //mainContent is the currentContent without irrelevant strings like tag names, url, etc
            do {
                let doc: Document = try! SwiftSoup.parse(currentContent)
                mainContent = try! doc.body()!.text()
            } catch Exception.Error(let type, let message) {
                print(message)
            } catch {
                print("error")
            }

            
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if elementName == "entry" {
            let rssItem = RSSItem(title: currentTitle, pubDate: currentPubDate, url: currentURL, content: mainContent)
            self.rssItems.append(rssItem)
            searchKeywords()
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError.localizedDescription)
    }
    
    
    let count = 0
    let lastSearchTime = NSDate()
    let context = CoreDataContainer.sharedInstance.persistentContainer.viewContext
    
    
    // TODO: compare lastSearchTime to pubDate
    func searchKeywords() -> Int {
        
        //clean up old data
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ThreadInfo")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Error saving keywords: \(error)")
        }
        
        //fetch data
        var keyword:[Keyword]? = nil
        keyword = CoreDataHandler.fetchKeyword()
        var numberOfNotifications: Int = 0
        
        
//        let RFC3339DateFormatter = DateFormatter()
//        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//        let date = RFC3339DateFormatter.date(from: threadInfo.pubDate!)
        
        // TODO: convert rssItem.pubDate to date
        for everyKeyword in keyword! {
            let searchResult = rssItems.filter { $0.title.range(of: everyKeyword.keyword!, options: [.caseInsensitive]) != nil
                || $0.content.range(of: everyKeyword.keyword!, options: [.caseInsensitive]) != nil }
            
            //save searchResult into database
            for everyResult in searchResult{
                let threadInfo = ThreadInfo(context: self.context)
                threadInfo.title = everyResult.title
                threadInfo.pubDate = everyResult.pubDate
                threadInfo.keyword = everyKeyword.keyword
                threadInfo.url = everyResult.url
                numberOfNotifications += 1
                
                do {
                    try context.save()
                } catch {
                    print("Error saving keywords: \(error)")
                }
            }
        }
        return numberOfNotifications
    }
    
}
























