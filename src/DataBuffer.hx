package;

abstract DataBuffer(js.lib.Float32Array) from js.lib.Float32Array to js.lib.Float32Array {
    static inline var count = 1024;
    public function new() {
        this = new js.lib.Float32Array(count * 4 * 3);
    }

    public function setPosition(i, x, y, z) {
        this[i * 4 + 0] = x;
        this[i * 4 + 1] = y;
        this[i * 4 + 2] = z;
    }

    public function setTexCoord(i, u, v) {
        this[count * 2 * 4 + i * 4 + 0] = u;
        this[count * 2 * 4 + i * 4 + 1] = v;
    }

}
