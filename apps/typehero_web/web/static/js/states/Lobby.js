import {createLabel} from "../common/labels"

export class Lobby extends Phaser.State {
  init(...args) {
    const [channel] = args
    this.channel = channel
    this.count = 1
  }
  create() {
    this.channel.on("start_game", (payload) => {
      this.startGame(payload.text)
      this.text = payload.text
    })
    this.channel.on("result", (payload) => {
      this.renderResult(payload)
      console.log(payload)
    })
    const start_button = createLabel(this, "start")
    start_button.anchor.setTo(0.5)
    start_button.inputEnabled = true
    start_button.events.onInputDown.add(() => {
      start_button.destroy()
      this.channel.push("start_game")
    })
  }

  startGame(text) {
    this.renderText(text)
    this.listenKeyboard()
  }

  renderResult(payload) {
    const green_letter_style = {font: "45px Arial", fill: "#008000", align: 'left'}
    const red_letter_style = {font: "45px Arial", fill: "#008000", align: 'left'}
    const yellow_letter_style = {font: "45px Arial", fill: "#008000", align: 'left'}
    const text_style = {font: "45px Arial", fill: "#ffffff", wordWrap: true, wordWrapWidth: 700, align: 'left'}

    const letter = this.text.charAt(0)
    const render_text = createLabel(this, this.text, text_style)

    if (payload.result == "finger_key") {
      const render_letter = createLabel(this, letter, red_letter_style)
      render_letter.anchor.setTo(0.5)
    }
    if (payload.result == "all_match") {
      const render_letter = createLabel(this, letter, green_letter_style)
    }
    if (payload.result == "letter_key") {
      const render_letter = createLabel(this, letter, yellow_letter_style)
    }
    render_text.anchor.setTo(0.5)
    const {centerX, centerY} = this.game.world
    render_text.position.setTo(centerX, centerY)
  }

  renderText(text) {
    const style = {font: "45px Arial", fill: "#ffffff", wordWrap: true, wordWrapWidth: 700, align: 'left'}
    const render_text = createLabel(this, text, style)
    render_text.anchor.setTo(0.5)
    const {centerX, centerY} = this.game.world
    render_text.position.setTo(centerX, centerY)
  }

  listenKeyboard() {
    this.input.keyboard.addCallbacks(this, this.onPress)
  }

  onPress(event) {
    this.channel.push("key", {key: event.key, count: this.count})
    console.log(event.key, this.count)
    this.count = this.count + 1
  }

}
