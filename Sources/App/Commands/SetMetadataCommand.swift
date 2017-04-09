//
//  SetMetadataCommand.swift
//  DebuggedPodcast
//
//  Created by Ashley Coleman on 4/8/17.
//
//

import Vapor
import Console

final class SetMetadataCommand: Command {
    public let id = "metadata"
    public let help = ["Set the podcast metadata"]
    public let console: ConsoleProtocol
    
    public init(console: ConsoleProtocol) {
        self.console = console
    }
    
    public func run(arguments: [String]) throws {
        
        Metadata.database = drop.database
        
        var title = ""
        var subtitle = ""
        var summary = ""
        var description = ""
        var websiteURL = ""
        var imageURL = ""
        var isExplicit = false
        var ownerName = ""
        var ownerEmail = ""
        var copyright = ""
        var category = ""
        
        repeat {
            title = console.ask("Podcast Title: ")
            subtitle = console.ask("Podcast Subtitle: ")
            summary = console.ask("Podcast Summary: ")
            description = console.ask("Podcast Description: ")
            category = console.ask("Podcast Category: ")
            websiteURL = console.ask("Podcast Website URL: ")
            imageURL = console.ask("Podcast Logo Image URL: ")
            isExplicit = (console.ask("Does the podcast feature explicit content? (y/n): ").trim().lowercased() == "y")
            ownerName = console.ask("Owner's Name: ")
            ownerEmail = console.ask("Owner's Email: ")
            copyright = console.ask("Copyright String: ")
            
            console.print()
            
            console.print("Title: " + title)
            console.print("Podcast Subtitle: " + subtitle)
            console.print("Podcast Summary: " + summary)
            console.print("Podcast Description: " + description)
            console.print("Podcast Category: " + category)
            console.print("Podcast Website URL: " + websiteURL)
            console.print("Podcast Logo Image URL: " + imageURL)
            console.print("Features Explicit Content: \(isExplicit ? "Yes" : "No")")
            console.print("Owner's Name: " + ownerName)
            console.print("Owner's Email: " + ownerEmail)
            console.print("Copyright String: " + copyright)
        } while console.ask("Is the metadata correct? (y/n):").trim().lowercased() != "y"
        
        do {
            try Metadata.query().delete()
            var metadata = Metadata(title: title,
                                    websiteURL: websiteURL,
                                    copyright: copyright,
                                    subtitle: subtitle,
                                    summary: summary,
                                    description: description,
                                    ownerName: ownerName,
                                    ownerEmail: ownerEmail,
                                    imageURL: imageURL,
                                    category: category,
                                    isExplicit: isExplicit)
            try metadata.save()
        } catch {
            console.error("\(error)")
            console.error("Error setting metadata. Aborting")
            
            return
        }
        
        console.success("Database seed complete")
        console.print()
    }

}
