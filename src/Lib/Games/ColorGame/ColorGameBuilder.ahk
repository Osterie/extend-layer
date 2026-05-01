#Requires AutoHotkey v2.0

#Include <Games\ColorGame\Mutation\Mutation>
#Include <Games\ColorGame\Fill\ColorStrategies>
#Include <Games\ColorGame\Drawing\ScreenDrawer>
#Include <Games\ColorGame\ColorGame>

class ColorGameBuilder {

    fps := 16
    fillCanvasStepsPerFrame := 100

    pixelSize := 10

    ; Type IColorStrategy
    fillStrategy := ""

    reset() {
        this.fps := 16
        this.pixelSize := 10
        this.fillStrategy := ""
    }

    setFps(fps) {
        this.fps := fps
        return this
    }

    setPixelSize(pixelSize) {
        this.pixelSize := pixelSize
        return this
    }

    ; Expects type IColorStrategy
    setFillStrategy(fillStrategy) {
        if (!(fillStrategy is IColorStrategy)) {
            throw TypeError("ColorGameBuilder setFillStrategy method expected an IColorStrategy, but got: " . type(
                fillStrategy))
        }
        this.fillStrategy := fillStrategy
        return this
    }

    setFillCanvasStepsPerFrame(fillCanvasStepsPerFrame) {
        if (!IsInteger(fillCanvasStepsPerFrame)) {
            throw TypeError("setFillCanvasStepsPerFrame expected a number, but got: " . type(fillCanvasStepsPerFrame))
        }
        if (fillCanvasStepsPerFrame < 0) {
            throw ValueError("fillCanvasStepsPerFrame must be a positive number")
        }

        this.fillCanvasStepsPerFrame := fillCanvasStepsPerFrame
        return this
    }

    build() {
        if (!(this.fillStrategy is IColorStrategy)) {
            throw TypeError("Expected type IColorStrategy, received: " . type(this.fillStrategy))
        }

        game := ColorGame(this.fillStrategy, this.fps, this.pixelSize)
        game.setFillCanvasStepsPerFrame(this.fillCanvasStepsPerFrame)

        return game
    }
}
