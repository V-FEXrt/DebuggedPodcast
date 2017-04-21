# Basic Template

A basic vapor template for starting a new Vapor web application. If you're using vapor toolbox, you can use: `vapor new --template=basic`

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package.

## Start up
First, you need to install the vapor toolbox to run the commands from the command line: `curl -sL toolbox.vapor.sh | bash`

Next, make a directory for the database under the root repository folder (should be DebuggedPodcast): `mkdir Data`

Next, we will start the server, which creates the database (which is necessary to seed) and then stop the server so we can seed the database:
```
vapor build
vapor run serve
ctrl-c
.build/debug/App seed
vapor run serve
```

Next, you need to install [browserify](http://browserify.org/). And in a second terminal, run: `browserify Client/app.js -o Public/scripts/bundle.js` and `browserify Client/archive.js -o Public/scripts/bundle-archive.js`. This should be done before you attempt to request the page. This also will make it so that you don't need to restart your server if you change the javascript.

To change the domain in which the server will process requests from:
```
rm Data/database.sqlite
vapor run serve
ctrl-c
.build/debug/App admin
.build/debug/App import
```
And follow the prompts.

## 💧 Community

Join the welcoming community of fellow Vapor developers in [slack](http://vapor.team).

## 🔧 Compatibility

This package has been tested on macOS and Ubuntu.
