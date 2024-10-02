package;

// var data = Macros.getFileContent("data/Castle_Tower.obj");
var mapGen:map.Generator = new map.Generator();
var map:map.Map;
var triangles = new Array<math.Triangle>();

class World {
    inline static public function load():DataBuffer {
        var buffer = new DataBuffer(1024);
        var size = 10;

        var n = new math.Vector3(0, 1, 0);

        buffer.add(new math.Vector3(-size, 0, -size), n, new math.Vector2(0, 0));
        buffer.add(new math.Vector3(size, 0, -size), n, new math.Vector2(1, 0));
        buffer.add(new math.Vector3(size, 0, size), n, new math.Vector2(1, 1));
        buffer.add(new math.Vector3(size, 0, size), n, new math.Vector2(1, 1));
        buffer.add(new math.Vector3(-size, 0, size), n, new math.Vector2(0, 1));
        buffer.add(new math.Vector3(-size, 0, -size), n, new math.Vector2(0, 0));

        map = mapGen.generate();

        for(w in map.walls) {
            var h = 1;
            var v1 = new math.Vector3(w.x1, 0, w.y1);
            var v2 = new math.Vector3(w.x2, 0, w.y2);
            var v3 = new math.Vector3(w.x2, h, w.y2);
            var v4 = new math.Vector3(w.x1, h, w.y1);
            var n = new math.Vector3(0, 1, 0);
            buffer.add(v1, n, new math.Vector2(0, 0));
            buffer.add(v2, n, new math.Vector2(1 * w.getLength(), 0));
            buffer.add(v3, n, new math.Vector2(1 * w.getLength(), h));
            buffer.add(v3, n, new math.Vector2(1 * w.getLength(), h));
            buffer.add(v4, n, new math.Vector2(0, h));
            buffer.add(v1, n, new math.Vector2(0, 0));
            var tri1 = new math.Triangle(v1, v2, v3);
            var tri2 = new math.Triangle(v3, v4, v1);
            triangles.push(tri1);
            triangles.push(tri2);
        }

        return buffer;
    }

    inline static public function getVertexCount() {
        return 6 + map.walls.length * 6;
    }

    inline static public function collides(p:math.Vector3) {
        var result = false;

        for(tri in triangles) {
            if(tri.distanceToPoint(p) < 0.5) {
                result = true;
                break;
            }
        }

        return result;
    }
}
