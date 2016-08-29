import {createLabel,
        coloredLabel} from "../common/labels"

const WHITE = "#FFF"
const YELLOW = "#FF0"
const RED = "#F00"
const GREEN = "#0F0"

export class Lobby extends Phaser.State {
  init(...args) {
    const [channel] = args
    this.channel = channel
    this.count = 0
    this.key_press_events = {}
  }

  create() {
    console.log(`Lobby.create`)
    this.channel.on("start_game", this.onStartGame.bind(this))
    this.channel.on("result", this.onResult.bind(this))

    this.createStartButton()
  }

  createStartButton() {
    const start_button = createLabel(this, "start")
    start_button.inputEnabled = true
    start_button.events.onInputDown.add(() => {
      start_button.destroy()
      this.channel.push("start_game")
    })
  }

  onStartGame({text}) {
    console.log(`startGame ${text}`)
    this.text = text
    this.renderText(text)
    this.listenKeyboard()
  }

  onResult(payload = {result, count}) {
    console.log(result, count)
    // const letter = this.key_press_events[count]
    // if (result == "all_match") {}
    // if (result == "nothing_match") {}
    // if (result == "finger_key") {}
    // if (result == "letter_key") {}
  }

  renderText(text) {
    this.text_to_type = createLabel(this, text)

    // all_match      = GREEN
    // finger_match   = YELLOW
    // key_match      = YELLOW
    // nothing_match  = RED

  }

  listenKeyboard() {
    this.input.keyboard.addCallbacks(this, this.onKeyPress)
  }

  onKeyPress({key}) {
    const position = this.count
    this.text_to_type.addColor(GREEN, position)
    this.text_to_type.addColor(WHITE, position + 1)
    // this.recordKeyPress(this.count, event.key)
    //
    // this.channel.push("key", {key: event.key, count: this.count})
    // console.log(event.key, this.count)
    this.count = this.count + 1
  }

  recordKeyPress(id, key) {
    this.key_press_events[this.count] = event.key
  }
}
