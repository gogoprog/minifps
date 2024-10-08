package;

import ecs.Engine;

@:native("")
extern private class Shim {
    @:native("c") static var canvas:js.html.CanvasElement;
}

var lastTime = 0.0;
var windowIsVisible = true;

function main() {
    Renderer.init();
    Player.init();
    game.Game.init();
    var data = Macros.getFileContent("data/Pistol_02.obj");
    var buffer = ObjLoader.load(data);
    var gunModel = new ModelData(buffer);
    var buffer2 = World.load();
    var worldModel = new ModelData(buffer2);
    function loop(t:Float) {
        if(!windowIsVisible) {
            js.Browser.window.setTimeout(function() {loop(t+1);}, 1000);
            return;
        }

        t /= 1000;
        var dt = t - lastTime;
        lastTime = t;
        Player.update(dt);
        Renderer.preRender();
        game.Game.update(dt);
        Renderer.setModelPosition(math.Vector3.zero);
        Renderer.drawModel(worldModel);
        Renderer.setModelPosition(new math.Vector3(0.01, -0.015, -0.04));
        Renderer.drawModel(gunModel, false, 0.005);
        Renderer.drawModel(gunModel, true, 1.0, t, 0);
        Renderer.postRender();
        js.Browser.window.requestAnimationFrame(loop);
    }
    js.Browser.window.requestAnimationFrame(loop);
}
