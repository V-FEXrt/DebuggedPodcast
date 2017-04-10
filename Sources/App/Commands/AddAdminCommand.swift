//
//  AddAdminCommand.swift
//  DebuggedPodcast
//
//  Created by Ashley Coleman on 4/8/17.
//
//

import Vapor
import Console

final class AddAdminCommand: Command {
    public let id = "admin"
    public let help = ["Add an Admin to the podcast"]
    public let console: ConsoleProtocol
    
    public init(console: ConsoleProtocol) {
        self.console = console
    }
    
    public func run(arguments: [String]) throws {
        
        User.database = drop.database
        
        var firstName = ""
        var lastName = ""
        var email = ""
        var password = ""
        
        repeat {
            firstName = console.ask("First Name: ")
            lastName = console.ask("Last Name: ")
            email = console.ask("Email: ")
            
            while true {
                console.output("Password: ", style: .info, newLine: true)
                console.output("> ", style: .info, newLine: false)
                password = console.ask("", style: .custom(ConsoleColor.black))
                console.output("Password: ", style: .info, newLine: true)
                console.output("> ", style: .info, newLine: false)
                if(password != console.ask("Retype Password: ", style: .custom(.black))){
                    console.error("Password mismatch. Try again")
                    console.print()
                }else{
                    break
                }
            }
            
            
            console.print()
            
            console.print("First Name: " + firstName)
            console.print("Last Name: " + lastName)
            console.print("Email: " + email)
            
        } while console.ask("Is the Admin info correct? (y/n):").trim().lowercased() != "y"
        
        do {
            var user = try User(first: firstName, last: lastName, email: email, password: password)
            try user.save()
        } catch {
            console.error("\(error)")
            console.error("Error setting metadata. Aborting")
            
            return
        }
        
        console.success("Admin added")
        console.print()
    }
}
