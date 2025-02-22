require! "express"
require! fs
require! url
require! path
require! "./engine"

app = express()
# 这个目录是给vercel读的
app.use "/_pages", express.static "#{__dirname}/assets"
app.use "/public", express.static "#{__dirname}/public"
loadBody = (path, title = "ProxyBrowser") ->
  source = fs.readFileSync("#{__dirname}/assets/template.html").toString!
  source = source.replace "{{body}}", fs.readFileSync("#{__dirname}/#path").toString!
  source = source.replace "{{title}}", title
  source
getParams = (requrl) ->
  dt = {}
  for param in url.parse(requrl).query.split("&")
    [key,value] = param.split "="
    dt[ decodeURIComponent key ] = decodeURIComponent value
  dt
app.get "/", (req,res) ->
  res
    ..status 200
    ..send loadBody "assets/index.html"
    ..end!
app.get "/search", (req,res) ->
  params = getParams req.url
  page = loadBody( "assets/search.html", params.search )
  safe = 0
  if params.search == "" then params.search = "Google"
  if params.safe is "safe"
    safe = 2
  if params.type !== "files"
    data = []
    {suggestion,result} = engine.search {q:params.search, page: (params.p or 1)}
    for site in result
      data.push "<div class=\"card\">
        <h4 class=title>#{site.title}</h4>
        <a> #{site.url.join " > "}</a>
        <div>#{site.content}</div>
      </div>"
    page = page.replace "{{sugg}}", "<li><a>#{suggestion.join "</a></li><li><a>"}</a></li>"
    page = page.replace "{{datas}}", data.join "\n"
  else
    data = []
    page = page.replace "{{sugg}}", "<li><a>#{params.search}</a></li>"
    for site in engine.file( params.search )
      data.push "<div class=\"card\">
        <h4 class=title>#{site.title}</h4><br>
        <a>#{site.url.join " > "}</a>
        <div>
          <a href=\"#{site.magnet}\">磁力链接</a>
          <div>#{site.status}</div>
        </div>
      </div>"
    page = page.replace "{{datas}}", data.join "\n"
  res.send page
app.all "/proxy*", (req, res) ->
  res.send loadBody( "assets/proxy.html" )
app.use (req,res) ->
  res
    ..status 404
    ..send loadBody( "assets/404.html", "404Error" )
    ..end!
port = parseInt(Math.floor((Math.random()*1000)).toString().padEnd(4, "0"))
if port === 3000 then port += 1
app.listen (process.env.PORT or port), ->
  console.log "ServerAlreadyStart At : " + port
module.exports = app