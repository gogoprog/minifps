package;

@:native("")
extern private class Shim {
    @:native("c") static var canvas:js.html.CanvasElement;
    @:native("g") static var g:Dynamic;
}

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

var globalYaw = 0.0;
var globalPitch = 0.0;
var cameraPosition = [0.0, 1, 5];
var cameraYaw = 0.0;
var cameraPitch = 0.0;
var program:js.html.webgl.Program;
var mapGen:map.Generator = new map.Generator();
var timeUniformLocation:js.html.webgl.UniformLocation;
var cameraPositionUniformLocation:js.html.webgl.UniformLocation;
var cameraYawUniformLocation:js.html.webgl.UniformLocation;
var cameraPitchUniformLocation:js.html.webgl.UniformLocation;
var globalYawUniformLocation:js.html.webgl.UniformLocation;
var globalPitchUniformLocation:js.html.webgl.UniformLocation;
var useCameraUniformLocation:js.html.webgl.UniformLocation;
var scaleUniformLocation:js.html.webgl.UniformLocation;
var resolutionUniformLocation:js.html.webgl.UniformLocation;
var map:map.Map;

class Renderer {
    inline static function createProgram() {
        return Shim.g.cP();
    }
    inline static function createShader(a) {
        return Shim.g.cS(a);
    }
    inline static function shaderSource(a, b) {
        Shim.g.sS(a, b);
    }
    inline static function compileShader(a) {
        Shim.g.compileShader(a);
#if dev

        if(!Shim.g.getShaderParameter(a, Shim.g.COMPILE_STATUS)) {
            trace("An error occurred compiling the shaders: ");
            trace(Shim.g.getShaderInfoLog(a));
        }

#end
    }
    inline static function attachShader(a, b) {
        Shim.g.aS(a, b);
    }
    inline static function linkProgram(a) {
        Shim.g.lo(a);
#if dev

        if(!Shim.g.getProgramParameter(a, Shim.g.LINK_STATUS)) {
            trace("An error occurred linking the program: ");
            trace(Shim.g.getProgramInfoLog(a));
        }

#end
    }
    inline static function useProgram(a) {
        Shim.g.ug(a);
    }
    inline static function fragmentShader() {
        return Shim.g.FRAGMENT_SHADER;
    }
    inline static function vertexShader() {
        return Shim.g.VERTEX_SHADER;
    }
    inline static function draw(count) {
        Shim.g.dr(Shim.g.TRIANGLES, 0, count);
    }

    static public function init() {
        Shim.canvas.width = 512;
        Shim.canvas.height = 512;
        js.Syntax.code(" for(i in g=c.getContext(`webgl2`)) { g[i[0]+i[6]]=g[i]; } ");
        var src = Macros.getFileContent("src/vs.glsl");
        var vs = createShader(vertexShader());
        shaderSource(vs, src);
        compileShader(vs);
        var src = Macros.getFileContent("src/fs.glsl");
        var fs = createShader(fragmentShader());
        shaderSource(fs, src);
        compileShader(fs);
        program = createProgram();
        attachShader(program, vs);
        attachShader(program, fs);
        linkProgram(program);
        useProgram(program);
        Shim.g.enable(Shim.g.DEPTH_TEST);
        Shim.g.disable(Shim.g.CULL_FACE);
        map = mapGen.generate();
        var size = 10;
        {
            var buffer = new DataBuffer();
            buffer.setPosition(0, -size, 0, -size);
            buffer.setPosition(1, size, 0, -size);
            buffer.setPosition(2, size, 0, size);
            buffer.setPosition(3, -size, 0, size);
            buffer.setTexCoord(0, 0, 0);
            buffer.setTexCoord(1, 1, 0);
            buffer.setTexCoord(2, 1, 1);
            buffer.setTexCoord(3, 0, 1);
            trace(map.walls.length);
            var i = 4;

            for(w in map.walls) {
                buffer.setPosition(i+0, w.x1, 0, w.y1);
                buffer.setPosition(i+1, w.x2, 0, w.y2);
                buffer.setPosition(i+2, w.x2, 2, w.y2);
                buffer.setPosition(i+3, w.x1, 2, w.y1);
                buffer.setTexCoord(i+0, 0, 0);
                buffer.setTexCoord(i+1, 1 * w.getLength(), 0);
                buffer.setTexCoord(i+2, 1 * w.getLength(), 1);
                buffer.setTexCoord(i+3, 0, 1);
                i+=4;
            }

            trace(i);
            var ubo = Shim.g.createBuffer();
            Shim.g.bindBuffer(Shim.g.UNIFORM_BUFFER, ubo);
            Shim.g.bufferData(Shim.g.UNIFORM_BUFFER, buffer, Shim.g.STATIC_DRAW);
            Shim.g.bindBuffer(Shim.g.UNIFORM_BUFFER, null);
            var uboIndex = Shim.g.getUniformBlockIndex(program, "Data");
            Shim.g.uniformBlockBinding(program, uboIndex, 0);
            Shim.g.bindBufferBase(Shim.g.UNIFORM_BUFFER, 0, ubo);
        }
        timeUniformLocation = Shim.g.getUniformLocation(program, "uTime");
        cameraPositionUniformLocation = Shim.g.getUniformLocation(program, "uCameraPosition");
        cameraYawUniformLocation = Shim.g.getUniformLocation(program, "uCameraYaw");
        cameraPitchUniformLocation = Shim.g.getUniformLocation(program, "uCameraPitch");
        globalYawUniformLocation = Shim.g.getUniformLocation(program, "uGlobalYaw");
        globalPitchUniformLocation = Shim.g.getUniformLocation(program, "uGlobalPitch");
        useCameraUniformLocation = Shim.g.getUniformLocation(program, "uUseCamera");
        scaleUniformLocation = Shim.g.getUniformLocation(program, "uScale");
        resolutionUniformLocation = Shim.g.getUniformLocation(program, "uResolution");
        Shim.g.uniform2f(resolutionUniformLocation, Shim.canvas.width, Shim.canvas.height);
    }

    static public function setCamera(position, yaw, pitch) {
        cameraPosition[0] = position[0];
        cameraPosition[1] = position[1];
        cameraPosition[2] = position[2];
        cameraYaw = yaw;
        cameraPitch = pitch;
    }

    static public function preRender() {
        Shim.g.clearColor(0.87, 0.97, 0.80, 1.0);
        Shim.g.clear(Shim.g.COLOR_BUFFER_BIT | Shim.g.DEPTH_BUFFER_BIT);
        // Shim.g.uniform1f(timeUniformLocation, t);
        Shim.g.uniform3f(cameraPositionUniformLocation, cameraPosition[0], cameraPosition[1], cameraPosition[2]);
        Shim.g.uniform1f(cameraYawUniformLocation, cameraYaw);
        Shim.g.uniform1f(cameraPitchUniformLocation, cameraPitch);
    }

    static public function drawMap() {
        Shim.g.uniform1i(useCameraUniformLocation, 0);
        Shim.g.uniform1f(scaleUniformLocation, 1000.0);
        // draw(36);
        Shim.g.uniform1f(globalYawUniformLocation, globalYaw);
        Shim.g.uniform1f(globalPitchUniformLocation, globalPitch);
        Shim.g.uniform1i(useCameraUniformLocation, 1);
        Shim.g.uniform1f(scaleUniformLocation, 1.0);
        draw(6 + map.walls.length * 6);
    }

}
