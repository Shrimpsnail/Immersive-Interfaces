#version 330

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    #moj_import <minecraft:fog.glsl>
    #moj_import <minecraft:sample_lightmap.glsl>
#endif

#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:interfaces.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    in ivec2 UV2;
#endif


uniform sampler2D Sampler0;

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    uniform sampler2D Sampler2;
#endif


out vec4 vertexColor;
out vec2 texCoord0;

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    out float sphericalVertexDistance;
    out float cylindricalVertexDistance;
#endif

void main() {

    Data data = interfaces_text(ProjMat, GameTime, Sampler0, Position, UV0, Color);

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = data.color * sample_lightmap(Sampler2, UV2);
#else
    vertexColor = data.color;
#endif

    //vertexColor = data.color;
    texCoord0 = data.uv0;
    gl_Position = ProjMat * ModelViewMat * vec4(data.position, 1.0);

}