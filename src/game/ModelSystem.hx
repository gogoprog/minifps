package game;

import ecs.Engine;

class ModelSystem extends ecs.System {
    public function new() {
        super();
        requires(Model);
    }

    override public function updateEntity(e, dt) {
        var model = e.get(Model);
        Renderer.setModelPosition(e.position);
        Renderer.drawModel(model.modelData, model.worldSpace, e.scale, e.yaw, e.pitch);
    }

}
