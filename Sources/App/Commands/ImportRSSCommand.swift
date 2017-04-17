//
//  ImportRSSCommand.swift
//  DebuggedPodcast
//
//  Created by Ashley Coleman on 4/14/17.
//
//

import Foundation
import Vapor
import Console
import AEXML

class ImportRSSCommand: Command {
    public let id = "import"
    public let help = ["Import a iTunes podcast RSS feed into the database"]
    public let console: ConsoleProtocol
    
    
    public init(console: ConsoleProtocol) {
        self.console = console
    }
    
    public func run(arguments: [String]) throws {
        Metadata.database = drop.database
        Podcast.database = drop.database
        
        let websiteURL = console.ask("Enter the url to new site (https://podcast.com): ")
        
        let xml = try getXML()
        
        var metadata = try createMetadata(xml: xml, url: websiteURL)
        do {
            try Metadata.query().delete()
            try metadata.save()
        } catch {
            console.error("\(error)")
            console.error("Error setting metadata. Aborting")
            return
        }
        
        let podcasts = try createPodcasts(xml: xml, url: websiteURL)
        
        for var podcast in podcasts {
            try podcast.save()
        }
    }
    
    func getXML() throws -> AEXMLDocument {
        
        let rssFeedURL = console.ask("Enter the url to the podcast rss feed: ")
        
        let bytes = try getBytes(url: rssFeedURL)
        
        guard let xmlString = String(bytes: bytes, encoding: String.Encoding.utf8) else {
            throw Abort.custom(status: .expectationFailed, message: "Cannot convert response to string")
        }
        
        return try AEXMLDocument(xml: xmlString)
    }
    
    func createPodcasts(xml: AEXMLDocument, url: String) throws -> [Podcast] {
        var podcasts:[Podcast] = []
        for item in xml.root["channel"]["item"].all! {
            let title = item["title"].string
            let author = item["itunes:author"].string
            let subtitle = item["itunes:subtitle"].string
            let summary = item["itunes:summary"].string
            
            guard let oldImageURL = item["itunes:image"].attributes["href"]?.string else {
                throw Abort.custom(status: .expectationFailed, message: "<itunes:image>: is missing or href attribute is blank")
            }
            
            guard  let oldMediaURL = item["enclosure"].attributes["url"]?.string else {
                throw Abort.custom(status: .expectationFailed, message: "<enclosure>: is missing or url attribute is blank")
            }
            
            guard  let length = item["enclosure"].attributes["length"]?.int else {
                throw Abort.custom(status: .expectationFailed, message: "<enclosure>: is missing or length attribute is blank")
            }
            
            guard  let type = item["enclosure"].attributes["type"]?.string else {
                throw Abort.custom(status: .expectationFailed, message: "<enclosure>: is missing or type attribute is blank")
            }
            
            let GUID = item["guid"].string
            let pubDate = item["pubDate"].string
            let duration = item["itunes:duration"].string
            
            let filename = getFilname(url: oldImageURL)
            let newImageUrl = url + "/images/" + filename
            if(!(oldImageURL == xml.root["channel"]["itunes:image"].attributes["href"]?.string)){
                // Fetch and download old image url is different than the default
                let bytes = try getBytes(url: oldImageURL)
                try Data(bytes).write(to: URL(fileURLWithPath: drop.workDir + "/Public/images/\(filename)"))
            }
            
            let mediaFilename = getFilname(url: oldMediaURL)
            let newMediaURL = url + "/media/" + mediaFilename
            
            console.print("Downloading \(mediaFilename)")
            try Data(try getBytes(url: oldMediaURL)).write(to: URL(fileURLWithPath: drop.workDir + "/Public/media/\(mediaFilename)"))
            console.print("\(mediaFilename) downloaded.")
            
            podcasts.append(Podcast(title: title, author: author, subtitle: subtitle, summary: summary, imageURL: newImageUrl, mediaURL: newMediaURL, mediaLength: length, mediaType: type, mediaDuration: duration, GUID: GUID, publishDate: pubDate, createdBy: 1, metadata: 1))
        }
        
        return podcasts.reversed()
    }
    
    func createMetadata(xml: AEXMLDocument, url: String) throws -> Metadata {
        let channel = xml.root["channel"]
        let title = channel["title"].string
        let copyright = channel["copyright"].string
        let subtitle = channel["itunes:subtitle"].string
        let author = channel["itunes:author"].string
        let summary = channel["itunes:summary"].string
        let description = channel["description"].string
        let ownerName = channel["itunes:owner"]["itunes:name"].string
        let ownerEmail = channel["itunes:owner"]["itunes:email"].string
        
        guard let oldImageURL = channel["itunes:image"].attributes["href"]?.string else {
            throw Abort.custom(status: .expectationFailed, message: "<itunes:image href=\"\" />: is missing or href is blank")
        }
        
        guard  let category = channel["itunes:category"].attributes["text"]?.string else {
            throw Abort.custom(status: .expectationFailed, message: "<itunes:category text=\"\"/>: is missing or text is blank")
        }
        
        let isExplicit = (channel["itunes:explicit"].string == "yes")
        
        
        // Fetch and download old image url
        let filename = getFilname(url: oldImageURL)
        let bytes = try getBytes(url: oldImageURL)
        
        try Data(bytes).write(to: URL(fileURLWithPath: drop.workDir + "/Public/images/\(filename)"))
        
        let newImageUrl = url + "/images/" + filename
        
        return Metadata(title: title, websiteURL: url, copyright: copyright, subtitle: subtitle, author: author, summary: summary, description: description, ownerName: ownerName, ownerEmail: ownerEmail, imageURL: newImageUrl, category: category, isExplicit: isExplicit)
    }
    
    private func getFilname(url: String) -> String {
        let idx = url.index((url.range(of: "/", options: String.CompareOptions.backwards, range: nil, locale: nil)?.lowerBound)!, offsetBy: 1)
        return url.substring(from: idx)
    }
    
    private func getBytes(url: String) throws -> [UInt8] {
        let response = try drop.client.get(url)
        
        guard let bytes = response.body.bytes else {
            throw Abort.custom(status: .expectationFailed, message: "Cannot get '\(url)'")
        }
        
        return bytes
    }
}
