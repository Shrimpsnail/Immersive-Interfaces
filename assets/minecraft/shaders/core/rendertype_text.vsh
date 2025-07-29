#version 150

#moj_import <fog.glsl>

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

    
    if(color.a == 1){//ui containers
        textColor = vec4(1,1,1,1);

        int size[8] = int[](0,184,200,190,176,250,78,200);

        if(color.r != 0) pos.x = halfScreen.x+size[int(color.r)]*(corner.x-0.5);
        if(color.b == 1) pos.z += 200;

    }
    if(color.a == 1 && round(255*Color.r) != 64.0) pos = vec3(0,0,0); // Remove if not in UI
    


    if(color.a == 2 && Color.rgba == vec4(1,1,1,1)){//non container uis 

        if(color.r == 1){//command block

            if(color.g == 1 || color.g == 3) pos.x = halfScreen.x+245*(corner.x-1)+1;
            if(color.g == 2 || color.g == 4) pos.x = halfScreen.x+245*(corner.x  )-1;

            if(color.g == 1 || color.g == 2) pos.y = -19+120*corner.y;
            if(color.g == 3 || color.g == 4) pos.y = -19+118+171*corner.y;

            if(color.b == 2) pos.x -= 49;
            if(color.b == 3) pos.x -= 47;
            if(color.b == 4) pos.x -= 223;
        }


    }else if (color.a == 2) pos = vec3(0,0,0);

    //Push purple
    if(Color.rgb == vec3(2.0/3.0,0,2.0/3.0)){

        textColor = vec4(1);
        pos.z +=5;
    }
    
    //===================================== Normal shader
    vertexColor = textColor * texelFetch(Sampler2, UV2 / 16, 0);
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    texCoord0 = UV0;
    //=====================================

}