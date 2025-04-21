#version 150

#moj_import <minecraft:fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;


vec2[] corners = vec2[](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));

float margin = 0;

bool vertex_compare(float position,float ScreenSize,float uiScale,float offset,float size,float margin) 
{
    return ( abs( (round(ScreenSize/uiScale/2)+offset+size) - position )<= margin );
}


void main() {
    
    vec3 pos = Position;
    vec4 textColor = Color;

    int vertID = gl_VertexID % 4;
    vec2 corner = corners[vertID];
    vec4 color = round(texture(Sampler0, UV0-(0.001*corner))*255);


    float uiScale = ScreenSize.x * ProjMat[0][0] * 0.5;
    vec2 screen = ScreenSize/uiScale;


    
    if(color.a == 1){
        textColor = vec4(1,1,1,1);


        //                        Chests        double    barrel      minecart                    
        vec2[] sizes   = vec2[]( vec2(0,0) , vec2(0,0) , vec2(0,0) , vec2(0,0) );
        vec2[] offsets = vec2[]( vec2(0,0) , vec2(0,0) , vec2(0,0) , vec2(0,0) );







        if(color.b == 1){

            pos.z += 300;
        }

    }

    if(color.a == 1 && round(255*Color.rgb) != vec3(64.0)) pos = vec3(0,0,0); // Remove if not in UI
    


    
    vertexColor = textColor * texelFetch(Sampler2, UV2 / 16, 0);
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
    vertexDistance = fog_distance(Position, FogShape);
    texCoord0 = UV0;
}
    // what the fuck is this for, i don't remember writing this
    /*if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-91,0 ,margin))) ||
       ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-91,198,margin)))) {

    if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-123,0 ,margin))) ||
       ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-123,166,margin)))) {

            pos = vec3(0,0,0);
    }}*/