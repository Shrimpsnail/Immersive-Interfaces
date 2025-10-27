#version 150

#moj_import <fog.glsl>
#moj_import <minecraft:interfaces.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat3 IViewRotMat;
uniform mat4 ProjMat;
uniform int FogShape;
//uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;


void main() {
    

    Data data = interfaces_text(ProjMat, GameTime, Sampler0, Position, UV0, Color);

    vertexColor = data.color * texelFetch(Sampler2, UV2 / 16, 0);
    gl_Position = ProjMat * ModelViewMat * vec4(data.position, 1.0);
    texCoord0 = UV0;

    vertexDistance = fog_distance(Position, FogShape);

}