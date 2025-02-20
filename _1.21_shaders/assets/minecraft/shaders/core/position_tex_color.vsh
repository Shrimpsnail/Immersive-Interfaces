#version 150


#moj_import <minecraft:interfaces.glsl>

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
bool hotbar = false;
float margin = 1;


void main() {
    texCoord0 = UV0;
    vec3 pos = Position;
    vec4 color = texture(Sampler0, vec2(0));
    vec4 drawnColor;
    float uiScale = ScreenSize.x * ProjMat[0][0] * 0.5;

    if(gl_VertexID % 4 == 0){
        drawnColor = texture(Sampler0, texCoord0);
    }else if(gl_VertexID % 4 == 1){
        drawnColor = texture(Sampler0, vec2(texCoord0.x,texCoord0.y-0.001));
    }else if(gl_VertexID % 4 == 2){
        drawnColor = texture(Sampler0, texCoord0- 0.001);
    }else{
        drawnColor = texture(Sampler0, vec2(texCoord0.x-0.001,texCoord0.y));


    }

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    

    if (ivec4(round(color*255)) == ivec4(1,1,1,2) || ivec4(round(color*255)) == ivec4(1,2,1,2)) {

        vec2 corner = corners[gl_VertexID % 4];
        texCoord0.x = corner.x/2;
        texCoord0.y = corner.y/2;


        pos.x = (corner.x-0.5) * 512/2;
        pos.y = (corner.y-0.5) * 512/2;

        if     ((gl_VertexID % 4 == 0 || gl_VertexID % 4 == 1) && vertex_compare(Position.x,ScreenSize.x,uiScale,-176,77,margin)) pos.x += 77;
        else if((gl_VertexID % 4 == 2 || gl_VertexID % 4 == 3) && vertex_compare(Position.x,ScreenSize.x,uiScale,-176,253,margin)) pos.x += 77;

        gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
        gl_Position.xy += vec2(1,-1);
    }

    if (ivec4(round(color*255)) == ivec4(1,1,1,3)) {// ========= BREWING STAND

        vec2 corner = corners[gl_VertexID % 4];
        texCoord0.x = corner.x*0.6875;
        texCoord0.y = corner.y*0.6875;


        pos.x = (corner.x-0.5) * 352 -40;
        pos.y = (corner.y-0.5) * 352 +48;

        gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
        gl_Position.xy += vec2(1,-1);
    }
    if (ivec4(round(color*255)) == ivec4(1,1,1,4)) {// ========= CHESTS

        if(((gl_VertexID % 4 == 0 || gl_VertexID % 4 == 3)&&  Position.y == round((ScreenSize.y/uiScale-222)/2) )||((gl_VertexID % 4 == 1 || gl_VertexID % 4 == 2)&&  Position.y == round((ScreenSize.y/uiScale-222)/2 +125))){
            pos.xy = vec2(0,0);
        }else{

        vec2 corner = corners[gl_VertexID % 4];
        texCoord0.x = corner.x/2;
        texCoord0.y = corner.y/2;

        pos.x = (corner.x-0.5) * 512/2;
        pos.y = (corner.y-0.5) * 512/2;

        if ((gl_VertexID % 4 == 0 || gl_VertexID % 4 == 3) && Position.y == round(ScreenSize.y/uiScale/2)+14) {

            texCoord0.y += 0.5;
            pos.y += 27;

        }
        if ((gl_VertexID % 4 == 1 || gl_VertexID % 4 == 2) && Position.y == round(ScreenSize.y/uiScale/2)+110){

            texCoord0.y += 0.5;
            pos.y += 27;
        }


        }

        gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
        gl_Position.xy += vec2(1,-1);
    }

     if (ivec4(round(color*255)) == ivec4(1,1,1,5)) {// ========= VILLAGER

        vec2 corner = corners[gl_VertexID % 4];
        texCoord0.x = corner.x*0.6875;
        texCoord0.y = corner.y*0.6875;


        pos.x = (corner.x-0.5) * 352 +1;
        pos.y = (corner.y-0.5) * 352 +48;

        gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
        gl_Position.xy += vec2(1,-1);
    }

    // ========= VILLAGER EXPERIENCE
    if (
        ((gl_VertexID % 4 == 0 || gl_VertexID % 4 == 3) && pos.y == (round(ScreenSize.y/uiScale/2)-67)  ) ||
        ((gl_VertexID % 4 == 1 || gl_VertexID % 4 == 2) && pos.y == (round(ScreenSize.y/uiScale/2)-67)+5) 
       ) {

        if (pos.x >=  round((ScreenSize.x/uiScale/2-2))-1 && pos.x <= round((ScreenSize.x/uiScale/2-2)) +102 && round(drawnColor.w*255) == 254)
        {
            pos.y -= 30;
            gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
        }
    }

    /*if(pos.z == 310){// ======================= HOTBAR

        if(( gl_VertexID % 4 == 0 || gl_VertexID % 4 == 1 ) && pos.x == (ScreenSize.x/uiScale-182)/2 ) hotbar = true;
        if(( gl_VertexID % 4 == 2 || gl_VertexID % 4 == 3 ) && pos.x == (ScreenSize.x/uiScale-182)/2 + 182) hotbar = true;
        
    }

    if( pos.z == 310 && hotbar){

        vec2 corner = corners[gl_VertexID % 4];

        pos.x -= ScreenSize.x/4/uiScale;
        pos.y -= ScreenSize.y/2/uiScale;

        gl_Position = ProjMat * ModelViewMat * vec4(pos.x*2,pos.y*2,pos.z, 1.0);

    }*/

   

    /*if((gl_VertexID % 4 == 0 && pos.y == 87 && pos.x == 284) //===================== VIllager frown
    
    || (gl_VertexID % 4 == 1 && pos.y == 108 && pos.x == 284)
    || (gl_VertexID % 4 == 2 && pos.y == 108 && pos.x == 312)
    || (gl_VertexID % 4 == 3 && pos.y == 87 && pos.x == 312) ){
        
        pos.y -= 30;
        pos.x -= 8;
        gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
    }*/

    vertexColor = Color;
    
}

