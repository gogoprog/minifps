package math;

abstract Vector3(Array<Float>) from Array<Float> to Array<Float> {
    public function new(x, y, z) {
        this = [x, y];
    }
    public var x(get, set):Float;
    inline function get_x() return this[0];
    inline function set_x(value) return this[0] = value;
    public var y(get, set):Float;
    inline function get_y() return this[1];
    inline function set_y(value) return this[1] = value;
    public var z(get, set):Float;
    inline function get_z() return this[2];
    inline function set_z(value) return this[2] = value;

    @:op(A * B)
    @:commutative
    inline static public function mulOp(a:Vector3, b:Float) {
        return new Vector3(a.x * b, a.y * b, a.z * b);
    }

    @:op(A / B)
    @:commutative
    inline static public function divOp(a:Vector3, b:Float) {
        return new Vector3(a.x / b, a.y / b, a.z / b);
    }

    @:op(A + B)
    inline static public function addOp(a:Vector3, b:Vector3) {
        return new Vector3(a.x + b.x, a.y + b.y, a.z + b.z);
    }

    @:op(A - B)
    inline static public function minOp(a:Vector3, b:Vector3) {
        return new Vector3(a.x - b.x, a.y - b.y, a.z - b.z);
    }

    static public function dot(a:Vector3, b:Vector3):Float {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }

    static public inline function getSquareDistance(a:Vector3, b:Vector3):Float {
        var dx = a.x - b.x;
        var dy = a.y - b.y;
        var dz = a.z - b.z;

        return dx * dx + dy * dy + dz * dz;
    }

    static public function getRotatedAroundY(vector:Vector3, angle:Float):Vector3 {
        var cosinus = Math.cos(angle);
        var sinus = Math.sin(angle);

        return new Vector3(vector.x * cosinus - vector.y * sinus, 0, vector.x * sinus + vector.y * cosinus);
    }

    public function normalize() {
        var len = getLength();
        this[0] /= len;
        this[1] /= len;
        this[2] /= len;
    }

    public function getAngleAroundY() : Float{
        return Math.atan2(this[2], this[0]);
    }

    public function getLength() : Float{
        return Math.sqrt(getSquareLength());
    }

    public function getSquareLength() : Float{
        return this[0] * this[0] + this[1] * this[1] + this[2] * this[2];
    }

    public function copyFrom(other:Vector3) {
        this[0] = other[0];
        this[1] = other[1];
        this[2] = other[2];
    }

    public function squareDistance(other:Vector3) {
        var dx = this[0] - other[0];
        var dy = this[1] - other[1];
        var dz = this[2] - other[2];
        return dx * dx + dy * dy + dz * dz;
    }

    public function set(x, y, z) {
        this[0] = x;
        this[1] = y;
        this[2] = z;
    }

    // public function setFromAngle(angle:Float, length:Float = 1.0) {
    //     this[0] = Math.cos(angle) * length;
    //     this[1] = Math.sin(angle) * length;
    // }

    public function getCopy():Vector3 {
        return new Vector3(this[0], this[1], this[2]);
    }

    public function add(other:Vector3) {
        this[0] += other.x;
        this[1] += other.y;
        this[2] += other.z;
    }

    public function mul(value:Float) {
        this[0] *= value;
        this[1] *= value;
        this[2] *= value;
    }

    public function cross(v:Vector3):Vector3 {
        return new Vector3(
            this[1] * v.z - this[2] * v.y,
            this[2] * v.x - this[0] * v.z,
            this[0] * v.y - this[1] * v.x
        );
    }

    public function getNormalized():Vector3 {
        var len = getLength();
        return new Vector3(x / len, y / len, z / len);
    }
}
