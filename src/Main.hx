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

    untyped window.x = 0.01;
    untyped window.y = -0.01;
    untyped window.z = -0.04;
    untyped window.s = 0.01;

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
        Renderer.setModelPosition(new math.Vector3(0.01, -0.01, -0.04));
        Renderer.drawModel(gunModel, false, 0.01);
        // Renderer.setModelPosition(new math.Vector3(untyped window.x, untyped window.y, untyped window.z));
        // Renderer.drawModel(gunModel, false, untyped window.s);
        js.Browser.window.requestAnimationFrame(loop);
    }
    js.Browser.window.requestAnimationFrame(loop);
}
