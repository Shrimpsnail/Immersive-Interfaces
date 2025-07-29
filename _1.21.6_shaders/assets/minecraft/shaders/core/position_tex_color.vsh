#version 150


#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform sampler2D Sampler0;


out vec2 texCoord0;
out vec4 vertexColor;// 1.21

vec2[] corners = vec2[](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
vec2 screen = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);
float margin = 1;

bool posCheckX(float offset,float size) {
    return ( abs( (round(screen.x/2)+offset+(size*corners[gl_VertexID % 4].x)) - Position.x )<= margin );
}
bool posChecky(float offset,float size) {
    return ( abs( (round(screen.y/2)+offset+(size*corners[gl_VertexID % 4].y)) - Position.y )<= margin );
}
bool posCheck(vec2 offset,vec2 size) {
    return ( abs( (round(screen.x/2)+offset.x+(size.x*corners[gl_VertexID % 4].x)) - Position.x )<= margin )&&
           ( abs( (round(screen.y/2)+offset.y+(size.y*corners[gl_VertexID % 4].y)) - Position.y )<= margin );
}
bool posCheck(vec2 offset,float size) {
    return posCheck(offset,vec2(size));
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

                 if(posChecky(-31,96)) rows=0;
            else if(posChecky(-22,96)) rows=1;
            else if(posChecky(-13,96)) rows=2;
            else if(posChecky( -4,96)) rows=3;
            else if(posChecky(  5,96)) rows=4;
            else if(posChecky( 14,96)) rows=5;

            texCoord0.x += rows/6.0;
        }
        if(color.r == 7){ //base 320 - Beacon

            if (vertID == 0 || vertID == 3)    pos.xy += ((corner-0.5)*2*vec2(45,50));
            if (vertID == 1 || vertID == 2)    pos.xy += ((corner-0.5)*2*vec2(45,51));
            texCoord0 = corner*(320.0/512.0);
            
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
    //≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
    //≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

    if(color.a == 2){ //Custom SPRITES

        if(color.g == 1){ // BEACON 

            if(color.b == 1){// Beacon icons

                texCoord0.x -= (18.0/textureSize(Sampler0,0).x)*corner.x;

                if((posCheckX(-60,18)) || (posCheckX(-48,18)) || (posCheckX(-36,18)) || (posCheckX( 31,18))) pos = vec3(0,0,0);
                if (posCheckX(55,18)) texCoord0.x += 18.0/textureSize(Sampler0,0).x;
            }

            if(color.b == 2){ // Beacon buttons

                pos.xy += ((corner-0.5)*2*3);
                texCoord0 -= corner*(56.0/textureSize(Sampler0,0));      // speed (default)

                 if(posCheck(vec2(-38,-88),22)) texCoord0 += vec2(28, 0)/textureSize(Sampler0,0); // haste
            else if(posCheck(vec2(-62,-63),22)) texCoord0 += vec2( 0,28)/textureSize(Sampler0,0); // resistance
            else if(posCheck(vec2(-38,-63),22)) texCoord0 += vec2(28,28)/textureSize(Sampler0,0); // jump boost
            else if(posCheck(vec2(-50,-38),22)) texCoord0 += vec2( 0,56)/textureSize(Sampler0,0); // strength
            else if(posCheck(vec2( 29,-63),22)) texCoord0 += vec2(56, 0)/textureSize(Sampler0,0); // regen
            else if(posCheck(vec2( 49, -3),22)) texCoord0 += vec2(28,56)/textureSize(Sampler0,0); // tier 2
            else if(posCheck(vec2( 53,-63),22)) texCoord0 += vec2(56,28)/textureSize(Sampler0,0); // beacon on
            else if(posCheck(vec2( 75, -3),22)) pos.xy = vec2(0,0);                               // cross button
            }
        }

        if(color.g == 2){// VILLAGER

            if(color.b == 1) pos.y -= 30;
        }
    }

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
}