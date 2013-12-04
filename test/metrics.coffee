{exec} = require 'child_process'
should = require 'should'
db = require('./db') "#{__dirname}/../db/test"

describe "metrics", () ->

  metrics = null
  before (next) ->
    exec "rm -rf #{__dirname}/../db/test && mkdir #{__dirname}/../db/test", (err, stdout) ->
      metrics = require '../lib/metrics'
      next err

  it "get a metric", (next) ->
    metrics.save 'metric_1', [
      timestamp:(new Date '2013-11-04 14:00 UTC').getTime(), value:123
     ,
      timestamp:(new Date '2013-11-04 14:10 UTC').getTime(), value:456
    ], db, (err) ->
      return next err if err
      metrics.get 'metric_1', db, (err, metrics) ->
        return next err if err 
        metrics.length.should.be.above 1
        [m1, m2] = metrics
        m1.timestamp.should.eql (new Date '2013-11-04 14:00 UTC').getTime()
        m1.value.should.eql 123
        m2.timestamp.should.eql m1.timestamp + 10*60*1000
        next()

  it "save a metric and access to it", (next) ->
    metrics.link 'test', '90', db, (err) ->
      return next err if err
      metrics.access 'test', '90' db, (err, values) ->
        return next err if err 
        values.length.should.be.above 0
        next()

