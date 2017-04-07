import Vapor
import VaporSQLite

let drop = Droplet()
try drop.addProvider(VaporSQLite.Provider.self)

drop.preparations.append(User.self)

drop.get { req in
    return try drop.view.make("index.html")
}

drop.resource("users", UserController())

drop.run()
