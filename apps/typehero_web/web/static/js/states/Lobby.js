import {createLabel} from "../common/labels"

export class Lobby extends Phaser.State {
    init(...args) {
        const [channel] = args
        this.channel = channel
    }
    create() {
        this.channel.on("start_game", (payload) => {
            this.renderText(payload.text)
        })
        const start_button = createLabel(this, "start")
        start_button.anchor.setTo(0.5)
        start_button.inputEnabled = true
        start_button.events.onInputDown.add(() => {
            this.channel.push("start_game")
        })
    }

    renderText(text) {
        const render_text = createLabel(this, text)
        render_text.anchor.setTo(0.5)
        render_text.position.setTo(370, 300)
    }
}
