var {search,file} = require( "./engine" )

var kw = "Touhou"
console.log( "搜索: " + kw )
/*console.log(search({
  q: kw, page: 1
}))*/
console.log(file({
  q: kw
}))