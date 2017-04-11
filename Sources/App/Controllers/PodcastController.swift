//
//  PodcastController.swift
//  DebuggedPodcast
//
//  Created by Ashley Coleman on 4/8/17.
//
//

import Vapor
import HTTP
import Foundation
import FormData

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
                K.API.MediaDuration : Type.String
            ])

        
        var imageURL = metadata?.imageURL ?? ""
        let domain = metadata?.websiteURL ?? ""
        
        let filename = try "ep\(Podcast.all().count).mp3"
        
        if let url = request.data[K.API.ImageURL]?.string {
            imageURL = url
        }
        
        guard let file = request.data[K.API.Media] as? FormData.Field else {
            throw Abort.custom(status: Status.badRequest, message: "media should be type: Multipart Binary")
        }
        
        try Data(file.part.body).write(to: URL(fileURLWithPath: drop.workDir + "/Public/media/\(filename)"))
        
        let df:DateFormatter = DateFormatter()
        df.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"; //RFC2822-Format
        df.locale = Locale(identifier: "en_US_POSIX")
        let date:String = df.string(from: Date())
        
        var podcast = Podcast(title: params.string[K.API.Title] ?? "",
                              author: params.string[K.API.Author] ?? "",
                              subtitle: params.string[K.API.Subtitle] ?? "",
                              summary: params.string[K.API.Summary] ?? "",
                              imageURL: imageURL,
                              mediaURL: "\(domain)/media/\(filename)",
                              mediaLength: file.part.body.count,
                              mediaType: "audio/mpeg",
                              mediaDuration: params.string[K.API.MediaDuration] ?? "",
                              GUID: UUID().uuidString,
                              publishDate: date,
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
            /*modify: update,*/
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
