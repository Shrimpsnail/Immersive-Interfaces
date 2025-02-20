#version 150

bool vertex_compare(float position,float ScreenSize,float uiScale,float offset,float size,float margin) {

    if(offset < 0){

        if( abs( (round((ScreenSize/uiScale+offset)/2) + size) - position )<= margin ){

            return true;
        }else{

            return false;
        }
    }else{

        if( abs( (round(ScreenSize/uiScale/2)+offset+size) - position )<= margin ){
            return true;
        }else{

            return false;
        }
    }
}
