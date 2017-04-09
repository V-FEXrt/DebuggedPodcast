import Vapor
import VaporSQLite

import Auth

let drop = Droplet()

// MARK: Middleware

let auth = AuthMiddleware(user: User.self)
drop.middleware.append(auth)

let error = Abort.custom(status: .forbidden, message: "Invalid credentials.")
let protect = ProtectMiddleware(error: error)

// MARK: Preparations

try drop.addProvider(VaporSQLite.Provider.self)
drop.preparations.append(User.self)
drop.preparations.append(Metadata.self)
drop.preparations.append(Podcast.self)

// MARK: Resources
drop.resource(K.API.Tables.Users, UserController())
drop.resource(K.API.Tables.Metadatas, MetadataController())
drop.resource(K.API.Tables.Podcasts, PodcastController())

// MARK: Routes

drop.get { req in
    return try drop.view.make("index.html")
}

drop.get("login") { req in
    return try drop.view.make("login.html")
}

drop.post("login") { req in
    let params = try Validator.validate(req: req, expected:
    [
        K.API.Email : Type.String,
        K.API.Password: Type.String
    ])
    
    let email = params.string[K.API.Email] ?? ""
    
    guard let user = try User.query().filter(K.API.Email, params.string[K.API.Email] ?? "").first() else {
        throw Abort.notFound
    }
    
    let crypted =  try User.cryptPassword(password: params.string[K.API.Password] ?? "", salt: user.salt)
    
    let key = APIKey(id: params.string[K.API.Email] ?? "", secret: crypted)
    
    try req.auth.login(key)
    
    return "Logged In"
}

// MARK: Authorized Routes


drop.grouped(protect).group("admin") { admin in
    admin.get { req in
        guard let user = try req.auth.user() as? User else {
            throw Abort.custom(status: .badRequest, message: "Invalid user type.")
        }
        
        return "Welcome to the admin page \(user.firstName)"
    }
}



// MARK: Run Droplet
drop.run()
