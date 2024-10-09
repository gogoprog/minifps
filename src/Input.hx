package;

@:native("")
extern private class Shim {
    @:native("c") static var canvas:js.html.CanvasElement;
}

var keys:Dynamic = {};
var mouseMove:math.Vector2 = [0, 0];
var mouseDown = false;

class Input {
    inline static public function init() {
        Shim.canvas.onmousemove = function(e) {
            mouseMove[0] += e.movementX;
            mouseMove[1] += e.movementY;
        }
        untyped onkeydown = onkeyup = function(e) {
            keys[e.key] = e.type[3] == 'd';
        }
        Shim.canvas.onmousedown = function(e) {
            Shim.canvas.requestPointerLock();
            mouseDown = true;
        };
        Shim.canvas.onmouseup = function(e) {
            mouseDown = false;
        };
    }

    inline static public function update() {
        mouseMove[0] = mouseMove[1] = 0;
    }

    inline static public function getKey(str:String) {
        return keys[untyped str];
    }

    inline static public function getMouseMove() {
        return mouseMove;
    }

    inline static public function isMouseDown() {
        return mouseDown;
    }
}
