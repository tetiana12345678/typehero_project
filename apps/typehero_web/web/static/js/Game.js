import {Lobby} from "./states/Lobby"

export class Game extends Phaser.Game {
    //Initialize Phaser
    constructor(width, height, container) {
        super(width, height, Phaser.AUTO, container)
        this.state.add("lobby", Lobby, false) //false - don't auto start
        this.state.start("lobby")
    }
}
