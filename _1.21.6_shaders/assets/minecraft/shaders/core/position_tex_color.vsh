#version 150


#moj_import <fog.glsl>
#moj_import <dynamictransforms.glsl>
#moj_import <globals.glsl>
#moj_import <projection.glsl>
#moj_import <interfaces.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform sampler2D Sampler0;


out vec2 texCoord0;
out vec4 vertexColor;// 1.21


void main() {

    //====== Normal shader

    Data data = interfaces(ProjMat, GameTime, Sampler0, Position, UV0);
    texCoord0 = data.uv0;
    vertexColor = Color; // 1.21
    gl_Position = ProjMat * ModelViewMat * vec4(data.position, 1.0);
}