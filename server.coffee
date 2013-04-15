express = require 'express'
http    = require 'http'
path    = require 'path'

app = express()
server = http.createServer app

PORT = process.argv[2] or process.env.PORT or 3000
PUBLIC_DIR = path.join __dirname, 'public'

###
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
###
app.use express.static PUBLIC_DIR

server.listen PORT

console.log "Server listening on port #{PORT}"