
hashes = require 'jshashes'

module.exports =
	
  ###
  `log (login, password, db, callback)`
  ----------------------------
  Check if the given login matches with the given password to authenticate the user

  Parameters
  `login`    Username of the metric creator, string
  `password` Chosen password, will be encrypted using SHA256 algo
  `db`       Database handler
  `callback` Contains an err as first argument 
             if any
  ###
  log: (login, password, db, callback) ->
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

  ###
  `save (login, password, db, callback)`
  ----------------------------
  Create a new user and stores information in the database

  Parameters
  `login`    Username of the metric creator, string
  `password` Chosen password, will be encrypted using SHA256 algo
  `db`       Database handler
  `callback` Contains an err as first argument 
             if any
  ###
  save: (login, mail, password, db, callback) ->
    sha256 = new hashes.SHA256
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    password_sha = sha256.hex(password)
    ws.write key: "user:#{login}", value: "#{mail}:#{password_sha}"
    ws.end()