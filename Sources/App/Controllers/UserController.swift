import Vapor
import HTTP

final class UserController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: try User.all().map({ return try safeUser(user: $0) }))
    }

    func show(request: Request, user: User) throws -> ResponseRepresentable {
        return try safeUser(user: user)
    }

    func makeResource() -> Resource<User> {
        return Resource(
            index: index,
            show: show
        )
    }
    
    private func safeUser(user: User) throws -> JSON {
        return try JSON(node: try user.makeSafeNode())
    }
}
