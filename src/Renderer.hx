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
var depthTexture:js.html.webgl.Texture;
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
var useTextureUniformLocation:js.html.webgl.UniformLocation;
var mainSamplerUniformLocation:js.html.webgl.UniformLocation;
var screenSamplerUniformLocation:js.html.webgl.UniformLocation;
var depthSamplerUniformLocation:js.html.webgl.UniformLocation;
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
        js.Syntax.code(" for(i in g=c.getContext(`webgl2`)) { g[i[0]+i[6]]=g[i]; } ");
        gl = Shim.g;
        gl.enable(gl.DEPTH_TEST);
        gl.enable(gl.BLEND);
        gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
        gl.disable(gl.CULL_FACE);
        {
            var w = js.Browser.window.innerWidth;
            var h = js.Browser.window.innerHeight;
            resize(w, h);
            var b = js.Browser.document.body;
            b.onresize = function(e) {
                var w = js.Browser.window.innerWidth;
                var h = js.Browser.window.innerHeight;
                resize(w, h);
            };

            b.style.border = "0";
            b.style.padding = "0";
            b.style.margin = "0";
        }

        {
            outlineProgram = createProgram2(Macros.getFileContent("src/outline_vs.glsl"), Macros.getFileContent("src/outline_fs.glsl"));
            screenSamplerUniformLocation = gl.getUniformLocation(outlineProgram, "screenSampler");
            depthSamplerUniformLocation = gl.getUniformLocation(outlineProgram, "depthSampler");
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
            useTextureUniformLocation = gl.getUniformLocation(program, "uUseTexture");
            mainSamplerUniformLocation = gl.getUniformLocation(program, "mainSampler");
            positionLocation = gl.getAttribLocation(program, 'aPosition');
            normalLocation = gl.getAttribLocation(program, 'aNormal');
            texCoordLocation = gl.getAttribLocation(program, 'aTexCoord');
        }
    }

    inline static public function setCamera(position:math.Vector3, yaw, pitch) {
        cameraPosition.copyFrom(position);
        cameraYaw = yaw;
        cameraPitch = pitch;
    }

    inline static public function preRender() {
        useProgram(program);
        // gl.uniform1f(timeUniformLocation, t);
        gl.uniform2f(resolutionUniformLocation, Shim.canvas.width, Shim.canvas.height);
        gl.uniform3f(cameraPositionUniformLocation, cameraPosition[0], cameraPosition[1], cameraPosition[2]);
        gl.uniform1f(cameraYawUniformLocation, cameraYaw);
        gl.uniform1f(cameraPitchUniformLocation, cameraPitch);
        gl.uniform1i(useCameraUniformLocation, 1);
        gl.uniform1i(useTextureUniformLocation, 0);
        gl.uniform1f(scaleUniformLocation, 1.0);
        gl.bindFramebuffer(gl.FRAMEBUFFER, mainFramebuffer);
        gl.clearColor(0.87, 0.97, 0.80, 1.0);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
        gl.activeTexture(gl.TEXTURE0);
    }

    inline static public function postRender() {
        gl.bindFramebuffer(gl.FRAMEBUFFER, null);
        gl.bindBuffer(gl.ARRAY_BUFFER, null);
        gl.bindVertexArray(null);
        useProgram(outlineProgram);
        gl.activeTexture(gl.TEXTURE0);
        gl.bindTexture(gl.TEXTURE_2D, mainTexture);
        gl.activeTexture(gl.TEXTURE1);
        gl.bindTexture(gl.TEXTURE_2D, depthTexture);
        gl.uniform1i(screenSamplerUniformLocation, 0);
        gl.uniform1i(depthSamplerUniformLocation, 1);
        draw(6);
    }

    inline static public function setModelPosition(pos:math.Vector3) {
        gl.uniform3f(positionUniformLocation, pos.x, pos.y, pos.z);
    }

    inline static public function drawModel(model:ModelData, useCam:Bool=true, scale:Float=1.0, yaw=0.0, pitch=0.0) {
        gl.bindTexture(gl.TEXTURE_2D, model.texture);
        gl.uniform1i(useCameraUniformLocation, useCam ? 1 : 0);
        gl.uniform1i(useTextureUniformLocation, (model.texture != null) ? 1 : 0);
        gl.uniform1f(scaleUniformLocation, scale);
        gl.uniform1f(globalYawUniformLocation, yaw);
        gl.uniform1f(globalPitchUniformLocation, pitch);
        gl.bindVertexArray(model.vertexArrayObject);
        draw(model.vertexCount);
    }

    inline static public function createVertexArrayObject(data:DataBuffer) {
        var vao = gl.createVertexArray();
        gl.bindVertexArray(vao);
        var vertexBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW);
        var stride = 12 * 4;
        gl.enableVertexAttribArray(positionLocation);
        gl.vertexAttribPointer(positionLocation, 3, gl.FLOAT, false, stride, 0);
        gl.enableVertexAttribArray(normalLocation);
        gl.vertexAttribPointer(normalLocation, 3, gl.FLOAT, false, stride, 4 * 4);
        gl.enableVertexAttribArray(texCoordLocation);
        gl.vertexAttribPointer(texCoordLocation, 2, gl.FLOAT, false, stride, 8 * 4);
        return vao;
    }

    inline static public function createText(text, width, height, ?bgcolor) {
        var textCtx = cast(js.Browser.document.createElement("canvas"), js.html.CanvasElement).getContext("2d");
        textCtx.canvas.width  = width;
        textCtx.canvas.height = height;
        textCtx.font = "20px monospace";
        textCtx.textAlign = "center";
        textCtx.textBaseline = "middle";
        textCtx.clearRect(0, 0, textCtx.canvas.width, textCtx.canvas.height);

        if(bgcolor != null) {
            textCtx.fillStyle = bgcolor;
            textCtx.fillRect(0, 0, textCtx.canvas.width, textCtx.canvas.height);
        }

        textCtx.fillStyle = "black";
        textCtx.fillText(text, width / 2, height / 2);
        var result = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, result);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, textCtx.canvas);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
        return result;
    }

    inline static public function resize(w, h) {
        Shim.canvas.width = w;
        Shim.canvas.height = h;
        mainFramebuffer = gl.createFramebuffer();
        gl.bindFramebuffer(gl.FRAMEBUFFER, mainFramebuffer);
        mainTexture = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, mainTexture);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, Shim.canvas.width, Shim.canvas.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, mainTexture, 0);
        depthTexture = gl.createTexture();
        gl.bindTexture(gl.TEXTURE_2D, depthTexture);
        gl.texImage2D(gl.TEXTURE_2D, 0, gl.DEPTH_COMPONENT24, Shim.canvas.width, Shim.canvas.height, 0, gl.DEPTH_COMPONENT, gl.UNSIGNED_INT, null);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
        gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.TEXTURE_2D, depthTexture, 0);
        gl.checkFramebufferStatus(gl.FRAMEBUFFER);
        gl.viewport(0, 0, w, h);
    }
}
