//
//  Validator.swift
//  DebuggedPodcast
//
//  Created by Ashley Coleman on 4/8/17.
//
//

import Vapor
import HTTP

enum Type {
    case Int
    case String
}

class Validator {
    static func validate(req: Request, expected:[String: Type]) throws -> (string: [String: String], int: [String: Int]) {
        var stringParams:[String:String] = [:]
        var intParams:[String:Int] = [:]
        
        for item in expected{
            
            switch item.value {
            case .Int:
                if let val = req.data[item.key]?.int {
                    intParams[item.key] = val
                }else{
                    throw Abort.custom(status: Status.badRequest, message: "\(item.key) should be type: Int")
                }
                break
            case .String:
                if let val = req.data[item.key]?.string {
                    stringParams[item.key] = val
                }else{
                    throw Abort.custom(status: Status.badRequest, message: "\(item.key) should be type: String")
                }
                break
            }
        }
        
        return (stringParams, intParams)
    }
}
