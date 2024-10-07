#version 300 es
precision highp float;

uniform sampler2D mainSampler;
uniform sampler2D depthSampler;

out vec4 fragColor;

void main() {
    vec2 coord = gl_FragCoord.xy;
    ivec2 icoord = ivec2(int(coord.x), int(coord.y));
    vec4 color = texelFetch(mainSampler, icoord, 0);
    //vec4 color = texelFetch(depthSampler, icoord, 0);

    fragColor = vec4(color.rgb, 1.0);
}
