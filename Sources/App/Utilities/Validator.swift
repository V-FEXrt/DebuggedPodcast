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
    case Bool
}

class Validator {
    static func validate(req: Request, expected:[String: Type]) throws -> (string: [String: String], int: [String: Int], bool: [String: Bool]) {
        var stringParams:[String:String] = [:]
        var intParams:[String:Int] = [:]
        var boolParams:[String:Bool] = [:]
        
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
            case .Bool:
                if let val = req.data[item.key]?.bool {
                    boolParams[item.key] = val
                }else{
                    throw Abort.custom(status: Status.badRequest, message: "\(item.key) should be type: Bool")
                }
                break
            }

        }
        
        return (stringParams, intParams, boolParams)
    }
}
