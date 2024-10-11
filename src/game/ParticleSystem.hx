package game;

import ecs.Engine;

class ParticleSystem extends ecs.System {
    public function new() {
        super();
        requires(Particle);
    }

    override public function updateEntity(e:ecs.Entity, dt:Float) {
        var part = e.get(Particle);
        e.position += part.velocity * dt;
        part.velocity.y -= 10 * dt;

        if(e.position.y < -0.5) {
            e.remove(Particle);
        }
    }
}
