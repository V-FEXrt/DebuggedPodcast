import Vapor
import VaporSQLite

let drop = Droplet()
try drop.addProvider(VaporSQLite.Provider.self)

drop.preparations.append(User.self)

drop.get { req in
    return try drop.view.make(drop.config["app", "root_path"]?.string ?? "")
}

drop.resource("users", UserController())

drop.run()
