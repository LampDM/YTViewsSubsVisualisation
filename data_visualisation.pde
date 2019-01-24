import controlP5.*;


JSONArray ja = null;
channel[] cl = null;
channels cns = null;
boolean actionOccured = true;
float plotX1, plotY1; 
float plotX2, plotY2;
int fn =2;
ControlP5 cp5;
int headRange=350;
int tailRange=900;
DropdownList d2;
CheckBox checkbox;

void setup() {
  size(1200, 450);
  //fullScreen();
  ja = loadJSONArray("date_data_latest.json"); // spremeni v date_data za starejse podatke z negativnimi ogledi
  int n = ja.size();


  //Load channels into array
  cl = new channel[n];
  for (int k = 0; k<n; k++) {
    cl[k]=new channel(ja.getJSONArray(k));
  }

  //Create channels controller
  cns = new channels(cl);

  //Initialise sliders and other
  cp5 = new ControlP5(this);
  cp5.addSlider("headRange")
    .setPosition(100, 25)
    .setColorLabel(color(150))
    .setRange(cns.minAvg, cns.maxAvg)
    .setSize(1000, 5);
  ;

  cp5.addSlider("tailRange")
    .setPosition(100, 50)
    .setColorLabel(color(150))
    .setRange(cns.minAvg, cns.maxAvg)
    .setSize(1000, 5);
  ;

  d2 = cp5.addDropdownList("myList-d2")
    .setPosition(width*2/3, 80)
    .setSize(200, 200)
    ;



  //Basic plot area drawing
  plotX1 = 120; 
  plotX2 = width - plotX1; 
  plotY1 = 120; 
  plotY2 = height - plotY1;


  checkbox = cp5.addCheckBox("checkBox")
    .setPosition(width*93/100, plotY1)
    .setSize(10, 10)
    .setItemsPerRow(1)
    .setSpacingColumn(30)
    .setSpacingRow(20)
    .setColorLabel(color(150))
    .addItem("comedy", 0)
    .addItem("animals", 1)
    .addItem("entertainment", 2)
    .addItem("games", 3)
    .addItem("music", 4)
    .addItem("news", 5)
    .addItem("education", 6)
    .addItem("howto", 7)
    .addItem("tech", 8).setColorBackground(color(255,255,255))
    ;
 
  checkbox.getItem(0).setColorActive(#911eb4).setColorForeground(#911eb4);
  checkbox.getItem(1).setColorActive(#3cb44b).setColorForeground(#3cb44b);
  checkbox.getItem(2).setColorActive(#f58231).setColorForeground(#f58231);
  checkbox.getItem(3).setColorActive(#e6194b).setColorForeground(#e6194b);
  checkbox.getItem(4).setColorActive(#ffe119).setColorForeground(#ffe119);
  checkbox.getItem(5).setColorActive(#000075).setColorForeground(#000075);
  checkbox.getItem(6).setColorActive(#4363d8).setColorForeground(#4363d8);
  checkbox.getItem(7).setColorActive(#42d4f4).setColorForeground(#42d4f4);
  checkbox.getItem(8).setColorActive(#aaffc3).setColorForeground(#aaffc3);


  customize(d2);
}




void draw() {

  if (keyPressed) {
    switch(key) {
    case 'v':
      fn=3;
      cp5.getController("tailRange").setMax(cns.maxAvg);
      cp5.getController("tailRange").setMin(cns.minAvg);

      cp5.getController("headRange").setMax(cns.maxAvg);
      cp5.getController("headRange").setMin(cns.minAvg);

      break;
    case 's':
      cp5.getController("tailRange").setMax(cns.maxAvg);
      cp5.getController("tailRange").setMin(cns.minAvg);

      cp5.getController("headRange").setMax(cns.maxAvg);
      cp5.getController("headRange").setMin(cns.minAvg);
      fn=2;
      break;
    }
    actionOccured=true;
  }


  // cp5.getController("headRange").setMax(55);


  if (actionOccured) {

    //Applying slider filter
    cns.filterRange(headRange, tailRange);
    cns.filterCategories();
    drawBackground();
    drawData(fn);
    updateDDL(d2);
    actionOccured=false;
  }
}

void drawBackground() {
  background(224); 

  // Show the plot area as a white box 
  fill(255); 
  rectMode(CORNERS); 
  noStroke(); 
  rect(plotX1, plotY1, plotX2, plotY2);

  drawTitle();
  drawAxisLabels();
  drawDayLabels();
  drawYQuantityLabels();
}

public void drawData(int fn) {
  for (channel c : cns.getChannels()) {
    JSONArray ca = c.raw_info.getJSONArray(fn);
    strokeWeight(1); 
    stroke(c.getColour());
    beginShape(LINES);
    for (int k = 0; k<ca.size()-1; k++) {
      float xa = map(k, 13, 0, plotX1, plotX2);
      float ya = map(getValue(ca.getString(k)), cns.minValue, cns.maxValue, plotY2, plotY1);

      vertex(xa, ya);
      float xb = map(k+1, 13, 0, plotX1, plotX2);
      float yb = map(getValue(ca.getString(k+1)), cns.minValue, cns.maxValue, plotY2, plotY1);
      vertex(xb, yb);
    }
    endShape();
  }
  smooth();
}

public void mouseReleased() {
  actionOccured=true;
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(checkbox)) {
    actionOccured=true;
    int col = 0;
    for (int i=0; i<checkbox.getArrayValue().length; i++) {
      int n = (int)checkbox.getArrayValue()[i];
      if(n>0){
        cns.cstats[(int)checkbox.getItem(i).internalValue()]=false;
      }else{
        cns.cstats[(int)checkbox.getItem(i).internalValue()]=true;
      }
    }
  }

}
