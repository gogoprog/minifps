package game;

var engine:ecs.Engine;

class Game {
    static public function init() {
        var playerEntity:ecs.Entity;
        engine = new ecs.Engine();
        engine.enable(PlayerSystem);
        engine.enable(PlayerGunSystem);
        engine.enable(ModelSystem);
        engine.enable(BallSystem);
        engine.enable(MoveSystem);
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
            var e = new ecs.Entity();
            e.add(Player);
            e.position = World.getStartPosition();
            playerEntity = e;
            engine.add(e);
        }

        {
            var data = Macros.getFileContent("data/Pistol_02.obj");
            var buffer = ObjLoader.load(data);
            var gunModel = new ModelData(buffer);
            var e = new ecs.Entity();
            e.add(Model).modelData = gunModel;
            e.get(Model).worldSpace = false;
            e.position = new math.Vector3(0.015, -0.016, -0.04);
            e.scale = 0.005;
            e.add(PlayerGun).owner = playerEntity;
            engine.add(e);
            var e = new ecs.Entity();
            e.add(Model).modelData = gunModel;
            e.get(Model).worldSpace = false;
            e.position = new math.Vector3(-0.015, -0.016, -0.04);
            e.scale = 0.005;
            e.add(PlayerGun).owner = playerEntity;
            engine.add(e);
        }

        {
            var data = Macros.getFileContent("data/ball.obj");
            var buffer = ObjLoader.load(data);
            var model = new ModelData(buffer);

            for(i in 0...100) {
                var e = new ecs.Entity();
                e.add(Ball);
                e.add(Model).modelData = model;
                e.get(Model).offset.y = -0.2;
                e.position = new math.Vector3(Std.random(10) * 10, 0.3, Std.random(10) * 10);
                e.scale = 0.1;
                e.pitch = 0;
                engine.add(e);
            }
        }
    }

    static public function update(dt:Float) {
        engine.update(dt);
    }
}
