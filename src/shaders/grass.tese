#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
layout(location = 0) in vec4 v0[];
layout(location = 1) in vec4 v1[];
layout(location = 2) in vec4 v2[];
layout(location = 3) in vec4 up[];

layout(location = 0) out vec3 fs_position;
layout(location = 1) out vec3 fs_normal;
layout(location = 2) out vec3 fs_up;
layout(location = 3) out vec2 fs_uv;


void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

    vec3 a = v0[0].xyz + v * (v1[0].xyz - v0[0].xyz);
    vec3 b = v1[0].xyz + v * (v2[0].xyz - v1[0].xyz);
    vec3 c = a + v * (b - a);

    float width = v2[0].w;
    float height = v1[0].w;
    float angle = v0[0].w;

    vec3 tangentXZ = vec3(cos(angle), 0, sin(angle));

    vec3 c0 = c - width * tangentXZ;
    vec3 c1 = c + width * tangentXZ;
	
    vec3 tangentY = normalize(b-a);
    vec3 normalVec = normalize(cross(tangentXZ, tangentY));

    float t = 0.5 + (u - 0.5) * ((1 - max(v - 0.01, 0)) / (1 - 0.01));
    fs_position = mix(c0, c1, t);

    gl_Position = camera.proj * camera.view * vec4(fs_position, 1.0);
    fs_normal = normalVec;
    fs_uv = vec2(t, v);
}
