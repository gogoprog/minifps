@:native("")
extern private class Shim {
    @:native("c") static var canvas:js.html.CanvasElement;
    @:native("g") static var g:Dynamic;
}

private abstract DataBuffer(js.lib.Float32Array) from js.lib.Float32Array to js.lib.Float32Array {
    static inline var count = 1024;
    public function new() {
        this = new js.lib.Float32Array(count * 4 * 3);
    }

    public function setPosition(i, x, y, z) {
        this[i * 4 + 0] = x;
        this[i * 4 + 1] = y;
        this[i * 4 + 2] = z;
    }

    public function setTexCoord(i, u, v) {
        this[count * 2 * 4 + i * 4 + 0] = u;
        this[count * 2 * 4 + i * 4 + 1] = v;
    }

}

var mapGen:map.Generator = new map.Generator();
var lastTime = 0.0;
var keys:Dynamic = {};
var mouseMove = [0, 0];
var mouseDown = false;
var windowIsVisible = true;

var cameraYaw = 0.0;
var cameraPitch = 0.0;

var playerPosition = [0.0, 0, 0];
var playerVelocity = [0.0, 0.0, 0.0];
var playerAcceleration = [0.0, 0.0, 0.0];
var gravity = -15;
var jumpVelocity = 8.0;
var isOnGround = false;
var acceleration = 20.0;
var deceleration = 10.0;
var maxSpeed = 5.0;

function main() {
    Renderer.init();
    Shim.canvas.onmousemove = function(e) {
        mouseMove[0] += e.movementX;
        mouseMove[1] += e.movementY;
    }
    untyped onkeydown = onkeyup = function(e) {
        keys[e.key] = e.type[3] == 'd';
    }
    function getKey(str:String) {
        return keys[untyped str];
    }
    untyped window.onfocus = (e) -> { windowIsVisible = true; };
    untyped window.onblur = (e) -> { windowIsVisible = false; };
    var size = 10;
    playerPosition = [size/2, 10.0, size/2];
    function checkCollision(x:Float, y:Float, z:Float):Bool {
        if(y < 1) { return true; }

        return false;
    }
    Shim.canvas.onmousedown = function(e) {
        Shim.canvas.requestPointerLock();
        mouseDown = true;
    };
    Shim.canvas.onmouseup = function(e) {
        mouseDown = false;
    };
    function loop(t:Float) {
        if(!windowIsVisible) {
            js.Browser.window.setTimeout(function() {loop(t+1);}, 1000);
            return;
        }

        t /= 1000;
        var deltaTime = t - lastTime;
        lastTime = t;
        var moveSpeed = 0.8;
        var mouseSensitivity = 0.002;
        cameraYaw -= mouseMove[0] * mouseSensitivity;
        cameraPitch += mouseMove[1] * mouseSensitivity;
        cameraPitch = Math.max(Math.min(cameraPitch, Math.PI / 2), -Math.PI / 2);
        var dirX = Math.cos(cameraPitch) * Math.sin(cameraYaw);
        var dirY = Math.sin(cameraPitch);
        var dirZ = Math.cos(cameraPitch) * Math.cos(cameraYaw);
        var rightX = Math.cos(cameraYaw);
        var rightZ = -Math.sin(cameraYaw);
        playerAcceleration[0] = 0;
        playerAcceleration[2] = 0;
        var previous_y = playerPosition[1];

        if(getKey("w") || getKey("ArrowUp")) {
            playerAcceleration[0] -= dirX * acceleration;
            playerAcceleration[2] -= dirZ * acceleration;
        }

        if(getKey("s") || getKey("ArrowDown")) {
            playerAcceleration[0] += dirX * acceleration;
            playerAcceleration[2] += dirZ * acceleration;
        }

        if(getKey("a") || getKey("ArrowLeft")) {
            playerAcceleration[0] -= rightX * acceleration;
            playerAcceleration[2] -= rightZ * acceleration;
        }

        if(getKey("d") || getKey("ArrowRight")) {
            playerAcceleration[0] += rightX * acceleration;
            playerAcceleration[2] += rightZ * acceleration;
        }

        playerVelocity[0] += playerAcceleration[0] * deltaTime;
        playerVelocity[2] += playerAcceleration[2] * deltaTime;

        if(playerAcceleration[0] == 0) {
            playerVelocity[0] *= Math.pow(1 - deceleration * deltaTime, 2);
        }

        if(playerAcceleration[2] == 0) {
            playerVelocity[2] *= Math.pow(1 - deceleration * deltaTime, 2);
        }

        var speed = Math.sqrt(playerVelocity[0] * playerVelocity[0] + playerVelocity[2] * playerVelocity[2]);

        if(speed > maxSpeed) {
            playerVelocity[0] *= maxSpeed / speed;
            playerVelocity[2] *= maxSpeed / speed;
        }

        playerVelocity[1] += gravity * deltaTime;

        if(isOnGround && getKey(" ")) {
            playerVelocity[1] = jumpVelocity;
            isOnGround = false;
        }

        var newX = playerPosition[0] + playerVelocity[0] * deltaTime;
        var newY = playerPosition[1] + playerVelocity[1] * deltaTime;
        var newZ = playerPosition[2] + playerVelocity[2] * deltaTime;

        if(!checkCollision(newX, playerPosition[1], playerPosition[2])) {
            playerPosition[0] = newX;
        } else {
            playerVelocity[0] = 0;
            var pushDirection = newX > playerPosition[0] ? -1 : 1;
            playerPosition[0] += pushDirection * 0.01;
        }

        if(!checkCollision(playerPosition[0], newY, playerPosition[2])) {
            playerPosition[1] = newY;
            isOnGround = false;
        } else {
            if(playerVelocity[1] < 0) {
                isOnGround = true;
            }

            playerVelocity[1] = 0;
            var pushDirection = newY > playerPosition[1] ? -1 : 1;
            playerPosition[1] = previous_y;
        }

        if(!checkCollision(playerPosition[0], playerPosition[1], newZ)) {
            playerPosition[2] = newZ;
        } else {
            playerVelocity[2] = 0;
            var pushDirection = newZ > playerPosition[2] ? -1 : 1;
            playerPosition[2] += pushDirection * 0.01;
        }

        Renderer.setCamera([playerPosition[0], playerPosition[1] + 0.2, playerPosition[2]], cameraYaw, cameraPitch);
        Renderer.preRender();
        Renderer.drawMap();
        mouseMove[0] = mouseMove[1] = 0;
        js.Browser.window.requestAnimationFrame(loop);
    }
    js.Browser.window.requestAnimationFrame(loop);
}
