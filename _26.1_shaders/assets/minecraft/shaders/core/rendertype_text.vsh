#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:interfaces.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    
    Data data = interfaces_text(ProjMat, GameTime, Sampler0, Position, UV0, Color);


    vertexColor = data.color * texture(Sampler2, UV2 / 16);
    gl_Position = ProjMat * ModelViewMat * vec4(data.position, 1.0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    
    texCoord0 = data.uv0;
}
