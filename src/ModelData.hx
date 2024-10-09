package;

class ModelData {
    public var buffer:DataBuffer;
    public var vertexBuffer:js.html.webgl.Buffer;
    public var vertexArrayObject:js.html.webgl.VertexArrayObject;
    public var vertexCount:Int;

    public function new(buffer:DataBuffer) {
        this.buffer = buffer;
        // vertexBuffer = Renderer.createVertexBuffer(buffer);
        vertexArrayObject = Renderer.createVertexArrayObject(buffer);
        vertexCount = buffer.getCount();
    }

}
