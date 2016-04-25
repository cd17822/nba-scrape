express = require 'express'
app = express()
mongoose = require 'mongoose'
bodyParser = require 'body-parser'
rek = require 'rekuire'
indexRouter = rek 'routes/index'

# connect to mongo
mongoose.connect 'mongodb://localhost/nba-scrape'

# configure server
app.disable 'x-powered-by'
app.use bodyParser.urlencoded extended: yes
app.use bodyParser.json()

# serve static assets
app.use express.static 'public'

# use jade templating engine
app.set 'view engine', 'jade'
app.set 'views', 'views'

# configure routes
app.use '/', indexRouter

# start server
PORT = 2323
app.listen PORT, -> console.log "Listening on #{PORT}"
