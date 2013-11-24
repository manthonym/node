
db = require('./db') "#{__dirname}/../db/test"

module.exports =
	
  log: (login, password, callback) ->
    userinfo = []
    rs = db.createReadStream
      start: "user:#{login}"
      end: "user:#{login}"
    rs.on 'data', (data) ->
      [mailDB, passwordDB] = data.value.split ':' 
      userinfo.push login: login, password: passwordDB, mail:mailDB if password is passwordDB
    rs.on 'error', callback    
    rs.on 'close', ->
      callback null, userinfo

  save: (login, mail, password, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    ws.write key: "user:#{login}", value: "#{mail}:#{password}"
    ws.end()