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
        Renderer.drawMap();
        js.Browser.window.requestAnimationFrame(loop);
    }
    js.Browser.window.requestAnimationFrame(loop);
}
