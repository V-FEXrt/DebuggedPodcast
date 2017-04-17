import Vapor
import VaporSQLite

import Auth

let drop = Droplet()

// MARK: Custom Commands
drop.commands.append(SeedCommand(console: drop.console))
drop.commands.append(SetMetadataCommand(console: drop.console))
drop.commands.append(AddAdminCommand(console: drop.console))
drop.commands.append(ImportRSSCommand(console: drop.console))

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

drop.resource(K.API.Tables.Metadatas, MetadataController())
drop.resource(K.API.Tables.Podcasts, PodcastController())

// MARK: Routes

drop.get { req in
    return try drop.view.make("index.html")
}

drop.get("archive") { req in
    return try drop.view.make("archive.html")
}

drop.get("login") { req in
    return try drop.view.make("login.html")
}

drop.get("feed/podcast.rss") { req in
    var podcasts:[Node] = []

    for podcast in try Podcast.all() {
        let node:Node = [
            K.API.Title : Node(podcast.title),
            K.API.Subtitle : Node(podcast.subtitle),
            K.API.Author : Node(podcast.author),
            K.API.Summary : Node(podcast.summary),
            K.API.ImageURL : Node(podcast.imageURL),
            K.API.MediaURL : Node(podcast.mediaURL),
            K.API.MediaLength : Node(podcast.mediaLength),
            K.API.MediaType : Node(podcast.mediaType),
            K.API.MediaDuration : Node(podcast.mediaDuration),
            K.API.GUID : Node(podcast.GUID),
            K.API.PublishDate : Node(podcast.publishDate)
        ]

        podcasts.append(node)
    }

    guard let metadata = try Metadata.all().first else {
        throw Abort.badRequest
    }

    let response = try drop.view.make("feed", [
        K.API.Title : Node(metadata.title),
        K.API.WebsiteURL : Node(metadata.websiteURL),
        K.API.Copyright : Node(metadata.copyright),
        K.API.Subtitle : Node(metadata.subtitle),
        K.API.Author: Node(metadata.author),
        K.API.Summary : Node(metadata.summary),
        K.API.Description : Node(metadata.description),
        K.API.OwnerName : Node(metadata.ownerName),
        K.API.OwnerEmail : Node(metadata.ownerEmail),
        K.API.ImageURL : Node(metadata.imageURL),
        K.API.Category : Node(metadata.category),
        K.API.IsExplicit : Node(metadata.isExplicit),
        K.API.Tables.Podcasts : Node(podcasts)
        ]).makeResponse()

    response.headers["Content-Type"] = "application/xml"
    return response
}

drop.post("login") { req in
    let params = try Validator.validate(req: req, expected:
    [
        K.API.Email : Type.String,
        K.API.Password: Type.String
    ])

    let email = params.string[K.API.Email] ?? ""

    guard let user = try User.query().filter(K.API.Email, email).first() else {
        throw Abort.notFound
    }

    let crypted =  try User.cryptPassword(password: params.string[K.API.Password] ?? "", salt: user.salt)

    let key = APIKey(id: params.string[K.API.Email] ?? "", secret: crypted)

    try req.auth.login(key)

    return JSON([])
}

// MARK: Authorized Routes


drop.grouped(protect).group("") { admin in
    admin.get("/admin") { req in
        guard let user = try req.auth.user() as? User else {
            throw Abort.custom(status: .badRequest, message: "Invalid user type.")
        }

        return "Welcome to the admin page \(user.firstName)"
    }

    // MARK: Authorized Resource
    admin.resource(K.API.Tables.Users, UserController())
}



// MARK: Run Droplet
drop.run()
