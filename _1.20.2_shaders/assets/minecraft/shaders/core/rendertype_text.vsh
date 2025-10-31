#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:interfaces.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform float GameTime;
uniform int FogShape;
//uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    

    Data data = interfaces_text(ProjMat, GameTime, Sampler0, Position, UV0, Color);


    vertexColor = data.color * texelFetch(Sampler2, UV2 / 16, 0);
    gl_Position = ProjMat * ModelViewMat * vec4(data.position, 1.0);
    vertexDistance = fog_distance(Position, FogShape);
    texCoord0 = data.uv0;

}
    //Still don't know if i've fixed this yet
    /*if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-91,0 ,margin))) ||
       ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-91,198,margin)))) {

    if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-123,0 ,margin))) ||
       ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-123,166,margin)))) {

            pos = vec3(0,0,0);
    }}*/