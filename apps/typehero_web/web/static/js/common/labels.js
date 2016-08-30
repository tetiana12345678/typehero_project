const DEFAULT_STYLE = {
  font: "125px TheMinion", 
  fill: "#ffffff",
  wordWrap: true,
  wordWrapWidth: 700,
  align: "left"
}

export const createLabel = (state, text, style = DEFAULT_STYLE, anchor = 0.5) => {
    const {centerX, centerY} = state.world
    text = state.add.text(centerX, centerY, text, style)
    text.anchor.setTo(anchor)
    text.stroke = 'rgba(107, 0, 179, 0.8)'
    text.strokeThickness = 15
    text.setShadow(5, 5, 'rgba(107, 0, 179, 0.9)', 5)
    return text
}

export const coloredLabel = (state, text, color) =>
{
  return createLabel(state, text, Object.assign(DEFAULT_STYLE, {fill: color}))
}
