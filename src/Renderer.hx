package;

@:native("")
extern private class Shim {
    @:native("c") static var canvas:js.html.CanvasElement;
    @:native("g") static var g:Dynamic;
}

var globalYaw = 0.0;
var globalPitch = 0.0;
var cameraPosition:math.Vector3 = [0, 1, 5];
var cameraYaw = 0.0;
var cameraPitch = 0.0;
var program:js.html.webgl.Program;
var timeUniformLocation:js.html.webgl.UniformLocation;
var cameraPositionUniformLocation:js.html.webgl.UniformLocation;
var cameraYawUniformLocation:js.html.webgl.UniformLocation;
var cameraPitchUniformLocation:js.html.webgl.UniformLocation;
var globalYawUniformLocation:js.html.webgl.UniformLocation;
var globalPitchUniformLocation:js.html.webgl.UniformLocation;
var useCameraUniformLocation:js.html.webgl.UniformLocation;
var scaleUniformLocation:js.html.webgl.UniformLocation;
var resolutionUniformLocation:js.html.webgl.UniformLocation;

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

    inline static public function init() {
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
        {
            var buffer = World.load();
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

    inline static public function setCamera(position:math.Vector3, yaw, pitch) {
        cameraPosition.copyFrom(position);
        cameraYaw = yaw;
        cameraPitch = pitch;
    }

    inline static public function preRender() {
        Shim.g.clearColor(0.87, 0.97, 0.80, 1.0);
        Shim.g.clear(Shim.g.COLOR_BUFFER_BIT | Shim.g.DEPTH_BUFFER_BIT);
        // Shim.g.uniform1f(timeUniformLocation, t);
        Shim.g.uniform3f(cameraPositionUniformLocation, cameraPosition[0], cameraPosition[1], cameraPosition[2]);
        Shim.g.uniform1f(cameraYawUniformLocation, cameraYaw);
        Shim.g.uniform1f(cameraPitchUniformLocation, cameraPitch);
        Shim.g.uniform1i(useCameraUniformLocation, 1);
        Shim.g.uniform1f(scaleUniformLocation, 1.0);
    }

    inline static public function drawMap() {
        Shim.g.uniform1f(globalYawUniformLocation, globalYaw);
        Shim.g.uniform1f(globalPitchUniformLocation, globalPitch);
        Shim.g.uniform1i(useCameraUniformLocation, 1);
        Shim.g.uniform1f(scaleUniformLocation, 1.0);
        draw(World.getVertexCount());
    }

    inline static public function drawModel(model:Model) {
        Shim.g.bindBuffer(Shim.g.ARRAY_BUFFER, model.vertexBuffer);
        draw(model.vertexCount);
    }

    inline static public function createVertexBuffer(data:DataBuffer) {
        var vertexBuffer = Shim.g.createBuffer();
        Shim.g.bindBuffer(Shim.g.ARRAY_BUFFER, vertexBuffer);
        Shim.g.bufferData(Shim.g.ARRAY_BUFFER, data, Shim.g.STATIC_DRAW);
        var stride = 12 * 4;
        {
            var location = Shim.g.getAttribLocation(program, 'aPosition');
            Shim.g.enableVertexAttribArray(location);
            Shim.g.vertexAttribPointer(location, 3, Shim.g.FLOAT, false, stride, 0);
        }
        {
            var location = Shim.g.getAttribLocation(program, 'aNormal');
            Shim.g.enableVertexAttribArray(location);
            Shim.g.vertexAttribPointer(location, 3, Shim.g.FLOAT, false, stride, 4 * 4);
        }
        {
            var location = Shim.g.getAttribLocation(program, 'aTexCoord');
            Shim.g.enableVertexAttribArray(location);
            Shim.g.vertexAttribPointer(location, 2, Shim.g.FLOAT, false, stride, 8 * 4);
        }
        return vertexBuffer;
    }
}
