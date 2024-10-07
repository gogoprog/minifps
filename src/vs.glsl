#version 300 es
precision highp float;

in vec3 aPosition;
in vec3 aNormal;
in vec2 aTexCoord;

out vec2 vCoords;
out vec3 vNormal;

/*
struct Vertex
{
    vec4 position;
    vec4 normal;
    vec4 texCoords;
};

layout(std140) uniform Data {
    Vertex vertices[1024];
};
*/

uniform vec2 uResolution;
uniform vec3 uCameraPosition;
uniform vec3 uPosition;
uniform float uCameraYaw;
uniform float uCameraPitch;
uniform float uGlobalYaw;
uniform float uGlobalPitch;
uniform bool uUseCamera;
uniform float uScale;

const float fov = radians(60.0);
const float near = 0.01;
const float far = 1000.0;
const vec3 cameraUp = vec3(0.0, 1.0, 0.0);

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

mat3 computeNormalMatrix(mat4 mvMatrix) {
    mat3 normalMatrix = mat3(mvMatrix);
    normalMatrix = inverse(normalMatrix);
    normalMatrix = transpose(normalMatrix);
    return normalMatrix;
}

mat4 mat3ToMat4(mat3 rotationMatrix) {
    mat4 result = mat4(1.0);
    result[0].xyz = rotationMatrix[0];
    result[1].xyz = rotationMatrix[1];
    result[2].xyz = rotationMatrix[2];
    return result;
}

void main() {
    vec3 position;
    vec3 normal;

    vCoords = aTexCoord;

    float cosYaw = cos(uGlobalYaw);
    float sinYaw = sin(uGlobalYaw);
    float cosPitch = cos(uGlobalPitch);
    float sinPitch = sin(uGlobalPitch);
    mat3 rotationMatrix = mat3(cosYaw, 0.0, -sinYaw, sinYaw * sinPitch, cosPitch, cosYaw * sinPitch, sinYaw * cosPitch,
                               -sinPitch, cosYaw * cosPitch);

    position = uPosition + uScale * rotationMatrix * aPosition;
    normal = rotationMatrix * aNormal;

    mat4 projection = computeProjectionMatrix();
    mat4 view = computeViewMatrix();

    gl_Position = projection * view * vec4(position, 1.0);

    mat3 normalMatrix = computeNormalMatrix(mat3ToMat4(rotationMatrix) * view);

    // vNormal = normalize(normalMatrix * normal);
    vNormal = normal;

    if (!uUseCamera) {
        gl_Position = projection * vec4(position, 1.0);

        mat3 normalMatrix = computeNormalMatrix(view);
        vNormal = normalize(normalMatrix * normal);
    }
}
