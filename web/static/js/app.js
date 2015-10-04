import "deps/phoenix_html/web/static/js/phoenix_html"
import {Socket} from "deps/phoenix/web/static/js/phoenix"

let div   = document.getElementById('elmTarget')
let myApp = Elm.embed(Elm.Main, div, {counter: 5})
