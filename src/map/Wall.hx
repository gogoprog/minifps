package map;

import math.Vector2;

class Wall {
    public var x1:Float;
    public var y1:Float;
    public var x2:Float;
    public var y2:Float;

    public function new(?a, ?b, ?c, ?d) {
        x1 = a;
        y1 = b;
        x2 = c;
        y2 = d;
    }

    public function getLength() {
        var dx = x2 - x1;
        var dy = y2 - y1;
        return Math.sqrt(dx * dx + dy * dy);
    }
}
