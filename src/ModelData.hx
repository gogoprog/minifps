package;

class ModelData {
    public var buffer:DataBuffer;
    public var vertexArrayObject:js.html.webgl.VertexArrayObject;
    public var vertexCount:Int;
    public var texture:js.html.webgl.Texture = null;

    public function new(buffer:DataBuffer) {
        this.buffer = buffer;
        vertexArrayObject = Renderer.createVertexArrayObject(buffer);
        vertexCount = buffer.getCount();
    }

    static public function createQuad(w:Float, h:Float) {
        var buffer = new DataBuffer(32);
        var n = new math.Vector3(0, 0, 1);
        var wsize = w*0.5;
        var hsize = h*0.5;
        buffer.add(new math.Vector3(-wsize, -hsize, 0), n, new math.Vector2(0, 0));
        buffer.add(new math.Vector3(wsize, -hsize, 0), n, new math.Vector2(1, 0));
        buffer.add(new math.Vector3(wsize, hsize, 0), n, new math.Vector2(1, 1));
        buffer.add(new math.Vector3(wsize, hsize, 0), n, new math.Vector2(1, 1));
        buffer.add(new math.Vector3(-wsize, hsize, 0), n, new math.Vector2(0, 1));
        buffer.add(new math.Vector3(-wsize, -hsize, 0), n, new math.Vector2(0, 0));
        return new ModelData(buffer);
    }
}
