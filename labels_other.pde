

void drawTitle() {
  fill(0);
  textSize(20);
  textAlign(LEFT);
  
  String title = fn==2 ? "Youtube daily subscribers visualisation" : "Youtube daily views visualisation";
  text(title, plotX1, plotY1 - 10);
  String someinfo = fn==2 ? "Press V to switch to views visualisation!" : "Press S to switch to subscribers visualisation!";
  textSize(15);
  text(someinfo,plotX1,plotY2+77);
}


void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);

  textAlign(CENTER, CENTER);
  text("Quantity \n  in thousands", plotX1-70, (plotY1+plotY2)/2);
  textAlign(CENTER);
  text("Day", (plotX1+plotX2)/2, plotY2+70);
}

void drawDayLabels() {
  fill(0);
  textSize(10);
  textAlign(CENTER);

  // Use thin, gray lines to draw the grid
  stroke(224);
  strokeWeight(1);

  for (int k = 0; k < 14; k++) {
    float x = map(k, 0, 13, plotX1, plotX2);
    text(cns.dates.getString(k), x, plotY2 + textAscent() + 10);
    line(x, plotY1, x, plotY2);
  }
}

void drawYQuantityLabels() {
  fill(0);
  textSize(10);
  textAlign(RIGHT);

  stroke(128);
  strokeWeight(1);
  cns.reVal();
  float interval = ((cns.maxValue-cns.minValue)/5.0);
  float textOffset = textAscent()/2;
  if (cns.getChannels().length>0) {
    for (float v = cns.minValue; v <= cns.maxValue; v += interval) {

      float y = map(v, cns.minValue, cns.maxValue, plotY2, plotY1);  
      text((floor(v)/1000)+"k", plotX1 - 10, y + textOffset);
      line(plotX1 - 4, y, plotX1, y);
    }
    float y = map(0, cns.minValue, cns.maxValue, plotY2, plotY1);
    text(0, plotX1 - 10, y + textOffset);
    line(plotX1, y, width-plotX1, y);
  }
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(20);
  ddl.setBarHeight(15);
  ddl.getCaptionLabel().set("Selected channels");
  channel[] cl = cns.getChannels();

  for (int k =0; k<cl.length; k++) {
    ddl.addItem(cl[k].name, k);
  }



  //ddl.scroll(0);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

public void updateDDL(DropdownList ddl) {
  ddl.clear();
  channel[] cl = cns.getChannels();

  for (int k =0; k<cl.length; k++) {
    ddl.addItem(cl[k].name, k);
  }
}

int getValue(String str) {
  str=str.replace(",", "");
  int val = 0;
  try {
    switch(str.split("")[0]) {
    case "+":
      val=Integer.parseInt(str.split("\\+")[1]);
      break;
    case "-":
      try {
        val=-1*Integer.parseInt(str.split("-")[1]);
      }
      catch(Exception e) {
      }
      break;
    default:
      break;
    }
  }
  catch(Exception e) {
  }
  return val;
}
