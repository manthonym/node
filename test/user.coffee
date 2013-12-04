{exec} = require 'child_process'
should = require 'should'
db = require('./db') "#{__dirname}/../db/test"

describe "user", () ->

  user = null
  before (next) ->
    exec "rm -rf #{__dirname}/../db/test && mkdir #{__dirname}/../db/test", (err, stdout) ->
      user = require '../lib/user'
      next err

  it "create and log a user", (next) ->
    user.save 'test', 'testmail', 'testpassword', db, (err) ->
      return next err if err
      user.log 'test', 'testpassword' db, (err, values) ->
        return next err if err 
        values.length.should.be.above 0
        next()

