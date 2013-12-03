// Generated by CoffeeScript 1.6.3
(function() {
  module.exports = {

    /*
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
     */
    get: function(id, db, options, callback) {
      var metrics, rs;
      if (arguments.length === 3) {
        callback = options;
      }
      metrics = [];
      rs = db.createReadStream({
        start: "metric:" + id + ":",
        end: "metric:" + id + ";"
      });
      rs.on('data', function(data) {
        var timestamp, _, _ref;
        _ref = data.key.split(':'), _ = _ref[0], id = _ref[1], timestamp = _ref[2];
        return metrics.push({
          id: id,
          timestamp: parseInt(timestamp, 10),
          value: data.value
        });
      });
      rs.on('error', callback);
      return rs.on('close', function() {
        return callback(null, metrics);
      });
    },

    /*
    `save(id, metrics, callback)`
    ----------------------------
    
    Parameters
    `id`       Metric id as integer
    `metrics`  Array with timestamp as keys 
               and integer as values
    `callback` Contains an err as first argument 
               if any
     */
    save: function(id, metrics, db, callback) {
      var metric, timestamp, value, ws, _i, _len;
      ws = db.createWriteStream();
      ws.on('error', callback);
      ws.on('close', callback);
      if (metrics.length > 1) {
        for (_i = 0, _len = metrics.length; _i < _len; _i++) {
          metric = metrics[_i];
          timestamp = metric.timestamp, value = metric.value;
          ws.write({
            key: "metric:" + id + ":" + (timestamp * 1000),
            value: value
          });
        }
        return ws.end();
      } else {
        timestamp = metrics[0].timestamp;
        value = metrics[0].value;
        ws.write({
          key: "metric:" + id + ":" + (timestamp * 1000),
          value: value
        });
        return ws.end();
      }
    },
    link: function(username, metric_id, db, callback) {
      var ws;
      console.log('link');
      ws = db.createWriteStream();
      ws.on('error', callback);
      ws.on('close', callback);
      console.log(username);
      console.log(metric_id);
      ws.write({
        key: "user_metrics:" + metric_id + ":" + username,
        value: "1"
      });
      console.log("data written");
      return ws.end();
    },
    access: function(username, metric_id, db, callback) {
      var list, rs;
      list = [];
      rs = db.createReadStream({
        start: "user_metrics:" + metric_id + ":" + username,
        end: "user_metrics:" + metric_id + ":" + username
      });
      rs.on('data', function(data) {
        console.log(data);
        return list.push({
          success: 'true'
        });
      });
      rs.on('error', callback);
      return rs.on('close', function() {
        console.log('size: ' + list.length);
        console.log(list);
        return callback(null, list);
      });
    }
  };

}).call(this);
