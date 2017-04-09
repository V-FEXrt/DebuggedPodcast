//
//  Metadata.swift
//  DebuggedPodcast
//
//  Created by Ashley Coleman on 4/8/17.
//
//

import Vapor
import Fluent

final class Metadata: Model {
    var id: Node?
    
    var title: String
    var websiteURL: String
    var copyright: String
    var subtitle: String
    var summary: String
    var description: String
    var ownerName: String
    var ownerEmail: String
    var image: String
    var category: String
    var isExplicit: Bool
    
    var exists: Bool = false
    
    init(title: String, websiteURL: String, copyright: String, subtitle: String, summary: String, description: String, ownerName: String, ownerEmail: String, image: String, category: String, isExplicit: Bool) {
        self.title = title
        self.websiteURL = websiteURL
        self.copyright = copyright
        self.subtitle = subtitle
        self.summary = summary
        self.description = description
        self.ownerName = ownerName
        self.ownerEmail = ownerEmail
        self.image = image
        self.category = category
        self.isExplicit = isExplicit
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract(K.API.ID)
        title = try node.extract(K.API.Title)
        websiteURL = try node.extract(K.API.WebsiteURL)
        copyright = try node.extract(K.API.Copyright)
        subtitle = try node.extract(K.API.Subtitle)
        summary = try node.extract(K.API.Summary)
        description = try node.extract(K.API.Description)
        ownerName = try node.extract(K.API.OwnerName)
        ownerEmail = try node .extract(K.API.OwnerEmail)
        image = try node.extract(K.API.ImageURL)
        category = try node.extract(K.API.Category)
        isExplicit = try node.extract(K.API.IsExplicit)
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            K.API.ID : id,
            K.API.Title : title,
            K.API.WebsiteURL : websiteURL,
            K.API.Copyright : copyright,
            K.API.Subtitle : subtitle,
            K.API.Summary : summary,
            K.API.Description : description,
            K.API.OwnerName : ownerName,
            K.API.OwnerEmail : ownerEmail,
            K.API.ImageURL : image,
            K.API.Category : category,
            K.API.IsExplicit : isExplicit
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(K.API.Tables.Metadatas) { metadata in
            metadata.id()
            metadata.string(K.API.Title)
            metadata.string(K.API.WebsiteURL)
            metadata.string(K.API.Copyright)
            metadata.string(K.API.Subtitle)
            metadata.string(K.API.Summary)
            metadata.string(K.API.Description)
            metadata.string(K.API.OwnerName)
            metadata.string(K.API.OwnerEmail)
            metadata.string(K.API.ImageURL)
            metadata.string(K.API.Category)
            metadata.bool(K.API.IsExplicit)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(K.API.Tables.Metadatas)
    }
}
