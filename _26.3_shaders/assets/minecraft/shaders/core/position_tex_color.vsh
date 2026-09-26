#version 330
#extension GL_ARB_separate_shader_objects : require
#extension GL_ARB_shader_draw_parameters : enable

#include <minecraft:dynamictransforms.glsl>
#include <minecraft:globals.glsl>
#include <minecraft:projection.glsl>
#include <minecraft:interfaces.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec2 UV0;
layout(location = 2) in vec4 Color;
layout(location = 3) in int gl_BaseVertexARB;

layout(location = 0) out vec2 texCoord0;
layout(location = 1) out vec4 vertexColor;

uniform sampler2D Sampler0;

void main() {
    Data data = interfaces(ProjMat, GameTime, Sampler0, Position, UV0);

    texCoord0 = data.uv0;
    vertexColor = Color; // 1.21
    gl_Position = ProjMat * ModelViewMat * vec4(data.position, 1.0);
}
