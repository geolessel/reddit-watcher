import React from "react"
import ReactDOM from "react-dom"
import Posts from "./posts"
import socket from "./socket"

ReactDOM.render(<Posts channel={socket.channel("posts", {})} />, document.getElementById("react"))
