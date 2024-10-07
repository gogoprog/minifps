package;

import ecs.Engine;


@:native("")
extern private class Shim {
    @:native("c") static var canvas:js.html.CanvasElement;
}

var lastTime = 0.0;
var windowIsVisible = true;

var rpos = [];

function main() {
    Renderer.init();
    Player.init();
    var data = Macros.getFileContent("data/Pistol_02.obj");
    var buffer = ObjLoader.load(data);
    var gunModel = new Model(buffer);
    var buffer2 = World.load();
    var worldModel = new Model(buffer2);
    var data = Macros.getFileContent("data/Castle_Tower.obj");
    var buffer = ObjLoader.load(data);
    var towerModel = new Model(buffer);

    for(i in 0...10) {
        rpos.push(new math.Vector3(Std.random(10) * 10, 0, Std.random(10) * 10));
    }

    function loop(t:Float) {
        if(!windowIsVisible) {
            js.Browser.window.setTimeout(function() {loop(t+1);}, 1000);

            return;
        }

        t /= 1000;
        var deltaTime = t - lastTime;
        lastTime = t;
        Player.update(deltaTime);
        Renderer.preRender();
        Renderer.setModelPosition(math.Vector3.zero);
        Renderer.drawModel(worldModel);

        for(i in 0...10) {
            Renderer.setModelPosition(rpos[i]);
            Renderer.drawModel(towerModel, true, 0.1, 0, - Math.PI / 2);
        }

        Renderer.setModelPosition(new math.Vector3(0.01, -0.015, -0.04));
        Renderer.drawModel(gunModel, false, 0.005);
        Renderer.drawModel(gunModel, true, 1.0, t, 0);
        Renderer.postRender();
        js.Browser.window.requestAnimationFrame(loop);
    }

    js.Browser.window.requestAnimationFrame(loop);
}
