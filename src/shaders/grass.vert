
#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 1, binding = 0) uniform ModelBufferObject {
    mat4 model;
};

// TODO: Declare vertex shader inputs and outputs

out gl_PerVertex {
    vec4 gl_Position;
};

layout(location = 0) in vec4 in_v0;
layout(location = 1) in vec4 in_v1;
layout(location = 2) in vec4 in_v2;
layout(location = 3) in vec4 in_up;

layout(location = 0) out vec4 v0;
layout(location = 1) out vec4 v1;
layout(location = 2) out vec4 v2;
layout(location = 3) out vec4 model_up;

void main() {
	// TODO: Write gl_Position and any other shader outputs
    vec4 v0Temp = model * vec4(in_v0.xyz, 1.0);
    v0 = vec4((v0Temp / v0Temp.w).xyz, in_v0.w);

    vec4 v1Temp = model * vec4(in_v1.xyz, 1.0);
    v1 = vec4((v1Temp / v1Temp.w).xyz, in_v1.w);

    vec4 v2Temp = model * vec4(in_v2.xyz, 1.0);
    v2 = vec4((v2Temp / v2Temp.w).xyz, in_v2.w);

    vec4 upTemp = model * vec4(in_up.xyz, 0.0);
    model_up = vec4((upTemp / upTemp.w).xyz, in_up.w);

}
