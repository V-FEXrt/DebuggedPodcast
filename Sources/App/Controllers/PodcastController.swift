//
//  PodcastController.swift
//  DebuggedPodcast
//
//  Created by Ashley Coleman on 4/8/17.
//
//

import Vapor
import HTTP

class PodcastController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Podcast.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        let user = try requireAuth(req: request)
        let metadata = try Metadata.all().first
        
        let params = try Validator.validate(req: request, expected:
            [
                K.API.Title : Type.String,
                K.API.Subtitle : Type.String,
                K.API.Author : Type.String,
                K.API.Summary : Type.String,
                K.API.ImageURL : Type.String,
                K.API.MediaURL : Type.String,
                K.API.MediaLength : Type.Int,
                K.API.MediaType : Type.String,
                K.API.MediaDuration : Type.String,
                K.API.GUID : Type.String,
                K.API.PublishDate : Type.String,
            ])
        
        
        var podcast = Podcast(title: params.string[K.API.Title] ?? "",
                              author: params.string[K.API.Author] ?? "",
                              subtitle: params.string[K.API.Subtitle] ?? "",
                              summary: params.string[K.API.Summary] ?? "",
                              imageURL: params.string[K.API.ImageURL] ?? "",
                              mediaURL: params.string[K.API.MediaURL] ?? "",
                              mediaLength: params.int[K.API.MediaLength] ?? -1,
                              mediaType: params.string[K.API.MediaType] ?? "",
                              mediaDuration: params.string[K.API.MediaDuration] ?? "",
                              GUID: params.string[K.API.GUID] ?? "",
                              publishDate: params.string[K.API.PublishDate] ?? "",
                              createdBy: user.id?.int ?? -1,
                              metadata: metadata?.id?.int ?? -1)
        
        try podcast.save()
        return podcast
    }
    
    func show(request: Request, podcast: Podcast) throws -> ResponseRepresentable {
        return podcast
    }
    
    func delete(request: Request, podcast: Podcast) throws -> ResponseRepresentable {
        _ = try requireAuth(req: request)
        
        try podcast.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        _ = try requireAuth(req: request)
        
        try Podcast.query().delete()
        return JSON([])
    }
    
    func update(request: Request, podcast: Podcast) throws -> ResponseRepresentable {
        let user = try requireAuth(req: request)
        let metadata = try Metadata.all().first
        
        let params = try Validator.validate(req: request, expected:
            [
                K.API.Title : Type.String,
                K.API.Subtitle : Type.String,
                K.API.Author : Type.String,
                K.API.Summary : Type.String,
                K.API.ImageURL : Type.String,
                K.API.MediaURL : Type.String,
                K.API.MediaLength : Type.Int,
                K.API.MediaType : Type.String,
                K.API.MediaDuration : Type.String,
                K.API.GUID : Type.String,
                K.API.PublishDate : Type.String,
                ])
        
        
        var podcast = Podcast(title: params.string[K.API.Title] ?? "",
                              author: params.string[K.API.Author] ?? "",
                              subtitle: params.string[K.API.Subtitle] ?? "",
                              summary: params.string[K.API.Summary] ?? "",
                              imageURL: params.string[K.API.ImageURL] ?? "",
                              mediaURL: params.string[K.API.MediaURL] ?? "",
                              mediaLength: params.int[K.API.MediaLength] ?? -1,
                              mediaType: params.string[K.API.MediaType] ?? "",
                              mediaDuration: params.string[K.API.MediaDuration] ?? "",
                              GUID: params.string[K.API.GUID] ?? "",
                              publishDate: params.string[K.API.PublishDate] ?? "",
                              createdBy: user.id?.int ?? -1,
                              metadata: metadata?.id?.int ?? -1)
        
        try podcast.save()
        return podcast
    }
    
    func replace(request: Request, podcast: Podcast) throws -> ResponseRepresentable {
        _ = try requireAuth(req: request)
        try podcast.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<Podcast> {
        return Resource(
            index: index,
            store: create,
            show: show,
            replace: replace,
            modify: update,
            destroy: delete,
            clear: clear
        )
    }
    
    private func requireAuth(req: Request) throws -> User {
        guard let user = try req.auth.user() as? User else {
            throw Abort.custom(status: Status.unauthorized, message: "Unauthorized")
        }
        return user
    }
    
}
