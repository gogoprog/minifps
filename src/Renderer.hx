package;

@:native("")
extern private class Shim {
    @:native("c") static var canvas:js.html.CanvasElement;
    @:native("g") static var g:Dynamic;
}
var gl:Dynamic;
var globalYaw = 0.0;
var globalPitch = 0.0;
var cameraPosition:math.Vector3 = [0, 1, 5];
var cameraYaw = 0.0;
var cameraPitch = 0.0;
var program:js.html.webgl.Program;
var mainTexture:js.html.webgl.Texture;
var outlineProgram:js.html.webgl.Program;
var timeUniformLocation:js.html.webgl.UniformLocation;
var cameraPositionUniformLocation:js.html.webgl.UniformLocation;
var positionUniformLocation:js.html.webgl.UniformLocation;
var cameraYawUniformLocation:js.html.webgl.UniformLocation;
var cameraPitchUniformLocation:js.html.webgl.UniformLocation;
var globalYawUniformLocation:js.html.webgl.UniformLocation;
var globalPitchUniformLocation:js.html.webgl.UniformLocation;
var useCameraUniformLocation:js.html.webgl.UniformLocation;
var scaleUniformLocation:js.html.webgl.UniformLocation;
var resolutionUniformLocation:js.html.webgl.UniformLocation;
var mainSamplerUniformLocation:js.html.webgl.UniformLocation;
var positionLocation:Int;
var normalLocation:Int;
var texCoordLocation:Int;

var mainFramebuffer:js.html.webgl.Framebuffer;

class Renderer {
    inline static function createProgram() {
        return gl.cP();
    }

    inline static function createShader(a) {
        return gl.cS(a);
    }

    inline static function shaderSource(a, b) {
        gl.sS(a, b);
    }

    inline static function compileShader(a) {
        gl.compileShader(a);
#if dev

        if(!gl.getShaderParameter(a, gl.COMPILE_STATUS)) {
            trace("An error occurred compiling the shaders: ");
            trace(gl.getShaderInfoLog(a));
        }

#end
    }

    inline static function attachShader(a, b) {
        gl.aS(a, b);
    }

    inline static function linkProgram(a) {
        gl.lo(a);
#if dev

        if(!gl.getProgramParameter(a, gl.LINK_STATUS)) {
            trace("An error occurred linking the program: ");
            trace(gl.getProgramInfoLog(a));
        }

#end
    }

    inline static function useProgram(a) {
        gl.ug(a);
    }

    inline static function fragmentShader() {
        return gl.FRAGMENT_SHADER;
    }

    inline static function vertexShader() {
        return gl.VERTEX_SHADER;
    }

    inline static function draw(count) {
        gl.dr(gl.TRIANGLES, 0, count);
    }

    inline static function createProgram2(vs_src, fs_src) {
        var vs = createShader(vertexShader());
        shaderSource(vs, vs_src);
        compileShader(vs);
        var fs = createShader(fragmentShader());
        shaderSource(fs, fs_src);
        compileShader(fs);
        var program = createProgram();
        attachShader(program, vs);
        attachShader(program, fs);
        linkProgram(program);
        return program;
    }

    inline static public function init() {
        Shim.canvas.width = 800;
        Shim.canvas.height = 600;
        js.Syntax.code(" for(i in g=c.getContext(`webgl2`)) { g[i[0]+i[6]]=g[i]; } ");
        gl = Shim.g;
        gl.enable(gl.DEPTH_TEST);
        gl.disable(gl.CULL_FACE);
        {
            outlineProgram = createProgram2(Macros.getFileContent("src/outline_vs.glsl"), Macros.getFileContent("src/outline_fs.glsl"));
            mainSamplerUniformLocation = gl.getUniformLocation(outlineProgram, "mainSampler");
        }
        {
            var vs_src = Macros.getFileContent("src/vs.glsl");
            var fs_src = Macros.getFileContent("src/fs.glsl");
            program = createProgram2(vs_src, fs_src);
            useProgram(program);
            timeUniformLocation = gl.getUniformLocation(program, "uTime");
            cameraPositionUniformLocation = gl.getUniformLocation(program, "uCameraPosition");
            positionUniformLocation = gl.getUniformLocation(program, "uPosition");
            cameraYawUniformLocation = gl.getUniformLocation(program, "uCameraYaw");
            cameraPitchUniformLocation = gl.getUniformLocation(program, "uCameraPitch");
            globalYawUniformLocation = gl.getUniformLocation(program, "uGlobalYaw");
            globalPitchUniformLocation = gl.getUniformLocation(program, "uGlobalPitch");
            useCameraUniformLocation = gl.getUniformLocation(program, "uUseCamera");
            scaleUniformLocation = gl.getUniformLocation(program, "uScale");
            resolutionUniformLocation = gl.getUniformLocation(program, "uResolution");
            gl.uniform2f(resolutionUniformLocation, Shim.canvas.width, Shim.canvas.height);
            positionLocation = gl.getAttribLocation(program, 'aPosition');
            normalLocation = gl.getAttribLocation(program, 'aNormal');
            texCoordLocation = gl.getAttribLocation(program, 'aTexCoord');
        }
        mainFramebuffer = gl.createFramebuffer();
        gl.bindFramebuffer(gl.FRAMEBUFFER, mainFramebuffer);
        mainTexture = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, mainTexture);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, Shim.canvas.width, Shim.canvas.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, mainTexture, 0);
        var depthBuffer = gl.createRenderbuffer();
        gl.bindRenderbuffer(gl.RENDERBUFFER, depthBuffer);
        gl.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, Shim.canvas.width, Shim.canvas.height);
        gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, depthBuffer);
    }

    inline static public function setCamera(position:math.Vector3, yaw, pitch) {
        cameraPosition.copyFrom(position);
        cameraYaw = yaw;
        cameraPitch = pitch;
    }

    inline static public function preRender() {
        useProgram(program);
        // gl.uniform1f(timeUniformLocation, t);
        gl.uniform3f(cameraPositionUniformLocation, cameraPosition[0], cameraPosition[1], cameraPosition[2]);
        gl.uniform1f(cameraYawUniformLocation, cameraYaw);
        gl.uniform1f(cameraPitchUniformLocation, cameraPitch);
        gl.uniform1i(useCameraUniformLocation, 1);
        gl.uniform1f(scaleUniformLocation, 1.0);
        gl.bindFramebuffer(gl.FRAMEBUFFER, mainFramebuffer);
        gl.clearColor(0.87, 0.97, 0.80, 1.0);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    }

    inline static public function postRender() {
        gl.bindFramebuffer(gl.FRAMEBUFFER, null);
        gl.bindBuffer(gl.ARRAY_BUFFER, null);
        gl.activeTexture(gl.TEXTURE0);
        gl.bindTexture(gl.TEXTURE_2D, mainTexture);
        useProgram(outlineProgram);
        gl.uniform1i(mainSamplerUniformLocation, 0);
        draw(6);
    }

    inline static public function setModelPosition(pos:math.Vector3) {
        gl.uniform3f(positionUniformLocation, pos.x, pos.y, pos.z);
    }

    inline static public function drawModel(model:Model, useCam:Bool=true, scale:Float=1.0, yaw=0.0, pitch=0.0) {
        gl.uniform1i(useCameraUniformLocation, useCam ? 1 : 0);
        gl.uniform1f(scaleUniformLocation, scale);
        gl.uniform1f(globalYawUniformLocation, yaw);
        gl.uniform1f(globalPitchUniformLocation, pitch);
        var stride = 12 * 4;
        gl.bindBuffer(gl.ARRAY_BUFFER, model.vertexBuffer);
        gl.enableVertexAttribArray(positionLocation);
        gl.vertexAttribPointer(positionLocation, 3, gl.FLOAT, false, stride, 0);
        gl.enableVertexAttribArray(normalLocation);
        gl.vertexAttribPointer(normalLocation, 3, gl.FLOAT, false, stride, 4 * 4);
        gl.enableVertexAttribArray(texCoordLocation);
        gl.vertexAttribPointer(texCoordLocation, 2, gl.FLOAT, false, stride, 8 * 4);
        draw(model.vertexCount);
    }

    inline static public function createVertexBuffer(data:DataBuffer) {
        var vertexBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW);
        return vertexBuffer;
    }

    // inline static public function
}
