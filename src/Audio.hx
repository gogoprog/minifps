package;

class Audio {
    static public function sfx(...args:Float) {
        var func:Dynamic = js.Syntax.code("zzfx");
        func.apply(null, args);
    }
}
