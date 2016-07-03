// Import dependencies
import {Game} from "./Game"
import {Socket} from "phoenix"

const socket = new Socket("/socket", {})
const game = new Game(700, 450, "phaser")

game.start(socket)

