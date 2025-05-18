#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;


out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;


vec2[] corners = vec2[](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));

float margin = 0;
vec2 screen = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);

void main() {
    
    vec3 pos = Position;
    vec4 textColor = Color;

    int vertID = gl_VertexID % 4;
    vec2 corner = corners[vertID];
    vec4 color = round(texture(Sampler0, UV0-(0.001*corner))*255);

    ivec2 halfScreen = ivec2(0.49+(screen/2));

    
    if(color.a == 1){
        textColor = vec4(1,1,1,1);

        int size[] = {0,184,200,190,176,250,78,200};

        if(color.r != 0) pos.x = halfScreen.x+size[int(color.r)]*(corner.x-0.5);
        if(color.b == 1) pos.z += 200;

    }

    if(color.a == 1 && round(255*Color.r) != 64.0) pos = vec3(0,0,0); // Remove if not in UI
    




    vertexColor = textColor * texelFetch(Sampler2, UV2 / 16, 0);
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    texCoord0 = UV0;    
}
    //Still don't know if i've fixed this yet
    /*if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-91,0 ,margin))) ||
       ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-91,198,margin)))) {

    if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-123,0 ,margin))) ||
       ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-123,166,margin)))) {

            pos = vec3(0,0,0);
    }}*/