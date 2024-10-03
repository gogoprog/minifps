package;

@:native("")
extern private class Shim {
    @:native("c") static var canvas:js.html.CanvasElement;
}

var lastTime = 0.0;
var windowIsVisible = true;

function main() {
    Renderer.init();
    Player.init();
    // var model = new Model(Macros.getFileContent("data/Pistol_02.obj"));

    var data = Macros.getFileContent("data/Pistol_02.obj");
    var buffer = ObjLoader.load(data);
    var gunModel = new Model(buffer);

    var buffer2 = World.load();
    var worldModel = new Model(buffer2);

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
        Renderer.drawModel(worldModel);
        Renderer.drawModel2(gunModel);
        js.Browser.window.requestAnimationFrame(loop);
    }
    js.Browser.window.requestAnimationFrame(loop);
}
