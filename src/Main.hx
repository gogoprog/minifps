package;

import ecs.Engine;

@:native("")
extern private class Shim {
    @:native("c") static var canvas:js.html.CanvasElement;
}

var lastTime = 0.0;
var windowIsVisible = true;

function main() {
    untyped window.onfocus = (e) -> { windowIsVisible = true; };
    untyped window.onblur = (e) -> { windowIsVisible = false; };
    Renderer.init();
    Input.init();
    var data = Macros.getFileContent("data/Pistol_02.obj");
    var buffer = World.load();
    var worldModel = new ModelData(buffer);
    var cross = ModelData.createQuad(0.01, 0.01);
    cross.texture = Renderer.createText("+", 16, 16);


    game.Game.init();
    function loop(t:Float) {
        if(!windowIsVisible) {
            js.Browser.window.setTimeout(function() {loop(t+1);}, 1000);

            return;
        }

        t /= 1000;
        var dt = t - lastTime;
        lastTime = t;
        Renderer.preRender();
        Renderer.setModelPosition(math.Vector3.zero);
        Renderer.drawModel(worldModel);
        game.Game.update(dt);
        Renderer.setModelPosition(new math.Vector3(0, 0, -0.5));
        Renderer.drawModel(cross, false);
        Renderer.postRender();
        Input.update();
        js.Browser.window.requestAnimationFrame(loop);
    }

    js.Browser.window.requestAnimationFrame(loop);
}
