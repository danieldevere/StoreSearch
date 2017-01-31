//
//  SearchViewController.swift
//  StoreSearch
//
//  Created by DANIEL DE VERE on 1/26/17.
//  Copyright (c) 2017 DANIEL DE VERE. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    var dataTask: NSURLSessionDataTask?
    
    struct TableViewCellIdentifiers {
        static let searchResultCell = "SearchResultCell"
        static let nothingFoundCell = "NothingFoundCell"
        static let loadingCell  = "LoadingCell"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        tableView.rowHeight = 80
        searchBar.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func urlWithSearchText(searchText: String) -> NSURL {
        let escapedSearchText = searchText.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let urlString = String(format: "http://itunes.apple.com/search?term=%@&limit=200", escapedSearchText)
        let url = NSURL(string: urlString)
        return url!
    }
    
    func parseJSON(data: NSData) -> [String: AnyObject]? {
        var error: NSError?
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error) as? [String: AnyObject] {
            return json
        } else if let error = error {
            println("JSON Error: \(error)")
        } else {
            println("Unknown JSON Error")
        }
        return nil
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Please try again.", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func parseDictionary(dictionary: [String: AnyObject]) -> [SearchResult] {
        var searchResults = [SearchResult]()
        if let array: AnyObject = dictionary["results"] {
            for resultDict in array as! [AnyObject] {
                if let resultDict = resultDict as? [String: AnyObject] {
                    var searchResult: SearchResult?
                    if let wrapperType = resultDict["wrapperType"] as? String {
                        switch wrapperType {
                        case "track":
                            searchResult = SearchResult(dictionary: resultDict, asType: "track")
                        case "audiobook":
                            searchResult = SearchResult(dictionary: resultDict, asType: "audiobook")
                        case "software":
                            searchResult = SearchResult(dictionary: resultDict, asType: "software")
                        default:
                            break
                        }
                    } else if let kind = resultDict["kind"] as? String {
                        if kind == "ebook" {
                            searchResult = SearchResult(dictionary: resultDict, asType: "ebook")
                        }
                    }
                    if let result = searchResult {
                        searchResults.append(result)
                    }
                } else {
                    println("Expected a dictionary")
                }
            }
        } else {
            println("Expected 'results' array")
        }
        return searchResults
    }
    
    
    
    

    
    
    func kindForDisplay(kind: String) -> String {
        switch kind {
            case "album": return "Album"
            case "audiobook": return "Audio Book"
            case "book": return "Book"
            case "ebook": return "E-Book"
            case "feature-movie": return "Movie"
            case "music-video": return "Music Video"
            case "podcast": return "Podcast"
            case "software": return "App"
            case "song": return "Song"
            case "tv-episode": return "TV Episode"
        default: return kind
        }
    }


}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if !searchBar.text.isEmpty {
            searchBar.resignFirstResponder()
            dataTask?.cancel()
            isLoading = true
            tableView.reloadData()
            hasSearched = true
            searchResults = [SearchResult]()
            
            let url = self.urlWithSearchText(searchBar.text)
            let session = NSURLSession.sharedSession()
            dataTask = session.dataTaskWithURL(url, completionHandler: {
                data, response, error in
                if let error = error {
                    println("Failure! \(error)")
                    if error.code == -999 { return }
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        if let dictionary = self.parseJSON(data) {
                            self.searchResults = self.parseDictionary(dictionary)
                            self.searchResults.sort(<)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.isLoading = false
                                self.tableView.reloadData()
                            })
                            return
                        }
                    } else {
                        println("Failure! \(response)")
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.hasSearched = false
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.showNetworkError()
                })
            })
            
            dataTask?.resume()
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath: indexPath) as! UITableViewCell
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if searchResults.count == 0 {
            return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell, forIndexPath: indexPath) as! UITableViewCell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell, forIndexPath: indexPath) as! SearchResultCell
            let searchResult = searchResults[indexPath.row]
            cell.nameLabel.text = searchResult.name
            if searchResult.artistName.isEmpty {
                cell.artistNameLabel.text = "Unknown"
            } else {
                cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, kindForDisplay(searchResult.kind))
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
    
}