package game;

import ecs.Engine;

class PlayerGunSystem extends ecs.System {
    public function new() {
        super();
        requires(Model);
        requires(PlayerGun);
    }

    override public function updateEntity(e, dt) {
    }
}
