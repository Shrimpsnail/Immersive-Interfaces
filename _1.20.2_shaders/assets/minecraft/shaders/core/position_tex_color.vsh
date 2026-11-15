#version 460

#moj_import <interfaces.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform float GameTime;

out vec2 texCoord0;
out vec4 vertexColor;// 1.21


void main() {

    Data data = interfaces(ProjMat, GameTime,Sampler0, Position, UV0);
    texCoord0 = data.uv0;
    vertexColor = Color; // 1.21
    gl_Position = ProjMat * ModelViewMat * vec4(data.position, 1.0);
}