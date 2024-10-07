#version 300 es
precision highp float;

const vec2 quadVertices[4] = vec2[4](vec2(-1, -1), vec2(1, -1), vec2(1, 1), vec2(-1, 1));
const int indices[6] = int[6](0, 1, 2, 2, 3, 0);

void main() {
    int id = indices[gl_VertexID % 6];
    vec2 position = quadVertices[id];

    gl_Position = vec4(position, 0.0, 1.0);
}
