public void submit(){
  //print what we get
  println("******success submit!!******");
  println("usernumber: "+ usernumber);
  println("user interest: " + likely);
  println("pic: "+ picId+".jpg");
  truevalue = graphic_data.getString(picId-1, "truevalue");
  println("true value: "+ truevalue);
  println("userchoice: " + act );
  judge();
  clicks ++;
  //upload to IoT
  logIoTData(usernumber,likely,picId,truevalue,act);
  //to Enitity
  updateUserProfile(ctime);
 
  
  //new picture
  if (picId <5){
  picId = picId +1;
  }else{
  picId = 1;
  }
 
  localImg = loadImage(str(picId)+".jpg"); 
}

void logIoTData(int usernumber,int likely, int picId, String truevalue,String act) {
  // set resource id (refId of device in the project)
  iotDS.device(str(usernumber));
  // add data, then send off the log
  iotDS.data("usernumber",usernumber).data("likely",likely).data("picId",picId).data("truevalue",truevalue).data("user chose",act).log();
}

void updateUserProfile(long ctime) {
  // set item
  entityDS.id(str(usernumber)).token(str(usernumber));
  // add data to send (=update)
  entityDS.data("likely",likely).data("picId",picId).data("plays", clicks).data("correct",correct).data("incorrect",incorrect).update();
}

void fetchData(){
  // set item
  entityDS.id(str(usernumber)).token(str(usernumber));
  //  Map<String, Object> result = entityDS.get();
  Map Data = entityDS.get();
  
  fetch_likely = Integer.parseInt(checkProfileItem(Data.get("likely"), "0"));
  if (fetch_likely == 0){
    fetch_likely = likely;
    likeslider.show(); 
    }else{
  likely = fetch_likely;
  likeslider.hide(); 
  }
  
  fetch_correct = Integer.parseInt(checkProfileItem(Data.get("correct"), "0"));
  correct = fetch_correct;
  
  fetch_incorrect = Integer.parseInt(checkProfileItem(Data.get("incorrect"), "0"));
  incorrect = fetch_incorrect;
  
  fetch_picId = Integer.parseInt(checkProfileItem(Data.get("picId"), "0"));
  picId=fetch_picId;

  
}

String checkProfileItem(Object profileItem, String defaultValue) {
  return profileItem != null && ((String) profileItem).length() != 0 ? (String) profileItem : defaultValue;
}
