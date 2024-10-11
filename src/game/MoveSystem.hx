package game;

import ecs.Engine;

class MoveSystem extends ecs.System {
    public function new() {
        super();
        requires(Move);
    }

    override public function updateEntity(e:ecs.Entity, dt:Float) {
        var move = e.get(Move);
        move.time += dt;
        var f = move.time / move.duration;

        if(f >= 1) {
            f = 1;
            e.remove(Move);
        }

        var next_position = e.position + move.velocity * dt;

        if(!World.collides(next_position)) {
            e.position = next_position;
        } else {
            e.remove(Move);
        }
    }
}
