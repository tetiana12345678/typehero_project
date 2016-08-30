import {keys, assign, map, omap} from "../common/fun"
import {createLabel,
        coloredLabel} from "../common/labels"

const WHITE =  "white" // "#FFF"
const YELLOW = "yellow" // "#FF0"
const RED =    "red" // "#F00"
const GREEN =  "green" // "#0F0"

const ALL_MATCH    = "all_match"
const KEY_MATCH    = "right_key_wrong_finger"
const FINGER_MATCH = "wrong_key_right_finger"
const NO_MATCH     = "no_match"

// const example_events = [
//   // { key: "t", id: 0, result: NO_MATCH },
//   // { key: "y", id: 1, result: NO_MATCH },
//   // { key: "h", id: 2, result: ALL_MATCH },
//   // { key: "e", id: 3, result: KEY_MATCH },
//   // { key: "l", id: 4, result: NO_MATCH }
// ]

export class Lobby extends Phaser.State {
  init(...args) {
    const [channel] = args
    this.channel = channel
    this.key_press_events = []
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
    this.renderText(text)
    console.log(this)
    // this.colourText(this.eventsToColours(example_events))
    this.listenKeyboard()
  }

  onResult({id, result}) {
    this.updateEvent(id, result)
    this.colourText(this.eventsToColours(this.key_press_events))
  }

  renderText(text) {
    this.text_to_type = createLabel(this, text)
  }

  listenKeyboard() {
    this.input.keyboard.addCallbacks(this, this.onKeyPress)
  }

  onKeyPress({key}) {
    if (key == "Meta") { return }
    const event = this.createEvent(key)
    const events = this.addEvent(event)
    this.channel.push("key", event)
  }

  eventsToColours(events) {
    return events.map((o) => {
      switch (o.result) {
        case ALL_MATCH: return GREEN
        case KEY_MATCH: return YELLOW
        case FINGER_MATCH: return YELLOW
        case NO_MATCH: return RED
      }
    }).filter(el => el !== undefined)
  }

  colourText(colours) {
    // apply the colours
    let position = 0
    colours.map(colour => {
      this.text_to_type.addColor(colour, position)
      if (colour == GREEN) { position++ }
    })
    console.log(colours)
    // colour rest white
    if (colours.pop() == GREEN) {
      this.text_to_type.addColor(WHITE, this.currentPosition())
    } else {
      this.text_to_type.addColor(WHITE, this.currentPosition() + 1)
    }
  }

  currentPosition() {
    return this.key_press_events.filter(event => event.result == ALL_MATCH).length
  }

  createEvent(key) {
    const id = this.key_press_events.length
    return { key: key, id: id, result: null }
  }

  updateEvent(id, result) {
    console.log(result)
    console.log(id)
    console.log(this.key_press_events[id])
    this.key_press_events[id].result = result
  }

  addEvent(event) {
    this.key_press_events.push(event)
    console.log(this.key_press_events)
    return this.key_press_events
  }
}
