
db = require('./db') "#{__dirname}/../db/test"

hashes = require 'jshashes'

module.exports =
	
  log: (login, password, callback) ->
    sha256 = new hashes.SHA256
    userinfo = []
    rs = db.createReadStream
      start: "user:#{login}"
      end: "user:#{login}"
    rs.on 'data', (data) ->
      [mailDB, passwordDB] = data.value.split ':' 
      userinfo.push login: login, password: passwordDB, mail:mailDB if sha256.hex(password) is passwordDB
    rs.on 'error', callback    
    rs.on 'close', ->
      callback null, userinfo

  save: (login, mail, password, callback) ->
    sha256 = new hashes.SHA256
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    password_sha = sha256.hex(password)
    ws.write key: "user:#{login}", value: "#{mail}:#{password_sha}"
    ws.end()