package;

class ObjLoader {
    inline static public function load(data:String):DataBuffer {
        var buffer = new DataBuffer();

        var lines = data.split('\n');

        for(line in lines) {
            var p = line.split(' ');

            switch(p[0]) {
                case 'v': {
                    var v = new math.Vector3(Std.parseFloat(p[1]), Std.parseFloat(p[2]), Std.parseFloat(p[3]));

                    trace(v);
                }

                case 'vn': {
                    var v = new math.Vector3(Std.parseFloat(p[1]), Std.parseFloat(p[2]), Std.parseFloat(p[3]));
                }

                case 'f': {
                }
            }
        }

        return buffer;
    }
}
