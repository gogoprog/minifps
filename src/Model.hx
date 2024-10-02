package;

class Model {
    public var vertexBuffer:js.html.webgl.Buffer;
    public var vertexCount:Int;

    public function new(buffer:DataBuffer) {
        vertexBuffer = Renderer.createVertexBuffer(buffer);
        vertexCount = buffer.getCount();
    }

}
