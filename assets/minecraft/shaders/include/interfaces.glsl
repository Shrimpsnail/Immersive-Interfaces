#version 330

#extension GL_ARB_shader_draw_parameters : enable
#extension SPV_KHR_shader_draw_parameters : enable

//#moj_import <fog.glsl>
//#moj_import <dynamictransforms.glsl>
//#moj_import <globals.glsl>
//#moj_import <projection.glsl>

struct Data 
{
   vec3 position;
   vec2 uv0;
   vec4 color;
};


vec2[] corners = vec2[](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
float margin = 0;

Data null = Data(vec3(0),vec2(0),vec4(0));



bool posCheckX(vec3 position,vec2 screen, float offset,float size) {
    return ( abs( (round(screen.x/2)+offset+(size*corners[gl_VertexID % 4].x)) - position.x )<= margin );
}
bool posChecky(vec3 position,vec2 screen, float offset,float size) {
    return ( abs( (round(screen.y/2)+offset+(size*corners[gl_VertexID % 4].y)) - position.y )<= margin );
}
bool posCheck(vec3 position,vec2 screen, vec2 offset,vec2 size) {
    return ( abs( (round(screen.x/2)+offset.x+(size.x*corners[gl_VertexID % 4].x)) - position.x )<= margin )&&
           ( abs( (round(screen.y/2)+offset.y+(size.y*corners[gl_VertexID % 4].y)) - position.y )<= margin );
}
bool posCheck(vec3 position,vec2 screen, vec2 offset,float size) {
    return posCheck(position,screen, offset,vec2(size));
}





Data interfaces(mat4 ProjMat, float GameTime, sampler2D Sampler0, vec3 Position, vec2 texCoord0) {


    vec3 pos = Position;
    int vertID = (gl_VertexID - gl_BaseVertexARB) % 4;

    vec2 corner = corners[vertID];
    vec4 color = round(texture(Sampler0, texCoord0-(0.00001*corner))*255);

    //ivec2 halfScreen = ivec2(0.49+(ScreenSize/uiScale/2));
    vec2 screen = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);

    if(color.a == 255) return Data(Position,texCoord0,vec4(0));


    if(color == vec4(0)){//affects items and entities and ends checks 
        
        if(  (posCheck(Position,screen,vec2( 49, 71),16))  ||
              (posCheck(Position,screen,vec2( 76, 71),16))  || 
              (posCheck(Position,screen,vec2( 49, -87),16)) || 
              (posCheck(Position,screen,vec2( 76, -87),16)) ) pos.z -= 10;

        
        if(posCheck(Position,screen,vec2( -62, -65),52)) pos.xy +=  5*corner - vec2(0,3);

        return Data(pos,texCoord0,vec4(0));

    }



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

                 if(posChecky(Position,screen,-31,96)) rows=0;
            else if(posChecky(Position,screen,-22,96)) rows=1;
            else if(posChecky(Position,screen,-13,96)) rows=2;
            else if(posChecky(Position,screen, -4,96)) rows=3;
            else if(posChecky(Position,screen,  5,96)) rows=4;
            else if(posChecky(Position,screen, 14,96)) rows=5;

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
        
        //                       default    brewing stand    villager     beacon    creative
        vec2[] offsets = vec2[]( vec2(0,0) , vec2(-56,32) , vec2(1,48), vec2(1,25), vec2(0,0) );

        pos.xy += offsets[int(color.g)];


        //================== FUNCTIONALITY ============================


        if(color.b == 2) return null;


        if(color.b == 4){// Stonecutter Animations 

            float animation_speed = 4;
            float frames = 3;

            texCoord0 = corner*(320.0/512.0)/2;

                 if(mod((GameTime*24000),animation_speed) <   animation_speed/frames) texCoord0.x += 0;
            else if(mod((GameTime*24000),animation_speed) < 2*animation_speed/frames) texCoord0.x += (320.0/512.0)/2;
            else if(mod((GameTime*24000),animation_speed) <   animation_speed       ) texCoord0.y += (320.0/512.0)/2;
        }

        return Data(pos,texCoord0,vec4(0));
    }

    //≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡
    //≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡

    if(color.a == 2){ //Custom SPRITES

        if(color.g == 1){ // BEACON 

            if(color.b == 1){// Beacon icons

                texCoord0.x -= (18.0/textureSize(Sampler0,0).x)*corner.x;

                if((posCheckX(Position,screen,-60,18)) ||
                   (posCheckX(Position,screen,-48,18)) ||
                   (posCheckX(Position,screen,-36,18)) || 
                   (posCheckX(Position,screen, 31,18))) return null;;
                if (posCheckX(Position,screen,55,18)) {
                    texCoord0.x += 18.0/textureSize(Sampler0,0).x;
                }
            }

            if(color.b == 2){ // Beacon buttons

                pos.xy += ((corner-0.5)*2*3);
                
                texCoord0 -= corner*(56.0/textureSize(Sampler0,0));      // speed (default)

                 if(posCheck(Position,screen,vec2(-38,-88),22)) texCoord0 += vec2(28, 0)/textureSize(Sampler0,0); // haste
            else if(posCheck(Position,screen,vec2(-62,-63),22)) texCoord0 += vec2( 0,28)/textureSize(Sampler0,0); // resistance
            else if(posCheck(Position,screen,vec2(-38,-63),22)) texCoord0 += vec2(28,28)/textureSize(Sampler0,0); // jump boost
            else if(posCheck(Position,screen,vec2(-50,-38),22)) texCoord0 += vec2( 0,56)/textureSize(Sampler0,0); // strength
            else if(posCheck(Position,screen,vec2( 29,-63),22)) texCoord0 += vec2(56, 0)/textureSize(Sampler0,0); // regen
            else if(posCheck(Position,screen,vec2( 49, -3),22)) texCoord0 += vec2(28,56)/textureSize(Sampler0,0); // tier 2
            else if(posCheck(Position,screen,vec2( 53,-63),22)) texCoord0 += vec2(56,28)/textureSize(Sampler0,0); // beacon on
            else if(posCheck(Position,screen,vec2( 75, -3),22)) return null;                                    // cross button

            }

            if(color.b == 3){ // Beacon buttons [1.20.1]

                pos.xy += ((corner-0.5)*2*3);

                texCoord0 = vec2(  ((84*corner.x)+428)/512  ,     ((color.r*84)+(84*corner.y))/512    );
                
                texCoord0 -= corner*(56.0/textureSize(Sampler0,0));      // speed (default)

                 if(posCheck(Position,screen,vec2(-38,-88),22)) texCoord0 += vec2(28, 0)/512; // haste
            else if(posCheck(Position,screen,vec2(-62,-63),22)) texCoord0 += vec2( 0,28)/512; // resistance
            else if(posCheck(Position,screen,vec2(-38,-63),22)) texCoord0 += vec2(28,28)/512; // jump boost
            else if(posCheck(Position,screen,vec2(-50,-38),22)) texCoord0 += vec2( 0,56)/512; // strength
            else if(posCheck(Position,screen,vec2( 29,-63),22)) texCoord0 += vec2(56, 0)/512; // regen
            else if(posCheck(Position,screen,vec2( 49, -3),22)) texCoord0 += vec2(28,56)/512; // tier 2
            else if(posCheck(Position,screen,vec2( 53,-63),22)) texCoord0 += vec2(56,28)/512; // beacon on
            else if(posCheck(Position,screen,vec2( 75, -3),22)) return null;                  // cross button

            }
        }

        if(color.g == 2){// VILLAGER

            if(color.b == 1) pos.y -= 30;
        }

        if(color.g == 3){//RECIPE BOOK

            if(color.b == 1)texCoord0 = vec2(  ((62*corner.x)+20)/256  ,    (180*corner.y)/256    );
            if(color.b == 2)texCoord0 = vec2(  ((62*corner.x)+82)/256  ,    (180*corner.y)/256    );

            if(posCheckX(Position,screen,93,20)) return null;
            if(posCheckX(Position,screen, 9,20)) return null;
            if(posCheckX(Position,screen,-6,20)) return null;
            else{

                pos.xy += 21*2*(corner-0.5);

                texCoord0.y -= 120.0/textureSize(Sampler0,0).y*corner.y;

                if(posCheck(Position,screen,vec2( -68, -49),vec2(20,18))) texCoord0.y += 60.0/textureSize(Sampler0,0).y;
                if(posCheck(Position,screen,vec2( -83, -49),vec2(20,18))) texCoord0.y += 120.0/textureSize(Sampler0,0).y;

            }

            
        }

        if(color.g == 4){//CREATIVE MENU

            if(color.r == 1) pos.xy += vec2(13,16)*2*(corner-0.5);    
            if(color.b == 1) pos.z += 400;                    // ONLY FOR PRE 1.21.9
            
        }

        if(color.g == 5){//HORSE

            if(color.r == 1){
                pos.xy += (vec2(90,54)*(corner-0.5) ) - 2 + vec2(color.b*18,0); 
                texCoord0 += vec2((color.b*18*2)/textureSize(Sampler0,0).x,0);
            }
            if(color.r == 2){
                            
                texCoord0.x -= (36.0/textureSize(Sampler0,0).x) * corner.x;

                if(posCheck(Position,screen,vec2( -81, -66),18)) texCoord0.x += 18.0/textureSize(Sampler0,0).x;
                if(posCheck(Position,screen,vec2( -81, -48),18)) texCoord0.x += 36.0/textureSize(Sampler0,0).x;
            }

        }

        if(color.g == 6){//ANVIL

            if(color.r == 1) pos.xy += ((corner-0.5)*2*vec2(56,28));


            if(color.r == 2) pos.xy += ((corner-0.5)*2*vec2(44,4));
            if(color.r ==2) pos.x -= 11;

        }

        if(color.g == 7){// HUD

            if(color.r == 1){

                pos.y += 4;
            }  
            if(color.r == 2){

                pos.xy += (corner-vec2(0.5,1))*vec2(182,22);

            }
            if(color.r == 3){

                pos.xy += vec2(1,0)+(corner-vec2(0.5))*vec2(182,48);

            }

        }

        return Data(pos,texCoord0,vec4(0));
    }
    

    if(color.a == 254){//Camouflage

        if(color.xyz == vec3(51,89,155) || color.xyz == vec3(29,56,130) || color.xyz == vec3(93,119,198)){//CREATIVE MENU

            pos.xy += vec2(13,16)*2*(corner-0.5);      
            pos.z += 400;                    // ONLY FOR PRE 1.21.9
        }
        return Data(pos,texCoord0,vec4(0));
    }

    //fallback
    return Data(pos,texCoord0,vec4(0));
}















Data interfaces_text(mat4 ProjMat, float GameTime, sampler2D Sampler0, vec3 Position, vec2 texCoord0,vec4 Color) {
    
    vec3 pos = Position;

    vec4 textColor = Color;

    
    int vertID = (gl_VertexID - gl_BaseVertexARB) % 4;
    vec2 corner = corners[vertID];
    vec4 color = round(texture(Sampler0, texCoord0-(0.001*corner))*255);
    ivec2 halfScreen = ivec2(0.49+((2 / vec2(ProjMat[0][0], -ProjMat[1][1]))/2));

    if(color.a == 0 || color.a== 255) return Data(pos,texCoord0,textColor); 


    if(color.a == 1){//ui containers
        textColor = vec4(1);

        int size[8] = int[](0,184,200,190,176,250,78,200);

        if(color.r != 0) pos.x = halfScreen.x+size[int(color.r)]*(corner.x-0.5);
        //if(color.b == 1) pos.z += 200;


        if(color.g == 1){// Villager

            textColor = vec4(1);

            int  v_frames = 8;
            float  v_frametime = 5 * v_frames;
            int  v_width = 2;
            int  v_height= 4;

            texCoord0 -= vec2(64.0,192.0)/textureSize(Sampler0,0)*corner;
            pos.x += (corner.x-0.5)*32;

                 if(mod((GameTime*24000),v_frametime) <   v_frametime/4) texCoord0.y += 0;
            else if(mod((GameTime*24000),v_frametime) < 2*v_frametime/4) texCoord0.y += 1*64.0/textureSize(Sampler0,0).y;
            else if(mod((GameTime*24000),v_frametime) < 3*v_frametime/4) texCoord0.y += 2*64.0/textureSize(Sampler0,0).y;
            else if(mod((GameTime*24000),v_frametime) < 4*v_frametime/4) texCoord0.y += 3*64.0/textureSize(Sampler0,0).y;

                 if(mod((GameTime*24000),v_frametime/v_height) <   v_frametime/8) texCoord0.x += 0;
            else if(mod((GameTime*24000),v_frametime/v_height) < 2*v_frametime/8) texCoord0.x += 64.0/textureSize(Sampler0,0).x;
        }
    }
    if(color.a == 1 && round(255*Color.r) != 64.0) return null; // Remove if not in UI
    

    if(color.a == 3)  { // Curtains

        if(Color.rgb != vec3(1)) return null;

        if(color.r == 2) pos.z+=300;
    
    }

    if(color.a == 2 && Color.rgba == vec4(1)){//non container uis 

        if(color.r == 1){//command block

            if(color.g == 1 || color.g == 3) pos.x = halfScreen.x+245*(corner.x-1)+1;
            if(color.g == 2 || color.g == 4) pos.x = halfScreen.x+245*(corner.x  )-1;

            if(color.g == 1 || color.g == 2)pos.y = -19+120*corner.y;   
            if(color.g == 3 || color.g == 4)pos.y = -19+118+171*corner.y; 

            if(color.b == 2) pos.x -= 49;
            if(color.b == 3) pos.x -= 48;
            if(color.b == 4) pos.x += 175;
            if(color.b == 5) pos.x -= 93;
        

        }

    }else if (color.a == 2) return null;


    return Data(pos,texCoord0,textColor);


}
