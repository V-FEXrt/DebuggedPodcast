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
    
    func show(request: Request, metadata: Metadata) throws -> ResponseRepresentable {
        return metadata
    }
    
    func makeResource() -> Resource<Metadata> {
        return Resource(
            index: index,
            show: show
        )
    }
}
