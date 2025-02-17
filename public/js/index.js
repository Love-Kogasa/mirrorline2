var params = (() => {
  var params = {}
  for( let param of window.location.search.slice( 1 ).split( "&" )){
    let [key, value] = param.split( "=" )
    params[ key ] = decodeURIComponent( value )
  }
  return params
})()
$( document ).ready( () => {
  // $( "#contains" ).html( $( "#contains" ).html().replace(new RegExp( "(" + params["search"] + ")", "g"), "<a>$1</a>" ) )
  if( params.safe == "safe" ){
    $( "#safe" ).prop( "checked", true )
  }
  $( "#sites" ).click(() => {
    $( "#type" ).val( "default" )
    document.getElementById( "go" ).click()
  })
  $( "#files" ).click(() => {
    $( "#type" ).val( "files" )
    document.getElementById( "go" ).click()
  })
  $( "#search" ).val( params[ "search" ] )
  $( "#suggestions" ).find( "a" ).each(() => {
    $(this).attr( "href", "/search?q=" + encodeURIComponent( $(this).text().slice(2).trim() ) + "&page=1" )
  })
  if( parseInt(params[ "p" ]) > 1 ){
    var upone = $( "<a>← 上一页</a>" )
    upone.click(() => {
      $("#p").val( parseInt(params[ "p" ]) - 1 )
      document.getElementById( "go" ).click()
    })
    $( "#golink" ).append( upone )
    $( "#golink" ).append( $("<span> | </span>") )
  }
  var next = $( "<a>下一页 →</a>" )
  next.click(() => {
    $("#p").val( parseInt(params[ "p" ]) + 1 )
    document.getElementById( "go" ).click()
  })
  $( "#golink" ).append( next )
  $( "#contains" ).find( ".card" ).each(function(){
    var card = $(this)
    card.click(() => {
      var to = new URL(card.find( "a" ).text().split( " > " ).join( "/" ))
      document.cookie = "url=" + to.origin
      window.location.href = "/proxy" + hash( new Date()) + to.pathname + to.search
    })
  })
})