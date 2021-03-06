//
//  SearchResult.swift
//  StoreSearch
//
//  Created by DANIEL DE VERE on 1/26/17.
//  Copyright (c) 2017 DANIEL DE VERE. All rights reserved.
//

import Foundation

func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == NSComparisonResult.OrderedAscending
}

class SearchResult {
    var name = ""
    var artistName = ""
    var artworkURL60 = ""
    var artworkURL100 = ""
    var storeURL = ""
    var kind = ""
    var currency = ""
    var price = 0.0
    var genre = ""
    
    func kindForDisplay() -> String {
        switch kind {
        case "album":
            return NSLocalizedString("Album", comment: "Localized kind: Album")
        case "audiobook":
            return NSLocalizedString("Audio Book", comment: "Localized kind: Audio Book")
        case "book":
            return NSLocalizedString("Book", comment: "Localized kind: Book")
        case "ebook":
            return NSLocalizedString("E-Book", comment: "Localized kind: E-Book")
        case "feature-movie":
            return NSLocalizedString("Movie", comment: "Localized kind: Feature Movie")
        case "music-video":
            return NSLocalizedString("Music Video", comment: "Localized kind: Music Video")
        case "podcast":
            return NSLocalizedString("Podcast", comment: "Localized kind: Podcast")
        case "software":
            return NSLocalizedString("App", comment: "Localized kind: Software")
        case "song":
            return NSLocalizedString("Song", comment: "Localized kind: Song")
        case "tv-episode":
            return NSLocalizedString("TV Episode", comment: "Localized kind: TV Episode")
        default: return kind
        }
    }

    
    
    
    init(name: String, artistName: String, artworkURL60: String, artworkURL100: String, storeURL: String, kind: String, currency: String) {
        self.name = name
        self.artistName = artistName
        self.artworkURL60 = artworkURL60
        self.artworkURL100 = artworkURL100
        self.storeURL = storeURL
        self.kind = kind
        self.currency = currency
        self.price = 0.0
        self.genre = ""

    }
    convenience init() {
        self.init(name: "", artistName: "", artworkURL60: "", artworkURL100: "", storeURL: "", kind: "", currency: "")
    }
    
    convenience init(dictionary: [String: AnyObject], asType type: String) {
        self.init()
        switch type {
            case "track":
                self.name = dictionary["trackName"] as! String
                self.artistName = dictionary["artistName"] as! String
                self.artworkURL60 = dictionary["artworkUrl60"] as! String
                self.artworkURL100 = dictionary["artworkUrl100"] as! String
                self.storeURL = dictionary["trackViewUrl"] as! String
                self.kind = dictionary["kind"] as! String
                self.currency = dictionary["currency"] as! String
                if let price = dictionary["trackPrice"] as? Double {
                    self.price = price
                }
                if let genre = dictionary["primaryGenreName"] as? String {
                    self.genre = genre
                }
            case "audiobook":
                self.name = dictionary["collectionName"] as! String
                self.artistName = dictionary["artistName"] as! String
                self.artworkURL60 = dictionary["artworkUrl60"] as! String
                self.artworkURL100 = dictionary["artworkUrl100"] as! String
                self.storeURL = dictionary["collectionViewUrl"] as! String
                self.kind = "audiobook"
                self.currency = dictionary["currency"] as! String
                if let price = dictionary["collectionPrice"] as? Double {
                    self.price = price
                }
                if let genre = dictionary["primaryGenreName"] as? String {
                    self.genre = genre
                }
            case "software":
                self.name = dictionary["trackName"] as! String
                self.artistName = dictionary["artistName"] as! String
                self.artworkURL60 = dictionary["artworkUrl60"] as! String
                self.artworkURL100 = dictionary["artworkUrl100"] as! String
                self.storeURL = dictionary["trackViewUrl"] as! String
                self.kind = dictionary["kind"] as! String
                self.currency = dictionary["currency"] as! String
                if let price = dictionary["price"] as? Double {
                    self.price = price
                }
                if let genre = dictionary["primaryGenreName"] as? String {
                    self.genre = genre
                }
            case "ebook":
                self.name = dictionary["trackName"] as! String
                self.artistName = dictionary["artistName"] as! String
                self.artworkURL60 = dictionary["artworkUrl60"] as! String
                self.artworkURL100 = dictionary["artworkUrl100"] as! String
                self.storeURL = dictionary["trackViewUrl"] as! String
                self.kind = dictionary["kind"] as! String
                self.currency = dictionary["currency"] as! String
                if let price = dictionary["price"] as? Double {
                    self.price = price
                }
                if let genres: AnyObject = dictionary["genres"] as? String {
                    self.genre = ", ".join(genres as! [String])
                }
        default:
            break



            }
    }
    
    
}