#version 300 es
precision highp float;

uniform vec2 uResolution;
uniform float uScale;
uniform float uCameraYaw;
uniform float uCameraPitch;

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

void main() {
    vec3 lightDir = normalize(vec3(1.0, 2.0, 1.0));
    vec3 ambient = vec3(0.3, 0.3, 0.3);
    float diff = max(dot(normalize(vNormal), lightDir), 0.0);
    vec3 litColor;

    vec3 baseColor;
    float squareSize = 0.001;
    vec2 squarePos = floor(vCoords.xy / squareSize);
    float random = fract(sin(dot(squarePos, vec2(12.9898, 78.233))) * 43758.5453);
    vec3 light = vec3(0.2, 0.2, 0.0);
    vec3 dark = vec3(0.8, 0.3, 0.0);
    baseColor = mix(light, dark, step(0.5, random));

    litColor = ambient + baseColor * (diff * 0.6 + 0.4);

    vec2 uv = gl_FragCoord.xy / uResolution;
    vec2 center = vec2(0.5, 0.5);
    float crosshairSize = 0.01;
    float crosshairThickness = 0.002;

    // Calculate aspect ratio
    float aspectRatio = uResolution.x / uResolution.y;

    // Adjust UV coordinates for aspect ratio
    vec2 adjustedUV = (uv - center) * vec2(aspectRatio, 1.0) + center;

    if (abs(adjustedUV.x - center.x) < crosshairThickness && abs(adjustedUV.y - center.y) < crosshairSize ||
        abs(adjustedUV.y - center.y) < crosshairThickness && abs(adjustedUV.x - center.x) < crosshairSize) {
        fragColor = vec4(1.0, 0.0, 0.0, 1.0);
    } else {
        float val = 0.299 * litColor.r + 0.587 * litColor.g + 0.114 * litColor.b;

        if (val > 0.6) {
            val = 1.0;
        } else if (val < 0.4) {
            val = 0.0;
        } else {
            val = float(int(gl_FragCoord.x + gl_FragCoord.y) % int(10.0 * val));

            val = val > 0.5 ? 1.0 : 0.0;
        }

        if (val == 1.0f) {
            fragColor = vec4(0.87, 0.97, 0.80, 1.0);
        } else {
            fragColor = vec4(0.04, 0.1, 0.1, 1.0);
        }

        fragColor = vec4(litColor, 1.0);
    }
}
