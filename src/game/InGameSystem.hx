package game;

import ecs.Engine;

class InGameSystem extends ecs.System {
    public function new() {
        super();
    }


    override public function onEnable() {
        var playerEntity:ecs.Entity;
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
            for(zone in World.getMap().allZones) {
                if(zone.type == First) { continue; }

                for(i in 0...6) {
                    var e = new ecs.Entity();
                    e.add(Ball);
                    e.add(Model).modelData = Game.ballModel;
                    e.get(Model).offset.y = -0.2;
                    var pos = zone.getCenter();
                    e.position = [pos.x, 0.3, pos.y];
                    e.scale = 0.1;
                    e.pitch = 0;
                    engine.add(e);
                }
            }
        }
    }

    override public function update(dt:Float) {
    }
}
