#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

in gl_PerVertex {
    vec4 gl_Position;
} gl_in[];

// TODO: Declare tessellation control shader inputs and outputs

layout(location = 0) in vec4 v0[];

layout(location = 1) in vec4 v1[];

layout(location = 2) in vec4 v2[];

layout(location = 3) in vec4 model_up[];

layout(location = 0) out vec4 out_v0[];

layout(location = 1) out vec4 out_v1[];

layout(location = 2) out vec4 out_v2[];

layout(location = 3) out vec4 out_up[];



void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// TODO: Write any shader outputs
    out_v0[gl_InvocationID] = v0[gl_InvocationID];
    out_v1[gl_InvocationID] = v1[gl_InvocationID];
    out_v2[gl_InvocationID] = v2[gl_InvocationID];
    out_up[gl_InvocationID] = model_up[gl_InvocationID];

    float level = 10;
    gl_TessLevelInner[0] = level;
    gl_TessLevelInner[1] = level;
    gl_TessLevelOuter[0] = level;
    gl_TessLevelOuter[1] = level;
    gl_TessLevelOuter[2] = level;
    gl_TessLevelOuter[3] = level;

	// TODO: Set level of tesselation
    // gl_TessLevelInner[0] = ???
    // gl_TessLevelInner[1] = ???
    // gl_TessLevelOuter[0] = ???
    // gl_TessLevelOuter[1] = ???
    // gl_TessLevelOuter[2] = ???
    // gl_TessLevelOuter[3] = ???
}
