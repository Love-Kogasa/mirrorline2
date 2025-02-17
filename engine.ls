require! "cheerio"
request = require "sync-request"
export search = ->
  url = "https://searx.bndkt.io/search?q=#{it.q}&category=#{it.type or "general"}&pageno=#{it.page or 1}&language=all&time_range=&safesearch=#{it.safe or 0}&theme=simple"
  data = []
  suggestion = []
  dom = cheerio.load request( "GET", url ).getBody!
  dom( ".result" ).each ->
    dt =
      title : dom(@).find( "h3" ).text!
      content: dom(@).find( ".content" ).text!
      url: dom(@).find( ".url_wrapper" ).text!.split " › "
    data.push dt
  dom( ".suggestion" ).each ->
    suggestion.push dom(@).val!
  {suggestion,result: data}

export file = ->
  url = "https://searx.bndkt.io/search?q=#{it.q}&categories=files&pageno=#{it.page or 1}&language=all&time_range=&safesearch=#{it.safe or 0}&theme=simple"
  data = []
  dom = cheerio.load request( "GET", url ).getBody!
  dom( ".result" ).each ->
    dt =
      title : dom(@).find( "h3" ).text!
      magnet: dom(@).find( ".magnetlink" ).attr( "href" )
      status : dom(@).find( ".stat" ).text!
      url: dom(@).find( ".url_wrapper" ).text!.split " › "
    data.push dt
  data
