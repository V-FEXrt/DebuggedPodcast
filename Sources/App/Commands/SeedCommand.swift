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
    public let id = "command"
    public let help = ["This command does things, like foo, and bar."]
    public let console: ConsoleProtocol
    
    public init(console: ConsoleProtocol) {
        self.console = console
    }
    
    public func run(arguments: [String]) throws {
        console.print("running custom command...")
    }
}
