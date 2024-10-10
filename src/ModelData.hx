package;

class ModelData {
    public var buffer:DataBuffer;
    public var vertexArrayObject:js.html.webgl.VertexArrayObject;
    public var vertexCount:Int;
    public var texure:js.html.webgl.Texture;

    public function new(buffer:DataBuffer) {
        this.buffer = buffer;
        vertexArrayObject = Renderer.createVertexArrayObject(buffer);
        vertexCount = buffer.getCount();
    }

}
