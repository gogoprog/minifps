package map;

import math.Rectangle;

class Zone {
    public var parent:Zone = null;
    public var children:Array<Zone> = [];
    public var type:ZoneType;
    public var rect:Rectangle;

    public function new() {
    }

    public function getCenter():math.Vector2 {
        return new math.Vector2(
            rect.x + rect.width/2, rect.y + rect.height /2
        );
    }
}

