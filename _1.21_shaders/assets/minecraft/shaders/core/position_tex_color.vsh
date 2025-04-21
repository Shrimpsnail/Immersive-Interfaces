#version 150


//#moj_import <minecraft:interfaces.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;
uniform float GameTime;

out vec2 texCoord0;
out vec4 vertexColor;// 1.21

vec2[] corners = vec2[](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));

bool hotbar = false;
float margin = 1;

bool vertex_compare(float position,float ScreenSize,float uiScale,float offset,float size,float margin) 
{
    return ( abs( (round(ScreenSize/uiScale/2)+offset+size) - position )<= margin );
}

bool positionCheck(vec2 position,vec2 ScreenSize,float uiScale,int vertID ,vec2 offset,vec2 size,float margin)// full check 
{
        if(vertID == 0) return greaterThan( abs( (round(ScreenSize/uiScale/2)+offset               ) - position ),vec2(margin) );
        if(vertID == 1) return greaterThan( abs( (round(ScreenSize/uiScale/2)+offset+vec2(0,size.y)) - position ),vec2(margin) );
        if(vertID == 2) return greaterThan( abs( (round(ScreenSize/uiScale/2)+offset+size          ) - position ),vec2(margin) );
        if(vertID == 3) return greaterThan( abs( (round(ScreenSize/uiScale/2)+offset+vec2(size.x,0)) - position ),vec2(margin) );
}


void main() {

    //====== Normal shader
    texCoord0 = UV0;
    vertexColor = Color; // 1.21
    //====================
    
    vec3 pos = Position;

    int vertID = gl_VertexID % 4;

    vec2 corner = corners[vertID];
    vec4 color = round(texture(Sampler0, texCoord0-(0.00001*corner))*255);

    float uiScale = ScreenSize.x * ProjMat[0][0] * 0.5;
    //ivec2 halfScreen = ivec2(0.49+(ScreenSize/uiScale/2));

    if(color.a == 1){ //Custom GUIS

        //================== SIZE ========================================

        if(color.r == 1){ //base 256 - one quarter

            //pos.xy = halfScreen + (corner-0.5)*256; //old
            pos.xy += ((corner-0.5)*2*vec2(40,45));
            texCoord0 = corner/2;
        }
        if(color.r == 2){ //base 256 - shulker offset

            if (vertID == 0 || vertID == 3)    pos.xy += ((corner-0.5)*2*vec2(40,45));
            if (vertID == 1 || vertID == 2)    pos.xy += ((corner-0.5)*2*vec2(40,44));
            texCoord0 = corner/2;
        }
        if(color.r == 3){ //base 320 - normal size

            pos.xy += ((corner-0.5)*2*vec2(72,77));
            texCoord0 = corner*(320.0/512.0);
        }
        if(color.r == 4){ //base 256 - hopper offset
        
            if (vertID == 0 || vertID == 3)    pos.xy += ((corner-0.5)*2*vec2(40,61));
            if (vertID == 1 || vertID == 2)    pos.xy += ((corner-0.5)*2*vec2(40,62));
            texCoord0 = corner/2;
        }
        if(color.r == 5){ //base 320 - Villager

            pos.xy += ((corner-0.5)*2*vec2(22,77));
            texCoord0 = corner*(320.0/512.0);
        }
        if(color.r == 6){// Chests

            if (vertID == 0 || vertID == 3)    pos.xy += ((corner-0.5)*2*vec2(40,115));
            if (vertID == 1 || vertID == 2)    pos.xy += ((corner-0.5)*2*vec2(40,45));

            texCoord0 = corner;
            texCoord0.x /= 6.0;

            
            int rows= 0;

            if((vertID == 0 || vertID == 3) &&(vertex_compare(Position.y,ScreenSize.y,uiScale,-31,0 ,margin))) rows=0;
            if((vertID == 1 || vertID == 2) &&(vertex_compare(Position.y,ScreenSize.y,uiScale,-31,96 ,margin))) rows=0;
            
            if((vertID == 0 || vertID == 3) &&(vertex_compare(Position.y,ScreenSize.y,uiScale,-22,0 ,margin))) rows=1;
            if((vertID == 1 || vertID == 2) &&(vertex_compare(Position.y,ScreenSize.y,uiScale,-22,96 ,margin))) rows=1;

            if((vertID == 0 || vertID == 3) &&(vertex_compare(Position.y,ScreenSize.y,uiScale,-13,0 ,margin))) rows=2;
            if((vertID == 1 || vertID == 2) &&(vertex_compare(Position.y,ScreenSize.y,uiScale,-13,96 ,margin))) rows=2;

            if((vertID == 0 || vertID == 3) &&(vertex_compare(Position.y,ScreenSize.y,uiScale, -4,0 ,margin))) rows=3;
            if((vertID == 1 || vertID == 2) &&(vertex_compare(Position.y,ScreenSize.y,uiScale, -4,96 ,margin))) rows=3;

            if((vertID == 0 || vertID == 3) &&(vertex_compare(Position.y,ScreenSize.y,uiScale, 5,0 ,margin))) rows=4;
            if((vertID == 1 || vertID == 2) &&(vertex_compare(Position.y,ScreenSize.y,uiScale, 5,96 ,margin))) rows=4;

            if((vertID == 0 || vertID == 3) &&(vertex_compare(Position.y,ScreenSize.y,uiScale,14,0 ,margin))) rows=5;
            if((vertID == 1 || vertID == 2) &&(vertex_compare(Position.y,ScreenSize.y,uiScale,14,96 ,margin))) rows=5;

            //rows= int((((Position.y-509)/uiScale)+(96*corner.y))/9.0);

            texCoord0.x += rows/6.0;


        }
        if(color.r == 7){ //base 320 - Beacon

            if (vertID == 0 || vertID == 3)    pos.xy += ((corner-0.5)*2*vec2(45,50));
            if (vertID == 1 || vertID == 2)    pos.xy += ((corner-0.5)*2*vec2(45,51));
            texCoord0 = corner*(320.0/512.0);

            switch(vertID){
                case 0:pos.z += 400;break;
                case 1:pos.z +=  90;break;
                case 2:pos.z +=  90;break;
                case 3:pos.z += 280;break;
            }
            
        }
        if(color.r == 8){ //base 320 - Creative
            
            if (vertID == 0 || vertID == 1)    pos.xy += ((corner-0.5)*2*vec2(62,92));
            if (vertID == 2 || vertID == 3)    pos.xy += ((corner-0.5)*2*vec2(63,92));
            texCoord0 = corner*(320.0/512.0);
        }   
        //================== OFFSETS ============================
        
        //                       default    brewing stand    villager     beacon
        vec2[] offsets = vec2[]( vec2(0,0) , vec2(-56,32) , vec2(1,48), vec2(1,25) );

        pos.xy += offsets[int(color.g)];


        //================== FUNCTIONALITY ============================


        if(color.b == 2){//remove

            pos.xy = vec2(0);
        }
        if(color.b == 4){// Stonecutter Animations 

            float animation_speed = 4;
            float frames = 3;

            texCoord0 = corner*(320.0/512.0)/2;

                 if(mod((GameTime*24000),animation_speed) <   animation_speed/frames) texCoord0.x += 0;
            else if(mod((GameTime*24000),animation_speed) < 2*animation_speed/frames) texCoord0.x += (320.0/512.0)/2;
            else if(mod((GameTime*24000),animation_speed) <   animation_speed       ) texCoord0.y += (320.0/512.0)/2;
        }


    }

    if(color.a == 2){ //Custom SPRITES

        if(color.b == 1){

            if (vertID == 2 || vertID == 3)
            {
                texCoord0.x -= 18.0/256.0;
            }

            if((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-60,0 ,margin))) pos = vec3(0,0,0);
            if((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-60,18,margin))) pos = vec3(0,0,0);

            if((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-48,0 ,margin))) pos = vec3(0,0,0);
            if((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-48,18,margin))) pos = vec3(0,0,0);

            if((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-36,0 ,margin))) pos = vec3(0,0,0);
            if((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-36,18,margin))) pos = vec3(0,0,0);

            if((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,31,0 ,margin))) pos = vec3(0,0,0);
            if((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,31,18,margin))) pos = vec3(0,0,0);

            if((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,55,0 ,margin))) texCoord0.x += 18.0/256.0;
            if((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,55,18,margin))) texCoord0.x += 18.0/256.0;

            pos.z += 400;

        }

        if(color.b == 2){

            pos.z += 400;
            pos.xy += ((corner-0.5)*2*3);
            texCoord0 -= corner*(56.0/textureSize(Sampler0,0));

            
           //bool positionCheck(vec2 position,vec2 ScreenSize,float uiScale,int vertID ,vec2 offset,vec2 size,float margin)// full check 

            /* if(positionCheck(Position,ScreenSize,uiScale,vertID,vec2(-38,-88),vec2(22,22),margin)) texCoord0 += (vec2(28.0, 0.0)/textureSize(Sampler0,0));
            if(positionCheck(Position,ScreenSize,uiScale,vertID,vec2(-62,-63),vec2(22,22),margin)) texCoord0 += (vec2( 0.0,28.0)/textureSize(Sampler0,0));
            if(positionCheck(Position,ScreenSize,uiScale,vertID,vec2(-38,-63),vec2(22,22),margin)) texCoord0 += (vec2(28.0,28.0)/textureSize(Sampler0,0));
            if(positionCheck(Position,ScreenSize,uiScale,vertID,vec2(-50,-38),vec2(22,22),margin)) texCoord0 += (vec2( 0.0,56.0)/textureSize(Sampler0,0));
            if(positionCheck(Position,ScreenSize,uiScale,vertID,vec2( 29,-63),vec2(22,22),margin)) texCoord0 += (vec2(56.0, 0.0)/textureSize(Sampler0,0));
            if(positionCheck(Position,ScreenSize,uiScale,vertID,vec2( 53,-63),vec2(22,22),margin)) texCoord0 += (vec2(56.0,28.0)/textureSize(Sampler0,0)); */

            if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-38,0 ,margin))) ||
               ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-38,22,margin)))) {

            if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-88,0 ,margin))) ||
               ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-88,22,margin)))) {

                    texCoord0 += (vec2(28.0,0.0)/textureSize(Sampler0,0));
            }}

            if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-62,0 ,margin))) ||
               ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-62,22,margin)))) {

            if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-63,0 ,margin))) ||
               ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-63,22,margin)))) {

                    texCoord0 += (vec2(0.0,28.0)/textureSize(Sampler0,0));
            }}

            if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-38,0 ,margin))) ||
               ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-38,22,margin)))) {

            if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-63,0 ,margin))) ||
               ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-63,22,margin)))) {

                    texCoord0 += (vec2(28.0,28.0)/textureSize(Sampler0,0));
            }}

            if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-50,0 ,margin))) ||
               ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,-50,22,margin)))) {

            if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-38,0 ,margin))) ||
               ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-38,22,margin)))) {

                    texCoord0 += (vec2(0.0,56.0)/textureSize(Sampler0,0));
            }}

            if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,29,0 ,10))) ||
               ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,29,22,10)))) {

            if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-63,0 ,margin))) ||
               ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-63,22,margin)))) {

                    texCoord0 += (vec2(56.0,0.0)/textureSize(Sampler0,0));
            }}

            if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,53,0 ,10))) ||
               ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,53,22,10)))) {

            if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-63,0 ,margin))) ||
               ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-63,22,margin)))) {

                    texCoord0 += (vec2(56.0,28.0)/textureSize(Sampler0,0));
            }}

            if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,49,0 ,10))) ||
               ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,49,22,10)))) {

            if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-3,0 ,margin))) ||
               ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-3,22,margin)))) {

                    texCoord0 += (vec2(28.0,56.0)/textureSize(Sampler0,0));
            }}

            if(((vertID == 0 || vertID == 1) && (vertex_compare(Position.x,ScreenSize.x,uiScale,75,0 ,10))) ||
               ((vertID == 2 || vertID == 3) && (vertex_compare(Position.x,ScreenSize.x,uiScale,75,22,10)))) {

            if(((vertID == 0 || vertID == 3) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-3,0 ,margin))) ||
               ((vertID == 1 || vertID == 2) && (vertex_compare(Position.y,ScreenSize.y,uiScale,-3,22,margin)))) {

                    pos.xy = vec2(0,0);
            }}
        }
    }

    // ========= VILLAGER EXPERIENCE
    if (
        ( (vertID == 0 || vertID == 3)    && pos.y == (round(ScreenSize.y/uiScale/2)-67)  ) ||
        ( (gl_VertexID % 1 == 0 || vertID == 2)    && pos.y == (round(ScreenSize.y/uiScale/2)-67)+5) 
       ) {

        if (pos.x >= round((ScreenSize.x/uiScale/2-2))-1   &&
            pos.x <= round((ScreenSize.x/uiScale/2-2))+102 &&
            round(color.a) == 254)
        {
            pos.y -= 30;
        }
    }
    
    
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);



    /*if(pos.z == 310){// ======================= HOTBAR CHECK

        if(( vertID == 0 || vertID == 1 ) && pos.x == (ScreenSize.x/uiScale-182)/2 )      hotbar = true;
        if(( vertID == 2 || vertID == 3 ) && pos.x == (ScreenSize.x/uiScale-182)/2 + 182) hotbar = true;
        
    }

    if( pos.z == 310 && hotbar){

        vec2 corner = corners[vertID];

        pos.x -= ScreenSize.x/4/uiScale;
        pos.y -= ScreenSize.y/2/uiScale;

    }*/

   

    /*if((vertID == 0 && pos.xy == vec2(87, 284)) //===================== VIllager frown
    ||   (vertID == 1 && pos.xy == vec2(108,284)
    ||   (vertID == 2 && pos.xy == vec2(108,312)
    ||   (vertID == 3 && pos.xy == vec2(87, 312) ){
        
        pos.xy += vec2(-8,-30);
    }*/
}

