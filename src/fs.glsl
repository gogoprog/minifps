#version 300 es
precision highp float;

uniform vec2 uResolution;
uniform float uScale;
uniform float uCameraYaw;
uniform float uCameraPitch;
uniform bool uUseCamera;

in vec2 vCoords;
in vec3 vNormal;
out vec4 fragColor;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(random(i), random(i + vec2(1.0, 0.0)), u.x),
               mix(random(i + vec2(0.0, 1.0)), random(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 0.0;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

const mat4 bayerMatrix4x4 =
    mat4x4(0.0, 8.0, 2.0, 10.0, 12.0, 4.0, 14.0, 6.0, 3.0, 11.0, 1.0, 9.0, 15.0, 7.0, 13.0, 5.0) / 16.0;

void main() {
    vec3 lightDir = normalize(vec3(1.0, 2.0, -1.0));
    vec3 ambient = vec3(0.3, 0.3, 0.3);
    float diff = max(dot(normalize(vNormal), lightDir), 0.0);

    float squareSize = 0.1;
    vec2 squarePos = floor(vCoords.xy / squareSize);
    float random = fract(sin(dot(squarePos, vec2(12.9898, 78.233))) * 43758.5453);
    vec3 light = vec3(0.3, 0.2, 0.0);
    vec3 dark = vec3(0.8, 0.3, 0.0);
    vec3 baseColor = mix(light, dark, step(0.5, random));

    if (!uUseCamera) {
        baseColor = vec3(0.5, 0.5, 0.5);
    }

    vec3 litColor = ambient + baseColor * (diff * 0.6 + 0.1);

    // fragColor = vec4(litColor, 1.0);

    float val = 0.299 * litColor.r + 0.587 * litColor.g + 0.114 * litColor.b;

    int x = int(gl_FragCoord.x) % 4;
    int y = int(gl_FragCoord.y) % 4;
    float threshold = bayerMatrix4x4[y][x];

    if (val < threshold) {
        val = 0.0;
    } else {
        val = 1.0;
    }

    if (val == 1.0f) {
        fragColor = vec4(0.87, 0.97, 0.80, 1.0);
    } else {
        fragColor = vec4(0.04, 0.1, 0.1, 1.0);
    }
    // fragColor = vec4(litColor, 1.0);
    //
    // higher priority: outline
    /*
    if (dot(viewDirection, normalDirection) 
       < mix(_UnlitOutlineThickness, _LitOutlineThickness, 
       max(0.0, dot(normalDirection, lightDirection))))
    {
       fragmentColor = 
          vec3(_LightColor0) * vec3(_OutlineColor); 
    }
    */
}
