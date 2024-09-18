package math;

abstract Vector2(Array<Float>) from Array<Float> to Array<Float> {
    public function new(x, y) {
        this = [x, y];
    }
    public var x(get, set):Float;
    inline function get_x() return this[0];
    inline function set_x(value) return this[0] = value;
    public var y(get, set):Float;
    inline function get_y() return this[1];
    inline function set_y(value) return this[1] = value;

    @:op(A * B)
    @:commutative
    inline static public function mulOp(a:Vector2, b:Float) {
        return new Vector2(a.x * b, a.y * b);
    }

    @:op(A / B)
    @:commutative
    inline static public function divOp(a:Vector2, b:Float) {
        return new Vector2(a.x / b, a.y / b);
    }

    @:op(A + B)
    inline static public function addOp(a:Vector2, b:Vector2) {
        return new Vector2(a.x + b.x, a.y + b.y);
    }

    @:op(A - B)
    inline static public function minOp(a:Vector2, b:Vector2) {
        return new Vector2(a.x - b.x, a.y - b.y);
    }

    static public function dot(a:Vector2, b:Vector2):Float {
        return a.x * b.x + a.y * b.y;
    }

    static public inline function getSquareDistance(a:Vector2, b:Vector2):Float {
        var dx = a.x - b.x;
        var dy = a.y - b.y;

        return dx * dx + dy *dy;
    }

    static public function getRotated(vector:Vector2, angle:Float):Vector2 {
        var cosinus = Math.cos(angle);
        var sinus = Math.sin(angle);

        return new Vector2(vector.x * cosinus - vector.y * sinus, vector.x * sinus + vector.y * cosinus);
    }

    public function normalize() {
        var len = getLength();
        this[0] /= len;
        this[1] /= len;
    }

    public function getAngle() : Float{
        return Math.atan2(this[1], this[0]);
    }

    public function getLength() : Float{
        return Math.sqrt(this[0] * this[0] + this[1] * this[1]);
    }

    public function getSquareLength() : Float{
        return this[0] * this[0] + this[1] * this[1];
    }

    public function copyFrom(other:Vector2) {
        this[0] = other[0];
        this[1] = other[1];
    }

    public function squareDistance(other:Vector2) {
        var dx = this[0] - other[0];
        var dy = this[1] - other[1];
        return dx * dx + dy * dy;
    }

    public function set(x, y) {
        this[0] = x;
        this[1] = y;
    }

    public function setFromAngle(angle:Float, length:Float = 1.0) {
        this[0] = Math.cos(angle) * length;
        this[1] = Math.sin(angle) * length;
    }

    public function getCopy():Vector2 {
        return new Vector2(this[0], this[1]);
    }

    public function add(other:Vector2) {
        this[0] += other.x;
        this[1] += other.y;
    }

    public function mul(value:Float) {
        this[0] *= value;
        this[1] *= value;
    }
}
