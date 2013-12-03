
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
  get: (id, db, options, callback) ->
    callback = options if arguments.length is 3
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
  save: (id, metrics, db, callback) ->
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    if metrics.length > 1
      for metric in metrics
        {timestamp, value} = metric
        ws.write key: "metric:#{id}:#{timestamp*1000}", value: value
      ws.end()
    else
      timestamp = metrics[0].timestamp
      value = metrics[0].value
      ws.write key: "metric:#{id}:#{timestamp*1000}", value: value
      ws.end()

  ###
  `link (username, metric_id, db, callback)`
  ----------------------------
  Store the username of the user when he creates a new metric

  Parameters
  `username` Username of the metric creator, string
  `metric_id`ID of the metric
  `db`       Database handler
  `callback` Contains an err as first argument 
             if any
  ###
  link: (username, metric_id, db, callback) ->
    console.log 'link'
    ws = db.createWriteStream()
    ws.on 'error', callback
    ws.on 'close', callback
    console.log username
    console.log metric_id
    ws.write key: "user_metrics:#{metric_id}:#{username}", value: "1"
    console.log "data written"
    ws.end()

  ###
  `access (username, metric_id, db, callback)`
  ----------------------------
  Check if the given user can access to the given metric

  Parameters
  `username` Username of the metric creator, string
  `metric_id`ID of the metric
  `db`       Database handler
  `callback` Contains an err as first argument 
             if any
  ###
  access: (username, metric_id, db, callback) ->
    list = []
    rs = db.createReadStream
      start: "user_metrics:#{metric_id}:#{username}"
      end: "user_metrics:#{metric_id}:#{username}"
    rs.on 'data', (data) ->
      console.log data
      list.push success: 'true'
    rs.on 'error', callback    
    rs.on 'close', ->
      console.log 'size: ' + list.length
      console.log list
      callback null, list















