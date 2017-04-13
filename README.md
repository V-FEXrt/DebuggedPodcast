# Basic Template

A basic vapor template for starting a new Vapor web application. If you're using vapor toolbox, you can use: `vapor new --template=basic`

## 📖 Documentation

Visit the Vapor web framework's [documentation](http://docs.vapor.codes) for instructions on how to use this package.

## Start up
First, you need to install the vapor toolbox to run the commands from the command line: `curl -sL toolbox.vapor.sh | bash`

Next, make a directory for the database under the root repository folder (should be DebuggedPodcast): `mkdir Data`

Next, we will start the server, which creates the database (which is necessary to seed) and then stop the server so we can seed the database:
```vapor build
vapor run serve
ctrl-c
.build/debug/App seed
vapor run serve```


## 💧 Community

Join the welcoming community of fellow Vapor developers in [slack](http://vapor.team).

## 🔧 Compatibility

This package has been tested on macOS and Ubuntu.
