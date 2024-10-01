package;

// var data = Macros.getFileContent("data/Castle_Tower.obj");
var mapGen:map.Generator = new map.Generator();
var map:map.Map;

var triangles = new Array<math.Triangle>();

class World {
    inline static public function load():DataBuffer {

        var buffer = new DataBuffer();

        var size = 10;

        buffer.setPosition(0, -size, 0, -size);
        buffer.setPosition(1, size, 0, -size);
        buffer.setPosition(2, size, 0, size);
        buffer.setPosition(3, -size, 0, size);
        buffer.setTexCoord(0, 0, 0);
        buffer.setTexCoord(1, 1, 0);
        buffer.setTexCoord(2, 1, 1);
        buffer.setTexCoord(3, 0, 1);

        var i = 4;

        map = mapGen.generate();

        for(w in map.walls) {
            var v1 = new math.Vector3(w.x1, 0, w.y1);
            var v2 = new math.Vector3(w.x2, 0, w.y2);
            var v3 = new math.Vector3(w.x2, 2, w.y2);
            var v4 = new math.Vector3(w.x1, 2, w.y1);
            var tri1 = new math.Triangle(v1, v2, v3);
            var tri2 = new math.Triangle(v3, v4, v1);
            buffer.setPosition2(i+0, v1);
            buffer.setPosition2(i+1, v2);
            buffer.setPosition2(i+2, v3);
            buffer.setPosition2(i+3, v4);
            buffer.setTexCoord(i+0, 0, 0);
            buffer.setTexCoord(i+1, 1 * w.getLength(), 0);
            buffer.setTexCoord(i+2, 1 * w.getLength(), 1);
            buffer.setTexCoord(i+3, 0, 1);
            i+=4;
        }

        return buffer;
    }

    inline static public function getVertexCount() {
        return 6 + map.walls.length * 6;
    }
}
