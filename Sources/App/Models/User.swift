import Vapor
import Fluent
import BCrypt
import Auth

final class User: Model {
    var id: Node?
    
    var firstName: String
    var lastName: String
    var email: String
    var salt: String
    var cryptedPassword: String = ""
    
    var exists: Bool = false
    
    init(first: String, last: String, email: String, password: String) throws {
        self.firstName = first
        self.lastName = last
        self.email = email
        let salt = BCryptSalt().string
        self.salt = salt
        do {
            self.cryptedPassword = try User.cryptPassword(password: password, salt: salt)
        }
        catch {
            throw Abort.serverError
        }
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract(K.API.ID)
        firstName = try node.extract(K.API.FirstName)
        lastName = try node.extract(K.API.LastName)
        email = try node.extract(K.API.Email)
        salt = try node.extract(K.API.Salt)
        cryptedPassword = try node.extract(K.API.CryptedPassword)
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            K.API.ID: id,
            K.API.FirstName: firstName,
            K.API.LastName : lastName,
            K.API.Email : email,
            K.API.CryptedPassword : cryptedPassword,
            K.API.Salt : salt
            ])
    }
    
    func makeSafeNode() throws -> Node {
        return try Node(node: [
            K.API.ID: id,
            K.API.FirstName: firstName,
            K.API.LastName : lastName,
            K.API.Email : email
            ])
    }
    
    static func cryptPassword(password:String, salt:String) throws -> String {
        return try BCrypt.digest(password: password, salt: BCryptSalt(string: salt))
    }
    
    static func prepare(_ database: Database) throws {
        try database.create(K.API.Users) { users in
            users.id()
            users.string(K.API.FirstName)
            users.string(K.API.LastName)
            users.string(K.API.Email, length: nil, optional: false, unique: true, default: nil)
            users.string(K.API.CryptedPassword)
            users.string(K.API.Salt)
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(K.API.Users)
    }
}

extension User: Auth.User {
    static func authenticate(credentials: Credentials) throws -> Auth.User {
        let user: User?
        
        switch credentials {
        case let id as Identifier:
            user = try User.find(id.id)
        case let apiKey as APIKey:
            user = try User.query().filter(K.API.Email, apiKey.id).filter(K.API.CryptedPassword, apiKey.secret).first()
        default:
            throw Abort.custom(status: .badRequest, message: "Invalid credentials.")
        }
        
        guard let u = user else {
            throw Abort.custom(status: .badRequest, message: "User not found.")
        }
        
        return u
    }
    
    static func register(credentials: Credentials) throws -> Auth.User {
        throw Abort.custom(status: .methodNotAllowed, message: "Not supported")
    }
}
