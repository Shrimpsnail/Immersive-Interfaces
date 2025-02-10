#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;

out vec2 texCoord0;
out vec4 vertexColor;

vec2[] corners = vec2[](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));

int offset = 0;
float lastpos = 0;
float firstpos = 0;
bool hotbar = false;


//edges

float hotbar_l[4] = float[4](869.0,  389.0, 229.0,149.0);
float hotbar_r[4] = float[4](1051.0, 571.0, 411.0,331.0);

float inventory[4] = float[4](949.0,469.0,309.0,229.0);


void main() {
    texCoord0 = UV0;
    vec3 pos = Position;
    vec4 color = texture(Sampler0, vec2(0));
    float uiScale = ScreenSize.x * ProjMat[0][0] * 0.5;

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    if (ivec4(round(color*255)) == ivec4(1,1,1,2)) {

        vec2 corner = corners[gl_VertexID % 4];
        texCoord0 = corner;


        pos.x = (corner.x-0.5) * 512;
        pos.y = (corner.y-0.5) * 512;

        if     ((gl_VertexID % 4 == 0 || gl_VertexID % 4 == 1) && Position.x == inventory[int(uiScale)-1]) pos.x += 77;
        else if((gl_VertexID % 4 == 2 || gl_VertexID % 4 == 3) && Position.x == inventory[int(uiScale)-1]+176) pos.x += 77;

        

        gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
        gl_Position.xy += vec2(1,-1);
    }
    
    if(pos.z == 310){

        if(( gl_VertexID % 4 == 1 || gl_VertexID % 4 == 0 ) && pos.x == hotbar_l[int(uiScale)-1]) hotbar = true;
        
        if(( gl_VertexID % 4 == 2 || gl_VertexID % 4 == 3 ) && pos.x == hotbar_r[int(uiScale)-1]) hotbar = true;
        
    }

    if( pos.z == 310 && hotbar){

        vec2 corner = corners[gl_VertexID % 4];

        pos.x -= ScreenSize.x/4/uiScale;
        pos.y -= ScreenSize.y/2/uiScale;

        gl_Position = ProjMat * ModelViewMat * vec4(pos.x*2,pos.y*2,pos.z, 1.0);

    }

    vertexColor = Color;
    
}

