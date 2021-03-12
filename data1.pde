import controlP5.*;
import java.util.*;
import nl.tue.id.datafoundry.*;  //datafoundry

// Settings for DataFoundry library
// (CHANGE API TOKENS AND IDS YOURSELF!)
//
String host = "data.id.tue.nl";
String iot_api_token = "W3uh6k6twx0ob36cZxQ8TWkRXCc7KOQDt7MLPTIBKhM6eF1s+4AY12+hRbnCAwPX";
String entity_api_token = "if6MtSZG45E15v+t2JfnR3eSPsRA3hLfALLFXx94S7WF0SrH6d92nvT7lWJtM6pZ";
long iot_id = 954;
long entity_id = 955;

int clicks;
int fetch_likely=4;
int fetch_picId;
int fetch_correct;
int fetch_incorrect;
long ctime = millis();
// data foundry connection
DataFoundry df = new DataFoundry(host);
// access to two datasets: iotDS and entityDS
DFDataset iotDS = df.dataset(iot_id, iot_api_token);
DFDataset entityDS = df.dataset(entity_id, entity_api_token);


ControlP5 cp5;

PImage localImg;
Table graphic_data;
String url, truevalue;
String act;
//PicId=totall picsum-1
int picId=4;
int usernumber, likely=4;
int correct, incorrect;
Button option1, option2;
DropdownList userlist;
Slider likeslider;

void setup() {
  frameRate(20);
  size(375,700);
  noStroke();
  cp5 = new ControlP5(this);
 
  graphic_data = loadTable("graphic_data.csv","header");
  
  /*
  url = graphic_data.getString(row,"imgurl");
  webImg = loadImage(url, "jpg");
  */
 
  localImg = loadImage(str(picId)+".jpg");
  
option1=cp5.addButton("cat")
     .setValue(0)
     .setPosition(80,500)
     .setSize(100,100)
     .setColorActive(#ffffff) 
     .setColorForeground(0) 
     ;
     
option2=cp5.addButton("dog")
      .setValue(0)
     .setPosition(236,500)
     .setSize(100,100)
     .setColorActive(#ffffff) 
     .setColorForeground(0) 
     ;

likeslider=cp5.addSlider("likely")
    .setRange(1, 7)
    .setValue(4)
    .setPosition(80, 80)
    .setSize(200, 16)
    .setNumberOfTickMarks(7);
   
     // cp5.getController("likely").getCaptionLabel().hide();


userlist = cp5.addDropdownList("list_user")
          .setPosition(80, 50)
          .setSize(200,200)
          .close() 
          ;
customize(userlist);        

}



void draw() {
  
  background(0);
 
    // check every 5 seconds
  
  image(localImg,80,200);
  text("hello",80,20);  
  //
  text("likely: "+ fetch_likely+" / correct: "+fetch_correct+" / incorrect: "+fetch_incorrect,80,30); 
  text("your fetch likey is "+ fetch_likely,80,94);
  
  if (millis() > 300 && frameCount % 30 == 0) {
      fetchData();
    }
}


void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(15);
  ddl.getCaptionLabel().set("choose your usernumber");
  for (int i=1;i<21;i++) {
    ddl.addItem("user "+i, i);
  }
  //ddl.scroll(0);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}
/*
void controlEvent(ControlEvent theEvent) {

  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    usernumber = theEvent.getGroup().getValue()+1;
    println(usernumber+" from theEvent.getGroup()");
  } 
  else if (theEvent.isController()) {
    usernumber = theEvent.getController().getValue()+1;
    println(usernumber+" from theEvent.getController()");
  }
}
*/

void list_user(int n) {
  usernumber = n + 1;
}



public void cat(){
  if(usernumber ==0){}else{
  act = "cat";
  submit();
  }
}

public void dog(){
  if(usernumber ==0){}else{
  act = "dog";
  submit();
  }
}
void judge(){
/*
 if( act.equals("cat") == true ){
 if(truevalue.equals("cat")){
    correct++;
    println("correct");}}  else if(act.equals("dog")==true){
  if(truevalue.equals("dog")){
     correct++;
     println("correct");}
   }else{ 
   println("incorrect");
 } 
 */

if( act.equals("cat") == true ){
 if(truevalue.equals("cat")){
    correct++;
    println("correct");}else{
      incorrect++;
    println("incorrect");}} else{
    if(truevalue.equals("dog")){
     correct++;
     println("correct");}else{
     incorrect++;
   println("incorrect");}
    }
}
