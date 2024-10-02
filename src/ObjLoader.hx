package;

class ObjLoader {
    inline static public function load(data:String):DataBuffer {
        var buffer = new DataBuffer(600);

        var lines = data.split('\n');

        var vertices = [];
        var normals = [];
        var texcoords = [];

        for(line in lines) {
            var p = line.split(' ');

            switch(p[0]) {
                case 'v': {
                    var v = new math.Vector3(Std.parseFloat(p[1]), Std.parseFloat(p[2]), Std.parseFloat(p[3]));
                    vertices.push(v);
                }

                case 'vn': {
                    var v = new math.Vector3(Std.parseFloat(p[1]), Std.parseFloat(p[2]), Std.parseFloat(p[3]));
                    normals.push(v);
                }

                case 'f': {
                    var v1 = parseIntArray(p[1].split('/'));
                    var v2 = parseIntArray(p[2].split('/'));
                    var v3 = parseIntArray(p[3].split('/'));
                    var vs = [v1, v2, v3];

                    for(v in vs) {
                        buffer.add(vertices[v[0] - 1], normals[v[1] - 1], new math.Vector2(Math.random(), Math.random()));
                    }

                    if(buffer.getCount() == 600) { break; }
                }
            }
        }

        trace(vertices.length);
        trace(normals.length);
        trace(buffer.getCount());

        return buffer;
    }

    inline static function parseIntArray(array:Array<String>) {
        var result:Array<Int> = [];

        for(a in array) {
            result.push(Std.parseInt(a));
        }

        return result;
    }
}
