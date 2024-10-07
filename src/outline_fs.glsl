#version 300 es
precision highp float;

uniform sampler2D mainSampler;
uniform sampler2D depthSampler;

out vec4 fragColor;

void main() {

    vec2 coord = gl_FragCoord.xy;
    vec2 size = vec2(textureSize(mainSampler, 0));
    vec4 color = texture(mainSampler, coord / size);

    fragColor = vec4(color.rgb, 1.0);
}
