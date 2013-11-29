
db = require('./db') "#{__dirname}/../db/test"

module.exports =
  ###
  `get(id, [options], callback)`
  ----------------------------
  Return an array of metrics.

  Parameters
  `id`        Metric id as integer
  `callback`  Contains an err as first argument 
              if any

  Options
  `start`     Timestamp
  `end`       Timestamp
  `timestamp` Step between each metrics 
              in milliseconds
  ###
  get: (id, options, callback) ->
    callback = options if arguments.length is 2
    metrics = []
    rs = db.createReadStream
      start: "metric:#{id}:"
      end: "metric:#{id};"
    rs.on 'data', (data) ->
      [_, id, timestamp] = data.key.split ':'
      metrics.push id: id, timestamp: parseInt(timestamp, 10), value: data.value
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, metrics
  ###
  `save(id, metrics, callback)`
  ----------------------------

  Parameters
  `id`       Metric id as integer
  `metrics`  Array with timestamp as keys 
             and integer as values
  `callback` Contains an err as first argument 
             if any
  ###
  save: (id, metrics, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    if metrics.length > 1
      for metric in metrics
        {timestamp, value} = metric
        ws.write key: "metric:#{id}:#{timestamp}", value: value
      ws.end()
    else
      timestamp = metrics[0].timestamp
      value = metrics[0].value
      ws.write key: "metric:#{id}:#{timestamp}", value: value
      ws.end()

  link: (username, metric_id, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    console.log username
    console.log metric_id
    ws.write key: "user_metrics:#{username}", value: "#{metric_id}"
    console.log "data written"
    ws.end()


  access: (username, metric_id, callback) ->
    list = []
    rs = db.createReadStream
      start: "user_metrics:#{username}"
      end: "user_metrics:#{username};"
    rs.on 'data', (data) ->
      console.log data
      #met = data.value.split ':' 
      #list.push id: met
      list.push data.value
    rs.on 'error', callback    
    rs.on 'close', ->
      callback null, list
















