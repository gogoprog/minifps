package;

abstract DataBuffer(js.lib.Float32Array) from js.lib.Float32Array to js.lib.Float32Array {
    static inline var count = 1024;
    static inline var stride = 12;

    public function new() {
        this = new js.lib.Float32Array(count * 4 * 3);
    }

    public function setPosition(i, v:math.Vector3) {
        this[i * stride + 0] = v.x;
        this[i * stride + 1] = v.y;
        this[i * stride + 2] = v.z;
    }

    public function setTexCoord(i, u, v) {
        this[i * stride + 8] = u;
        this[i * stride + 9] = v;
    }

}
