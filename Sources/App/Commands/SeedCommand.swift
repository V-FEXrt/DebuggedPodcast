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
            console.print("Email: 'test@debuggedpodcast.com'")
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
                                copyright: "© 2017 Debugged Podcast",
                                subtitle: "Banter you didn't know you could care about",
                                author: "Eric Schmar, Tyler Aden, Matthew Wilderson, Ashley Coleman",
                                summary: "We are a group of computer science (and mathematics) majors at Kansas State University. This podcast contains a free range of topics; some funny, some serious, and some just strange.",
                                description: "We are a group of computer science (and mathematics) majors at Kansas State University. This podcast contains a free range of topics; some funny, some serious, and some just strange.",
                                ownerName: "Ashley Coleman",
                                ownerEmail: "test@debuggedpodcast.com",
                                imageURL: "http://debuggedpodcast.com/images/cover.jpg",
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

            var podcast = Podcast(title: "dun even matter",
                                  author: "Eric Schmar, Tyler Aden, Jake Ehrlich, Ashley Coleman",
                                  subtitle: "",
                                  summary: "The pals have a heated rant about things that don't matter with special guest business man Jake Ehrlich.",
                                  imageURL: "http://debuggedpodcast.com/images/cover.jpg",
                                  mediaURL: "http://debuggedpodcast.com/media/ep10.mp3",
                                  mediaLength: 36409869,
                                  mediaType: "audio/mpeg",
                                  mediaDuration: "24:11",
                                  GUID: "612701D9-CC58-4CB8-AA79-1BAD467C5370",
                                  publishDate: "Sat, 11 Mar 2017 14:58:05 -0000",
                                  createdBy: user.id!.int!,
                                  metadata: metadata.id!.int!)
            try podcast.save()

        }catch {
            console.error("\(error)")
            console.error("Error creating Podcasts. Aborting")
            return false
        }
        return true
    }
}
