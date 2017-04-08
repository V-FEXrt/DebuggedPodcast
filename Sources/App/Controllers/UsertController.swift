import Vapor
import HTTP

final class UserController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: try User.all().map({ return try safeUser(user: $0) }))
    }

    func create(request: Request) throws -> ResponseRepresentable {
        let params = try Validator.validate(req: request, expected:
            [
               K.API.FirstName : Type.String,
               K.API.LastName : Type.String,
               K.API.Email : Type.String,
               K.API.Password : Type.String
            ])
        
        
        var user = try User(first: params.string[K.API.FirstName] ?? "",
                        last: params.string[K.API.LastName] ?? "",
                        email: params.string[K.API.Email] ?? "",
                        password: params.string[K.API.Password] ?? "")
        try user.save()
        return try safeUser(user: user)
    }

    func show(request: Request, user: User) throws -> ResponseRepresentable {
        return try safeUser(user: user)
    }

    func delete(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return JSON([:])
    }

    func clear(request: Request) throws -> ResponseRepresentable {
        try User.query().delete()
        return JSON([])
    }

    func update(request: Request, user: User) throws -> ResponseRepresentable {
        let params = try Validator.validate(req: request, expected:
            [
                K.API.FirstName : Type.String,
                K.API.LastName : Type.String,
                K.API.Email : Type.String,
                K.API.Password : Type.String
            ])
        
        
        var user = try User(first: params.string[K.API.FirstName] ?? "",
                        last: params.string[K.API.LastName] ?? "",
                        email: params.string[K.API.Email] ?? "",
                        password: params.string[K.API.Password] ?? "")
        try user.save()
        return try safeUser(user: user)
    }

    func replace(request: Request, user: User) throws -> ResponseRepresentable {
        try user.delete()
        return try create(request: request)
    }

    func makeResource() -> Resource<User> {
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
    
    private func safeUser(user: User) throws -> JSON {
        return try JSON(node: try user.makeSafeNode())
    }
}
