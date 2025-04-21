#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;
uniform float GameTime;

out vec2 texCoord0;
out vec4 vertexColor;

// CREDIT - @STITCH.SPRITES

// -=-=-=-=-=-=-=-=-=-=- CUSTOMIZATION -=-=-=-=-=-=-=-=-=-=-    
//[CONTAINER ANIMATIONS]: SPEED, SHEET_FRAMES, TOTAL_FRAMES

    const ivec3 ANIMATION_params[3] = ivec3[](
        ivec3(    0, 1,  1),      // (Default)
        ivec3(15000, 2,  3),    // STONECUTTER
        ivec3(10000, 2, 14)        // VILLAGER
    );    
    const int Stonecutter[3] = int[](0, 0, 1);
    const int Villager[14] = int[](0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0);
    
//[SPRITE METERS]: WIDTH, SHEET_FRAMES [EXPERIMENTAL]

    const float atlas_gui_width = 1.0 / 2048;
    const vec2 METER_params[3] = vec2[](
        vec2( 0,  1),    // (Default)
        vec2(14, 13),    // SMELTING FUEL
        vec2(24, 24)    // SMELTING ARROW
    );
    
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

vec2[] corners = vec2[](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));

void main() {
    texCoord0 = UV0;
    vec3 pos = Position;
    
    int vertIndex = gl_VertexID % 4;
    ivec4 ctrlL = ivec4(texture(Sampler0, vec2(0)) * 255.0 + 0.5);
    
    switch (ctrlL.a) {
    case 2: //CONTAINERS
        texCoord0 = corners[vertIndex];
                
        vec2 screenScale = ScreenSize / (ScreenSize.x * ProjMat[0][0] * 0.5);
        pos.xy += (corners[vertIndex] - 0.5) * ctrlL.rg * 2;
        
        if (UV0.x == 0.0 || UV0.x == 0.6875) {
            if (UV0.y == 0.27734375 || UV0.y == 0.48828125) { 
                if (vertIndex == 2) pos.xy = vec2(0, 0);
            } else if (UV0.y == 0.4921875 || UV0.y == 0.8671875) {
                if (vertIndex == 0 || vertIndex == 3) pos.y -= 125;
                float size = Position.y - round(screenScale.y * 0.5);
                int rows = 0;
                if (size == -24 || size ==  72) rows = 1;
                if (size == -13 || size ==  83) rows = 2;
                if (size ==  -4 || size ==  92) rows = 3;
                if (size ==   5 || size == 101) rows = 4;
                if (size ==  14 || size == 110) rows = 5;
                texCoord0 = vec2((corners[vertIndex].x + rows) / 6, corners[vertIndex].y);
            }
        }
        
        // -=-=-=-=-=- CONTAINER ANIMATIONS -=-=-=-=-=-
        ivec3 animParams = ANIMATION_params[ctrlL.b]; 
        int frameIndex = int(GameTime * animParams[0]) % animParams[2];
        
        switch (ctrlL.b) {
            case 1: frameIndex = Stonecutter[frameIndex]; break;
            case 2: frameIndex = Villager[frameIndex]; break;
        }
        
        texCoord0.y = (frameIndex + texCoord0.y) / animParams[1];        
        break;
    default: //case 1: SPRITES 
        vec2 elementUV = UV0;
        if (vertIndex == 3 || vertIndex == 2) elementUV.x -= 0.0000001;
        if (vertIndex == 1 || vertIndex == 2) elementUV.y -= 0.0000001;
        ivec4 ctrlV = ivec4(texture(Sampler0, elementUV) * 255.0 + 0.5);
        
        if (ctrlV.a == 1) {
            pos.xy += vec2(ctrlV.r - 128, 128 - ctrlV.g);
            
            // -=-=-=-=-=- SPRITE METERS -=-=-=-=-=-
            vec2 meterParams = METER_params[ctrlV.b];
            int state = 1;
            if (vertIndex < 2) texCoord0.x += atlas_gui_width * (meterParams[0] * (state - 1));
            if (vertIndex > 1) texCoord0.x -= atlas_gui_width * (meterParams[0] * (meterParams[1] - state));
        }
    }

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
    vertexColor = Color;
}