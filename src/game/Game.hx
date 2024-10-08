package game;

var engine:ecs.Engine;

class Game {
    static public function init() {
        engine = new ecs.Engine();
        engine.enable(ModelSystem);
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
            }
        }
    }
    static public function update(dt:Float) {
        engine.update(dt);
    }
}
