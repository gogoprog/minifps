package math;

abstract Rectangle(Array<Float>) from Array<Float> to Array<Float> {
    public function new(x=0.0, y=0.0, w=0.0, h=0.0) {
        this = [x, y, w, h];
    }
    public var x(get, set):Float;
    inline function get_x() return this[0];
    inline function set_x(value) return this[0] = value;

    public var y(get, set):Float;
    inline function get_y() return this[1];
    inline function set_y(value) return this[1] = value;

    public var width(get, set):Float;
    inline function get_width() return this[2];
    inline function set_width(value) return this[2] = value;

    public var height(get, set):Float;
    inline function get_height() return this[3];
    inline function set_height(value) return this[3] = value;

    public var bottom(get, never):Float;
    inline function get_bottom() return y;

    public var top(get, never):Float;
    inline function get_top() return y + height;

    public var left(get, never):Float;
    inline function get_left() return x;

    public var right(get, never):Float;
    inline function get_right() return x + width;
}
