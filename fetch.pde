public void submit(String act) {
  color tempColor = rColor;
  isStart = true;

  // current runtime value (millis after program was started)
  long ctime = millis();

  // set color to black during submission
  rColor = color(0);

  // open the comment below for checking the inputs
  print("\nsubmit! \tuser name:" + uname + "\tactivity: " + act
    + "\tmeasure time: " + (ctime - lastClickTime) 
    + "\tcolor choice: " + act + "\tcolor code: " + hex(tempColor));

  // send data to both datasets
  logIoTData(act, (ctime - lastClickTime), tempColor);
  updateUserProfile(ctime);

  // new random color
  rColor = color(random(40, 220), random(40, 220), random(40, 220));
  lastClickTime = ctime;
}

// to IoT dataset
void logIoTData(String act, long relativeTime, color tempColor) {
  // set resource id (refId of device in the project)
  iotDS.device(uname);
  // set activity for the log
  if(act.equals("start") || act.equals("stop")) {
    iotDS.activity(act);
  } else {
    iotDS.activity("color_classification");
  }
  // add data, then send off the log
  iotDS.data("time", relativeTime).data("choice", act).data("color", hex(tempColor)).log();
}

// to Entity dataset
void updateUserProfile(long ctime) {
  float avgTime = (ctime - startTime) / clicks;
 // print("\naverage time: " + avgTime);
  String freqColor = countColor();
 // print("\npreference color: " + freqColor + "\nDone in " + ctime + "(ms)");

  // select item with id and token combination
  entityDS.id(uname).token(uname);
  // add data to send (=update)
  entityDS.data("average_time", avgTime).data("most_frequent_color", freqColor)
    .data("plays", clicks).update();
}

// get user profile ------------------------------------------------------------------

void fetchData() {
  // set item
  entityDS.id(uname).token(uname);

  // get item
  Map<String, Object> result = entityDS.get();

  // extract and check item "most_frequent_color" from the Map
  String resp_freqColor = checkProfileItem(result.get("most_frequent_color"), "No data");
  
  // same here
  String resp_avgTime = checkProfileItem(result.get("average_time"), "0");
  String resp_plays = checkProfileItem(result.get("plays"), "0");

  System.out.print("\naverage time (ms):" + resp_avgTime
    + ", most frequently shown color:" + resp_freqColor
    + ", play:" + resp_plays + " times.");

  bgColor = text2Color(resp_freqColor);
  
  //fetch data from data foundry and parse strings to integers where needed
//calculate the relative speed of the user over all of their inputs
  Map Data = entityDS.get();
  int t_entries = Integer.parseInt(checkProfileItem(Data.get("plays"), "0"));
  float db_speed = Float.parseFloat(checkProfileItem(Data.get("relative speed"), "0"));
  c_clicks = t_entries;
  c_clicks++;
  float ptime = Float.parseFloat(preftime);
  float atime = Float.parseFloat(acttime);
  float local_speed = ptime / atime;
  c_speed = (((t_entries * db_speed) + local_speed) / (t_entries + 1));
  print("\nlocal speed: " + local_speed + ", relative speed: " + c_speed);
}

// utilities -------------------------------------------------------------------------

// return true if txt is not null and not empty
String checkProfileItem(Object profileItem, String defaultValue) {
  return profileItem != null && ((String) profileItem).length() != 0 ? (String) profileItem : defaultValue;
}

/*
or:
boolean checkUser() {
  // set item
  entityDS.id(username).token(username);
  // get item
  Map<String, Object> result = entityDS.get();
  //print(result);
  if (result.isEmpty()) {
    return false;
  } else {
    return true;
  }
}
*/
