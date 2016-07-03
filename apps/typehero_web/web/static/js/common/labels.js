const DEFAULT_STYLE = {font: "65px Arial", fill: "#ffffff"}

export const createLabel = (state, text, style = DEFAULT_STYLE) => {
    const {centerX, centerY} = state.world
    return state.add.text(centerX, centerY, text, style)
}
