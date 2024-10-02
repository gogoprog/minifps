package;

abstract DataBuffer(js.lib.Float32Array) from js.lib.Float32Array to js.lib.Float32Array {
    static inline var stride = 12;

    public function new(maxcount:Int) {
        this = new js.lib.Float32Array(maxcount * 12);
        untyped this.count = 0;
    }

    public function add(p:math.Vector3, n:math.Vector3, t:math.Vector2) {
        var c = untyped this.count;
        setPosition(c, p);
        setTexCoord(c, t);
        untyped this.count++;
    }

    public function getCount():Int {
        return untyped this.count;
    }

    inline private function setPosition(i, v:math.Vector3) {
        this[i * stride + 0] = v.x;
        this[i * stride + 1] = v.y;
        this[i * stride + 2] = v.z;
    }

    inline private function setTexCoord(i, t:math.Vector2) {
        this[i * stride + 8] = t.x;
        this[i * stride + 9] = t.y;
    }

}
