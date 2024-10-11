#version 300 es
precision highp float;

uniform sampler2D screenSampler;
uniform sampler2D depthSampler;

out vec4 fragColor;

float linearize_depth(float d) {
    const float near = 0.01;
    const float far = 1000.0;
    float z_n = 2.0 * d - 1.0;
    return 2.0 * near * far / (far + near - z_n * (far - near));
}

const vec2 deltas[4] = vec2[4](vec2(-1, 0), vec2(1, 0), vec2(0, 1), vec2(0, -1));

void main() {
    vec2 coord = gl_FragCoord.xy;
    ivec2 icoord = ivec2(int(coord.x), int(coord.y));
    vec4 color = texelFetch(screenSampler, icoord, 0);
    float depth = linearize_depth(texelFetch(depthSampler, icoord, 0).r);

    for (int i = 0; i < 4; ++i) {
        vec2 delta = deltas[i];
        vec2 coord = gl_FragCoord.xy + delta;
        ivec2 icoord = ivec2(int(coord.x), int(coord.y));

        float other_depth = linearize_depth(texelFetch(depthSampler, icoord, 0).r);

        if (abs(depth - other_depth) > 2.0 * other_depth / 10.0) {
            color = vec4(0.0, 0.0, 0.0, 1.0);
            break;
        }
    }

    fragColor = vec4(color.rgb, 1.0);
}
