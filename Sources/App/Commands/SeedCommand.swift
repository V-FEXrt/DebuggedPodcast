//
//  SeedCommand.swift
//  DebuggedPodcast
//
//  Created by Ashley Coleman on 4/8/17.
//
//

import Vapor
import Console

final class SeedCommand: Command {
    public let id = "seed"
    public let help = ["Seed the database with test values"]
    public let console: ConsoleProtocol
    
    public init(console: ConsoleProtocol) {
        self.console = console
    }
    
    public func run(arguments: [String]) throws {
        
        
        User.database = drop.database
        Metadata.database = drop.database
        Podcast.database = drop.database
        
        console.print("Seeding the database")
        console.print()
        
        guard let user = createUser() else {
            return
        }
        
        guard let metadata = createMetadata() else {
            return
        }
        
        if(!createPodcasts(user: user, metadata: metadata)){
            return
        }
        
        console.success("Database seed complete")
        console.print()
    }
    
    private func createUser() -> User? {
        console.print("Creating Test User...")
        
        do {
            var user = try User(first: "Ashley", last: "Coleman", email: "test@debuggedpodcast.com", password: "password")
            try user.save()
            
            console.print("User created")
            console.print()
            console.print("Email: 'test@dbp.com'")
            console.print("Password: 'password'")
            console.print()
            
            return user
        } catch {
            console.error("\(error)")
            console.error("Error creating user. Aborting")
            
            return nil
        }
    }
    
    private func createMetadata() -> Metadata? {
        console.print("Creating Podcast Metadata...")
        
        var metadata = Metadata(title: "Debugged Podcast",
                                websiteURL: "http://debuggedpodcast.com",
                                copyright: "&#x2117; &amp; &#xA9; 2017 Debugged Podcast",
                                subtitle: "Banter you didn't know you could care about",
                                summary: "We are a group of computer science (and mathematics) majors at Kansas State University. This podcast contains a free range of topics; some funny, some serious, and some just strange.",
                                description: "We are a group of computer science (and mathematics) majors at Kansas State University. This podcast contains a free range of topics; some funny, some serious, and some just strange.",
                                ownerName: "Ashley Coleman",
                                ownerEmail: "test@debuggedpodcast.com",
                                imageURL: "http://colesterproductions.com/podcasts/debugged/cover.jpg",
                                category: "Comedy",
                                isExplicit: true)
        
        do {
            try metadata.save()
            console.print("Podcast Metadata created")
            console.print()
            
            return metadata
        } catch {
            console.error("\(error)")
            console.error("Error creating Podcast Metadata. Aborting")
            return nil
        }
    }
    
    private func createPodcasts(user: User, metadata: Metadata) -> Bool {
        console.print("Creating Podcasts...")
        
        do {
            for i in 0..<5 {
                var podcast = Podcast(title: "Title\(i)",
                                      author: "Author\(i)",
                                      subtitle: "Subtitle\(i)",
                                      summary: "Summary\(i)",
                                      imageURL: "ImageURL\(i)",
                                      mediaURL: "mediaURL\(i)",
                                      mediaLength: (i*1000)+500,
                                      mediaType: "mediaType\(i)",
                                      mediaDuration: "mediaDuration\(i)",
                                      GUID: "GUID\(i)",
                                      publishDate: "publishDate\(i)",
                                      createdBy: user.id!.int!,
                                      metadata: metadata.id!.int!)
                try podcast.save()
            }
        }catch {
            console.error("\(error)")
            console.error("Error creating Podcasts. Aborting")
            return false
        }
        return true
    }
}
