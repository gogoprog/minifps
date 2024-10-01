package math;

abstract Triangle(Array<Vector3>) from Array<Vector3> to Array<Vector3> {
    public function new(a, b, c) {
        this = [a, b, c];
    }

    public var v1(get, set):Vector3;
    inline function get_v1() return this[0];
    inline function set_v1(value) return this[0] = value;
    public var v2(get, set):Vector3;
    inline function get_v2() return this[1];
    inline function set_v2(value) return this[1] = value;
    public var v3(get, set):Vector3;
    inline function get_v3() return this[2];
    inline function set_v3(value) return this[2] = value;

    public function distanceToPoint(p:Vector3):Float {
        var n = normal();
        var d = Vector3.dot(n, v1);
        var distanceToPlane = Math.abs(Vector3.dot(n, p) - d);

        var projectedPoint = p - n * distanceToPlane;

        if(isPointInTriangle(projectedPoint)) {
            return distanceToPlane;
        } else {
            return Math.min(
                pointToEdgeDistance(p, v1, v2),
                Math.min(
                    pointToEdgeDistance(p, v2, v3),
                    pointToEdgeDistance(p, v3, v1)
                )
            );
        }
    }

    private function normal():Vector3 {
        var edge1 = v2 - v1;
        var edge2 = v3 - v1;
        return edge1.cross(edge2).getNormalized();
    }

    private function isPointInTriangle(p:Vector3):Bool {
        var cross1 = (v2 - v1).cross(p - v1);
        var cross2 = (v3 - v2).cross(p - v2);
        var cross3 = (v1 - v3).cross(p - v3);

        return Vector3.dot(cross1, cross2) >= 0 && Vector3.dot(cross2, cross3) >= 0;
    }

    private function pointToEdgeDistance(p:Vector3, a:Vector3, b:Vector3):Float {
        var ab = b - a;
        var ap = p - a;
        var t = Vector3.dot(ap, ab) / ab.getSquareLength();

        if(t < 0) { return (p - a).getLength(); }

        if(t > 1) { return (p - b).getLength(); }

        var projection = a + ab * t;
        return (p - projection).getLength();
    }
}
