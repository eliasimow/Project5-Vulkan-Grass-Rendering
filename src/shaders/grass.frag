#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare fragment shader inputs
layout(location = 0) in vec3 fs_position;
layout(location = 1) in vec3 fs_normal;
layout(location = 2) in vec3 fs_up;
layout(location = 3) in vec2 fs_uv;



layout(location = 0) out vec4 outColor;

void main() {
    vec3 lightDir = normalize(vec3(0.3, 1.0, 0.2));

    vec3 N = normalize(fs_normal);

    float NdotL = max(dot(N, lightDir), 0.0);

    vec3 grassColor = vec3(0.1, 0.8, 0.2);

    // Ambient + diffuse term
    vec3 ambient = 0.2 * grassColor;
    vec3 diffuse = NdotL * grassColor;

    vec3 color = ambient + diffuse;

    outColor = vec4(color, 1.0);
}
