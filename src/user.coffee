
db = require('./db') "#{__dirname}/../db/test"

module.exports =
	
  log: (login, password, callback) ->
    console.log "LOG CALLED"
    console.log login
    console.log password
    userinfo = []
    rs = db.createReadStream
      start: "user:#{login}:"
      end: "user:#{login};"
    rs.on 'data', (data) ->
      console.log "Data found"
      [mailDB, passwordDB] = data.value.split ':'
      userinfo.push login: login, password: passwordDB, mail:mailDB 
      console.log login
      console.log passwordDB
    rs.on 'error', callback    
    rs.on 'close', ->
      callback null, userinfo

  save: (login, mail, password, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "user:#{login}", value: "#{mail}:#{password}"
    ws.end()