package game;

import ecs.Engine;

class PlayerGunSystem extends ecs.System {
    private var itMustFire = false;

    public function new() {
        super();
        requires(Model);
        requires(PlayerGun);
    }

    override public function update(dt) {
        if(Input.isMouseJustDown()) {
            itMustFire = true;
        }

        super.update(dt);
    }

    override public function updateEntity(e:ecs.Entity, dt:Float) {
        var gun = e.get(PlayerGun);

        if(itMustFire) {
            if(!gun.firing) {
                gun.firing = true;
                gun.time = 0.0;
                itMustFire = false;
                Audio.sfx(1, .05, 422, .01, .14, .05, 1, 1.4, -3, 5, 0, 0, 0, 0, 11, .3, 0, .72, .12, 0, 0);
                fire(gun.owner);
            }
        }

        if(gun.firing) {
            gun.time += dt;
            var a = Math.PI / 3;
            var b = 0;
            var f = gun.time / gun.cooldown;
            var aa = -0.02;
            var bb = -0.04;

            if(f >= 1.0) {
                f = 1.0;
                gun.firing = false;
            }

            e.pitch = a + (b - a) * f;
            e.position.z = aa + (bb - aa) * f;
        }
    }

    private function fire(e:ecs.Entity) {
        var direction = e.getDirection();
        var origin = e.position;
        var targ = origin + direction * 10;

        for(b in engine.getSystem(BallSystem).entities) {
            if(raySphereIntersection(origin, direction, b.position, 0.5) != null) {
                var ball = b.get(Ball);
                ball.hp--;

                Game.spawnParticles(b.position, 16);

                if(ball.hp <= 0) {
                    engine.remove(b);
                    Audio.sfx(1.1, .05, 53, .05, .29, .33, 0, 2, 7, 0, 0, 0, 0, 2, 0, .9, 0, .32, .14, 0, 0);
                }
            }
        }
    }

    static private function raySphereIntersection(rayOrigin:math.Vector3, rayDirection:math.Vector3, sphereCenter:math.Vector3, sphereRadius:Float):Float {
        var OC:math.Vector3 = [
            rayOrigin[0] - sphereCenter[0],
            rayOrigin[1] - sphereCenter[1],
            rayOrigin[2] - sphereCenter[2]
        ];
        var a = math.Vector3.dot(rayDirection, rayDirection);
        var b = 2 * math.Vector3.dot(rayDirection, OC);
        var c = math.Vector3.dot(OC, OC) - sphereRadius * sphereRadius;
        var discriminant = b * b - 4 * a * c;

        if(discriminant < 0) {
            return null;
        } else {
            var t1 = (-b - Math.sqrt(discriminant)) / (2 * a);
            var t2 = (-b + Math.sqrt(discriminant)) / (2 * a);

            if(t1 >= 0 && t2 >= 0) {
                return Math.min(t1, t2);
            } else if(t1 >= 0) {
                return t1;
            } else if(t2 >= 0) {
                return t2;
            } else {
                return null;
            }
        }
    }
}
