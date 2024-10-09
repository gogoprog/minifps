package game;

import ecs.Engine;

var cameraYaw = 0.0;
var cameraPitch = 0.0;
var keys:Dynamic = {};
var playerVelocity = [0.0, 0.0, 0.0];
var playerAcceleration = [0.0, 0.0, 0.0];
var gravity = -15;
var jumpVelocity = 8.0;
var isOnGround = false;
var acceleration = 20.0;
var deceleration = 10.0;
var maxSpeed = 5.0;

class PlayerSystem extends ecs.System {
    public function new() {
        super();
        requires(Player);
    }

    override public function updateEntity(e, dt:Float) {
        var player = e.get(Player);
        var playerPosition:math.Vector3 = e.position;
        var moveSpeed = 0.8;
        var mouseSensitivity = 0.002;
        var mouseMove = Input.getMouseMove();
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

        if(Input.getKey("w") || Input.getKey("ArrowUp")) {
            playerAcceleration[0] -= dirX * acceleration;
            playerAcceleration[2] -= dirZ * acceleration;
        }

        if(Input.getKey("s") || Input.getKey("ArrowDown")) {
            playerAcceleration[0] += dirX * acceleration;
            playerAcceleration[2] += dirZ * acceleration;
        }

        if(Input.getKey("a") || Input.getKey("ArrowLeft")) {
            playerAcceleration[0] -= rightX * acceleration;
            playerAcceleration[2] -= rightZ * acceleration;
        }

        if(Input.getKey("d") || Input.getKey("ArrowRight")) {
            playerAcceleration[0] += rightX * acceleration;
            playerAcceleration[2] += rightZ * acceleration;
        }

        playerVelocity[0] += playerAcceleration[0] * dt;
        playerVelocity[2] += playerAcceleration[2] * dt;

        if(playerAcceleration[0] == 0) {
            playerVelocity[0] *= Math.pow(1 - deceleration * dt, 2);
        }

        if(playerAcceleration[2] == 0) {
            playerVelocity[2] *= Math.pow(1 - deceleration * dt, 2);
        }

        var speed = Math.sqrt(playerVelocity[0] * playerVelocity[0] + playerVelocity[2] * playerVelocity[2]);

        if(speed > maxSpeed) {
            playerVelocity[0] *= maxSpeed / speed;
            playerVelocity[2] *= maxSpeed / speed;
        }

        playerVelocity[1] += gravity * dt;

        if(isOnGround && Input.getKey(" ")) {
            playerVelocity[1] = jumpVelocity;
            isOnGround = false;
        }

        var newX = playerPosition[0] + playerVelocity[0] * dt;
        var newY = playerPosition[1] + playerVelocity[1] * dt;
        var newZ = playerPosition[2] + playerVelocity[2] * dt;

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

        Renderer.setCamera([playerPosition[0], playerPosition[1] + 0.4, playerPosition[2]], cameraYaw, cameraPitch);
    }

    static inline function checkCollision(x:Float, y:Float, z:Float):Bool {
        if(y < 0) { return true; }

        return World.collides(new math.Vector3(x, y, z));
    }
}
