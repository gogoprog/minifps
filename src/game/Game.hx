package game;

var engine:ecs.Engine;

class Game {
    static public var ballModel:ModelData;

    static public function init() {
        engine = new ecs.Engine();
        engine.enable(ModelSystem);
        engine.enable(MoveSystem);
        engine.enable(MenuSystem);
        engine.enable(ParticleSystem);
        {
            var data = Macros.getFileContent("data/Castle_Tower.obj");
            var buffer = ObjLoader.load(data);
            var towerModel = new ModelData(buffer);

            for(i in 0...10) {
                var e = new ecs.Entity();
                e.add(Model).modelData = towerModel;
                e.position = new math.Vector3(Std.random(10) * 10, 0, Std.random(10) * 10);
                e.scale = 0.1;
                e.pitch = -Math.PI/2;
                engine.add(e);
            }
        }

        {
            var data = Macros.getFileContent("data/ball.obj");
            var buffer = ObjLoader.load(data);
            ballModel = new ModelData(buffer);
        }
    }

    static public function update(dt:Float) {
        engine.update(dt);
    }

    static public function spawnParticle(pos:math.Vector3) {
        var e = new ecs.Entity();
        e.add(Model).modelData = Game.ballModel;
        e.add(Particle).velocity = math.Vector3.getRotatedAroundY([0, 0, 1.5], Math.random() * Math.PI * 2);
        e.get(Particle).velocity.y = 1 + Math.random() * 2;
        e.position = [pos.x, pos.y, pos.z];
        e.scale = 0.01;
        e.pitch = 0;
        engine.add(e);
    }

    static public function spawnParticles(pos:math.Vector3, count:Int) {
        for(i in 0...count) {
            spawnParticle(pos);
        }
    }
}
