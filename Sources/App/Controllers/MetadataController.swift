//
//  MetadataController.swift
//  DebuggedPodcast
//
//  Created by Ashley Coleman on 4/8/17.
//
//

import Vapor
import HTTP

class MetadataController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Metadata.all().makeNode().converted(to: JSON.self)
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        let params = try Validator.validate(req: request, expected:
            [
                K.API.Title : Type.String,
                K.API.WebsiteURL : Type.String,
                K.API.Copyright : Type.String,
                K.API.Subtitle : Type.String,
                K.API.Summary : Type.String,
                K.API.Description : Type.String,
                K.API.OwnerName : Type.String,
                K.API.OwnerEmail : Type.String,
                K.API.ImageURL : Type.String,
                K.API.Category : Type.String,
                K.API.IsExplicit : Type.Bool
            ])
        
        
        var metadata = Metadata(title: params.string[K.API.Title] ?? "",
                                websiteURL: params.string[K.API.WebsiteURL] ?? "",
                                copyright: params.string[K.API.Copyright] ?? "",
                                subtitle: params.string[K.API.Subtitle] ?? "",
                                summary: params.string[K.API.Summary] ?? "",
                                description: params.string[K.API.Description] ?? "",
                                ownerName: params.string[K.API.OwnerName] ?? "",
                                ownerEmail: params.string[K.API.OwnerEmail] ?? "",
                                image: params.string[K.API.ImageURL] ?? "",
                                category: params.string[K.API.Category] ?? "",
                                isExplicit: params.bool[K.API.IsExplicit] ?? true)
        
        try metadata.save()
        return metadata
    }
    
    func show(request: Request, metadata: Metadata) throws -> ResponseRepresentable {
        return metadata
    }
    
    func delete(request: Request, metadata: Metadata) throws -> ResponseRepresentable {
        try metadata.delete()
        return JSON([:])
    }
    
    func clear(request: Request) throws -> ResponseRepresentable {
        try Metadata.query().delete()
        return JSON([])
    }
    
    func update(request: Request, metadata: Metadata) throws -> ResponseRepresentable {
        let params = try Validator.validate(req: request, expected:
            [
                K.API.Title : Type.String,
                K.API.WebsiteURL : Type.String,
                K.API.Copyright : Type.String,
                K.API.Subtitle : Type.String,
                K.API.Summary : Type.String,
                K.API.Description : Type.String,
                K.API.OwnerName : Type.String,
                K.API.OwnerEmail : Type.String,
                K.API.ImageURL : Type.String,
                K.API.Category : Type.String,
                K.API.IsExplicit : Type.Bool
            ])
        
        
        var metadata = Metadata(title: params.string[K.API.Title] ?? "",
                                websiteURL: params.string[K.API.WebsiteURL] ?? "",
                                copyright: params.string[K.API.Copyright] ?? "",
                                subtitle: params.string[K.API.Subtitle] ?? "",
                                summary: params.string[K.API.Summary] ?? "",
                                description: params.string[K.API.Description] ?? "",
                                ownerName: params.string[K.API.OwnerName] ?? "",
                                ownerEmail: params.string[K.API.OwnerEmail] ?? "",
                                image: params.string[K.API.ImageURL] ?? "",
                                category: params.string[K.API.Category] ?? "",
                                isExplicit: params.bool[K.API.IsExplicit] ?? true)
        
        try metadata.save()
        return metadata
    }
    
    func replace(request: Request, metadata: Metadata) throws -> ResponseRepresentable {
        try metadata.delete()
        return try create(request: request)
    }
    
    func makeResource() -> Resource<Metadata> {
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

}
