mongoose = require 'mongoose'

schema = mongoose.Schema
  name: String

module.exports = Player = mongoose.model 'Player', schema
