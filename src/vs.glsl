#version 300 es
precision highp float;

out vec2 vCoords;
out vec3 vNormal;

layout(std140) uniform Data {
    vec4 uPositions[1024];
    vec4 uNormals[1024];
    vec4 uTexCoords[1024];
};

uniform vec2 uResolution;
uniform vec3 uCameraPosition;
uniform float uCameraYaw;
uniform float uCameraPitch;
uniform float uGlobalYaw;
uniform float uGlobalPitch;
uniform bool uUseCamera;
uniform float uScale;

const float fov = radians(60.0);
const float near = 0.1;
const float far = 1000.0;
const vec3 cameraUp = vec3(0.0, 1.0, 0.0);

const vec3 cubeVertices[8] =
    vec3[8](vec3(-0.5, -0.5, -0.5), vec3(0.5, -0.5, -0.5), vec3(0.5, 0.5, -0.5), vec3(-0.5, 0.5, -0.5),
            vec3(-0.5, -0.5, 0.5), vec3(0.5, -0.5, 0.5), vec3(0.5, 0.5, 0.5), vec3(-0.5, 0.5, 0.5));

const int cubeIndices[36] =
    int[36](0, 1, 2, 2, 3, 0, 1, 5, 6, 6, 2, 1, 5, 4, 7, 7, 6, 5, 4, 0, 3, 3, 7, 4, 3, 2, 6, 6, 7, 3, 4, 5, 1, 1, 0, 4);

const vec3 cubeNormals[6] = vec3[6](vec3(0.0, 0.0, -1.0), vec3(1.0, 0.0, 0.0), vec3(0.0, 0.0, 1.0),
                                    vec3(-1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(0.0, -1.0, 0.0));

float random(float seed) {
    return fract(sin(seed) * 43758.5453);
}

mat4 computeProjectionMatrix() {
    float aspect = uResolution.x / uResolution.y;
    float f = 1.0 / tan(fov * 0.5);
    float rangeInv = 1.0 / (near - far);

    return mat4(f / aspect, 0.0, 0.0, 0.0, 0.0, f, 0.0, 0.0, 0.0, 0.0, (near + far) * rangeInv, -1.0, 0.0, 0.0,
                near * far * rangeInv * 2.0, 0.0);
}

mat4 computeViewMatrix() {
    vec3 cameraPosition = uCameraPosition;

    vec3 cameraDirection;
    cameraDirection.x = cos(uCameraPitch) * sin(uCameraYaw);
    cameraDirection.y = sin(uCameraPitch);
    cameraDirection.z = cos(uCameraPitch) * cos(uCameraYaw);

    vec3 zaxis = normalize(cameraDirection);
    vec3 xaxis = normalize(cross(cameraUp, zaxis));
    vec3 yaxis = cross(zaxis, xaxis);

    return mat4(xaxis.x, yaxis.x, zaxis.x, 0.0, xaxis.y, yaxis.y, zaxis.y, 0.0, xaxis.z, yaxis.z, zaxis.z, 0.0,
                -dot(xaxis, cameraPosition), -dot(yaxis, cameraPosition), -dot(zaxis, cameraPosition), 1.0);
}

void main() {
    vec3 position;
    vec3 normal;

    int vertexIndex = gl_VertexID;

    position = uPositions[vertexIndex].xyz;

    position *= uScale;

    normal = uNormals[vertexIndex].xyz;

    vCoords = uTexCoords[vertexIndex].xy;

    float cosYaw = cos(uGlobalYaw);
    float sinYaw = sin(uGlobalYaw);
    float cosPitch = cos(uGlobalPitch);
    float sinPitch = sin(uGlobalPitch);
    mat3 rotationMatrix = mat3(cosYaw, 0.0, -sinYaw, sinYaw * sinPitch, cosPitch, cosYaw * sinPitch, sinYaw * cosPitch,
                               -sinPitch, cosYaw * cosPitch);

    position = rotationMatrix * position;

    mat4 projection = computeProjectionMatrix();
    mat4 view = computeViewMatrix();

    gl_Position = projection * view * vec4(position, 1.0);
    vNormal = rotationMatrix * normal;

    if (!uUseCamera) {
        gl_Position = projection * vec4(position, 1.0);
    }
}
