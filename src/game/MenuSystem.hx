package game;

import ecs.Engine;

class MenuSystem extends ecs.System {
    private var title:ModelData;
    private var start:ModelData;
    private var position:math.Vector3 = [0, 5, 0];
    private var cameraYaw = 0.0;
    private var cameraPitch = -0.1;

    public function new() {
        super();
        title = ModelData.createQuad(0.4, 0.05);
        title.texture = Renderer.createText("TOWERFPS", 166, 32, "white");
        start = ModelData.createQuad(0.4, 0.05);
        start.texture = Renderer.createText("CLICK TO START", 166, 32, "white");
    }

    override public function update(dt:Float) {
        if(Input.isMouseJustDown()) {
            engine.enable(PlayerSystem);
            engine.enable(PlayerGunSystem);
            engine.enable(BallSystem);
            engine.enable(InGameSystem);
            engine.disable(MenuSystem);
        }

        cameraYaw += dt;

        position = math.Vector3.getRotatedAroundY([0, 0, 20], -cameraYaw);
        position.y = 5;

        position += World.getCenter();

        // position.x = Math.cos(cameraYaw) + Math.sin(cameraYaw);

        Renderer.setCamera(position, cameraYaw, cameraPitch);

        Renderer.setModelPosition(new math.Vector3(0, 0.2, -0.5));
        Renderer.drawModel(title, false);
        Renderer.setModelPosition(new math.Vector3(0, -0.2, -0.5));
        Renderer.drawModel(start, false);
    }
}
