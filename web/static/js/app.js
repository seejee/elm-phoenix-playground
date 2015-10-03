import "deps/phoenix_html/web/static/js/phoenix_html"
import {Socket} from "deps/phoenix/web/static/js/phoenix"

let div   = document.getElementById('elmTarget')
let myApp = Elm.embed(Elm.Main, div, {counter: 5})

let socket = new Socket("/socket", {})
socket.connect()

let channel = socket.channel("counter", {})

channel.on("new_counter", ({value}) => {
  myApp.ports.counter.send(value)
})

channel.join()
  .receive("ok", resp =>    { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
