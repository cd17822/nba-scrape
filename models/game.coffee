mongoose = require 'mongoose'
rek = require 'rekuire'
Player = rek 'models/player'

schema = mongoose.Schema
  player: {type: mongoose.Schema.ObjectId, ref: 'Player'}
  date: Date
  team: String
  home: Boolean
  opp: String
  started: Boolean
  mins: Number
  fg: Number
  fga: Number
  threes: Number
  threepa: Number
  threepct: Number
  ft: Number
  fta: Number
  ftpct: Number
  orb: Number
  drb: Number
  trb: Number
  ast: Number
  stl: Number
  blk: Number
  tov: Number
  pf: Number
  pts: Number
  gmsc: Number

module.exports = Game = mongoose.model 'Game', schema
