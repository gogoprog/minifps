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
    game.Game.init();
    var data = Macros.getFileContent("data/Pistol_02.obj");
    var buffer = World.load();
    var worldModel = new ModelData(buffer);
    function loop(t:Float) {
        if(!windowIsVisible) {
            js.Browser.window.setTimeout(function() {loop(t+1);}, 1000);
            return;
        }

        t /= 1000;
        var dt = t - lastTime;
        lastTime = t;
        Renderer.preRender();
        game.Game.update(dt);
        Renderer.setModelPosition(math.Vector3.zero);
        Renderer.drawModel(worldModel);
        Renderer.postRender();
        Input.update();
        js.Browser.window.requestAnimationFrame(loop);
    }
    js.Browser.window.requestAnimationFrame(loop);
}
