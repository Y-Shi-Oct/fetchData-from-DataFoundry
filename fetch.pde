//fetch data from data foundry and parse strings to integers where needed
//calculate the relative speed of the user over all of their inputs
void fetchData() {
 entityDS.id(uname).token(uname);
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
