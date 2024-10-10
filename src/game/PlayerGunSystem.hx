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
}
