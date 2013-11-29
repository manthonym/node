
http = require 'http'
stylus = require 'stylus'
express = require 'express'
metrics = require './metrics'
#user = require './user'

app = express()

app.set 'views', __dirname + '/../views'
app.set 'view engine', 'jade'
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser 'my secret here'
app.use express.session()
app.use app.router
app.use stylus.middleware "#{__dirname}/../public"
app.use express.static "#{__dirname}/../public"
app.use express.errorHandler
  showStack: true
  dumpExceptions: true

app.get '/', (req, res) ->
  if req.cookies.remember
    console.log req.cookies.remember
    res.render 'index', title: 'Metrics', name: req.cookies.remember
  else res.render 'user/login', title: 'Login'

metric_get = (req, res, next) ->
  metrics.access req.cookies.remember, req.params.id, (err, values) ->
    return next err if err
    console.log values
  metrics.get req.params.id, (err, values) ->
    return next err if err
    res.json
      id: req.params.id
      values: values
app.get '/metric/:id.json', metric_get
app.get '/metric?metric=:id', metric_get

app.get '/login', (req, res) ->
  if req.cookies.remember
    res.render 'index', title: 'Metrics', name: req.cookies.remember
  else res.render 'user/login', title: 'Login'

app.get '/user/add', (req, res) ->
  res.render 'user/add', title: 'Add a user'

app.post '/user/create', (req, res) ->
  user.save req.body.username, req.body.mail, req.body.password, (err) ->
    return next err if err
    res.render 'user/confirm', title: 'Confirmation'

app.post '/user/connect', (req, res) ->
  user.log req.body.username, req.body.password, (err, values) ->
    return next err if err
    if values.length is 1
      minute = 30 * 60 * 1000
      res.cookie 'remember', req.body.username, { maxAge: minute, httpOnly: false }
      console.log 'Cookie set'
      console.log req.cookies.remember
      res.render 'index', name: values[0].login if values[0].password is req.body.password
    else
      res.render 'user/error'

app.get '/data/add', (req, res) ->
  res.render 'data/add', title: 'Add a metric'

app.get '/logout', (req, res) ->
  res.clearCookie 'remember'
  res.render 'user/logout', title: 'Logout'

app.post '/data/save', (req, res, next) ->
  values = []
  values.push timestamp: req.body.timestamp, value: req.body.val
  metrics.link req.cookies.remember, req.body.id, (err) ->
    return next err if err
  metrics.save req.body.id, values, (err) ->
    return next err if err
    res.render 'data/confirm'

app.post '/metric/:id.json', (req, res, next) ->
  values = JSON.parse req.body
  metrics.save req.params.id, values, (err) ->
    return next err if err
    res.json status: 'OK'

app.delete '/metric/:id.json', (req, res, next) ->
  metrics.remove req.params.id, (err) ->
    return next err if err
    res.json status: 'OK'

http.createServer(app).listen 1234, ->
  console.log 'http://localhost:1234'

