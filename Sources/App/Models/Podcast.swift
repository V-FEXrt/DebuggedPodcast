//
//  Podcast.swift
//  DebuggedPodcast
//
//  Created by Ashley Coleman on 4/8/17.
//
//

import Vapor
import Fluent

final class Podcast: Model {
    var id: Node?
    
    var title: String
    var subtitle: String
    var author: String
    var summary: String
    var imageURL: String
    var mediaURL: String
    var mediaLength: Int
    var mediaType: String
    var mediaDuration: String
    var GUID: String
    var publishDate: String
    var createdBy: Int
    var metadata: Int
    
    var exists: Bool = false
    
    init(title: String, author: String, subtitle: String, summary: String, imageURL: String, mediaURL:String, mediaLength: Int, mediaType: String, mediaDuration: String, GUID: String, publishDate: String, createdBy: Int, metadata: Int) {
        self.title = title
        self.subtitle = subtitle
        self.author = author
        self.summary = summary
        self.imageURL = imageURL
        self.mediaURL = mediaURL
        self.mediaLength = mediaLength
        self.mediaType = mediaType
        self.mediaDuration = mediaDuration
        self.GUID = GUID
        self.publishDate = publishDate
        self.createdBy = createdBy
        self.metadata = metadata

    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract(K.API.ID)
        title = try node.extract(K.API.Title)
        subtitle = try node.extract(K.API.Subtitle)
        author = try node.extract(K.API.Author)
        summary = try node.extract(K.API.Summary)
        imageURL = try node.extract(K.API.ImageURL)
        mediaURL = try node.extract(K.API.MediaURL)
        mediaLength = try node.extract(K.API.MediaLength)
        mediaType = try node.extract(K.API.MediaType)
        mediaDuration = try node.extract(K.API.MediaDuration)
        GUID = try node.extract(K.API.GUID)
        publishDate = try node.extract(K.API.PublishDate)
        createdBy = try node.extract(K.API.CreatedBy)
        metadata = try node.extract(K.API.Metadata)
        
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            K.API.ID : id,
            K.API.Title : title,
            K.API.Subtitle : subtitle,
            K.API.Author : author,
            K.API.Summary : summary,
            K.API.ImageURL : imageURL,
            K.API.MediaURL : mediaURL,
            K.API.MediaLength : mediaLength,
            K.API.MediaType : mediaType,
            K.API.MediaDuration : mediaDuration,
            K.API.GUID : GUID,
            K.API.PublishDate : publishDate,
            K.API.CreatedBy : createdBy,
            K.API.Metadata : metadata
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(K.API.Tables.Podcasts) { podcasts in
            podcasts.id()
            podcasts.string(K.API.Title)
            podcasts.string(K.API.Subtitle)
            podcasts.string(K.API.Author)
            podcasts.string(K.API.Summary)
            podcasts.string(K.API.ImageURL)
            podcasts.string(K.API.MediaURL)
            podcasts.int(K.API.MediaLength)
            podcasts.string(K.API.MediaType)
            podcasts.string(K.API.MediaDuration)
            podcasts.string(K.API.GUID)
            podcasts.string(K.API.PublishDate)
            podcasts.parent(idKey: K.API.CreatedBy, optional: false, unique: false, default: nil)
            podcasts.parent(idKey: K.API.Metadata, optional: false, unique: false, default: nil)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(K.API.Tables.Podcasts)
    }
}
