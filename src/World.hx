package;

var data = Macros.getFileContent("data/Castle_Tower.obj");

class World {
    inline static public function load():DataBuffer {

        var result = new DataBuffer();

        trace(data);

        return result;
    }
}
