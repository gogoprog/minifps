package;

class Model {
    public var buffer:DataBuffer;
    public var vertexBuffer:js.html.webgl.Buffer;
    public var vertexCount:Int;

    public function new(buffer:DataBuffer) {
        this.buffer = buffer;
        vertexBuffer = Renderer.createVertexBuffer(buffer);
        vertexCount = buffer.getCount();
    }

}
