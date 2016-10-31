.pragma library

function calculateScale(width, height, cellSize) {
    var widthScale = (cellSize * 1.0) / width
    var heightScale = (cellSize * 1.0) / height
    var scale = 0

    if (widthScale <= heightScale) {
        scale = widthScale;
    } else if (heightScale < widthScale) {
        scale = heightScale;
    }
    return scale;
}
