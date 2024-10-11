package game;

import ecs.Engine;

class BallSystem extends ecs.System {
    public function new() {
        super();
        requires(Ball);
    }

    override public function updateEntity(e:ecs.Entity, dt:Float) {
        var move = e.get(Move);

        if(move == null) {
            move = e.add(Move);
            move.time = 0;
            move.duration = 1 + Std.random(5);
            var speed = 2;
            move.velocity = math.Vector3.getRotatedAroundY([1, 0, 0], Math.random() * Math.PI * 2) * speed;
        }
    }
}
