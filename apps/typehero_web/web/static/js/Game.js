import {Lobby} from "./states/Lobby"

export class Game extends Phaser.Game {
    //Initialize Phaser
    constructor(width, height, container) {
      super(width, height, Phaser.AUTO, container)
      this.state.add("lobby", Lobby, false) //false - don't auto start
    }

    start(socket) {
      socket.connect()
      // create and join the lobby channel
        const channel = socket.channel("games:lobby", {})
        channel.join()
            .receive("ok", () => {
                console.log("Joined successfully")
                 //true - clean the world, false - clear cache.
                this.state.start("lobby", true, false, channel)
               })
            .receive("error", (response) => console.log("failed to join", response))

    }
}
