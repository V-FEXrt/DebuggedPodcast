import Vapor
import HTTP

final class UserController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try User.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        guard let name = request.data["name"]?.string else {
            throw Abort.badRequest
        }
        
        var user = User(name: name)
        try user.save()
        return user
    }

    func show(request: Request, user: User) throws -> ResponseRepresentable {
        return user
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
        guard let name = request.data["name"]?.string else {
            throw Abort.badRequest
        }
        
        var user = user
        user.name = name
        try user.save()
        return user
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
}
