package;

class ObjLoader {
    inline static public function load(data:String):DataBuffer {
        var buffer = new DataBuffer(4096 * 2);

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

                case 'vt': {
                    var v = new math.Vector2(Std.parseFloat(p[1]), Std.parseFloat(p[2]));
                    texcoords.push(v);
                }

                case 'f': {
                    var v1 = parseIntArray(p[1].split('/'));
                    var v2 = parseIntArray(p[2].split('/'));
                    var v3 = parseIntArray(p[3].split('/'));
                    var vs = [v1, v2, v3];
                    var face_normal:math.Vector3 = null;

                    for(v in vs) {
                        var normal = normals[v[2] - 1];
                        var texcoord = texcoords[v[1] - 1];

                        if(normal == null) {
                            if(face_normal == null) {
                                var p1 = vertices[v1[0] - 1];
                                var p2 = vertices[v2[0] - 1];
                                var p3 = vertices[v3[0] - 1];
                                var a = p2 - p1;
                                var b = p3 - p1;
                                var nx = a.y * b.z - a.z * b.y;
                                var ny = a.z * b.x - a.x * b.z;
                                var nz = a.x * b.y - a.y * b.x;
                                face_normal = new math.Vector3(nx, ny, nz);
                            }

                            normal = face_normal;
                        }

                        if(texcoord == null) {
                            texcoord = new math.Vector2(Math.random(), Math.random());
                        }

                        buffer.add(vertices[v[0] - 1], normal, texcoord);
                    }
                }
            }
        }

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
