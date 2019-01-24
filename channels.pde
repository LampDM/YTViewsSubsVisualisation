




class channel {
  String name;
  String category;
  JSONArray nsubs;
  JSONArray nviews;
  JSONArray subs;
  JSONArray views;
  int avg_subs;
  int avg_views;
  JSONArray raw_info;
  boolean filtered = true;
  JSONArray dates;


  public channel(JSONArray info) {
    this.name=info.getString(0);
    this.category=info.getString(1);
    this.nsubs=info.getJSONArray(2);
    this.nviews=info.getJSONArray(3);

    this.subs=info.getJSONArray(4);
    this.views=info.getJSONArray(5);

    this.avg_subs=getValue(info.getString(8));
    this.avg_views=getValue(info.getString(9));
    this.dates=info.getJSONArray(10);
    this.raw_info=info;
  }

  public int getColour() {
    switch(this.category) {
    case "comedy":
      return #911eb4;
    case "animals":
      return #3cb44b;
    case "entertainment":
      return #f58231;
    case "games":
      return #e6194b;
    case "music":
      return #ffe119;
    case "news":
      return #000075;
    case "education":
      return #4363d8;
    case "howto":
      return #42d4f4;
    case "tech":
      return #aaffc3;
    default:
      return #000000;
    }
  }
}

class channels {
  channel[] cns;
  float maxValue;
  float minValue;
  float maxAvg;
  float minAvg;
  JSONArray dates;
  String[] categories = {"comedy", "animals", "entertainment", "games", "music", "news", "education", "howto", "tech"};
  boolean[] cstats = {true, true, true, true, true, true, true, true, true};

  public channels(channel[] cns) {
    this.cns=cns;
    this.reVal();
    this.dates = cns[0].dates;
  }

  public void reVal() {
    this.maxValue=this.maxVal();
    this.minValue=this.minVal();
    this.maxAvg=this.maxAvg();
    this.minAvg=this.minAvg();
  }

  public float maxVal() {
    float mv = 0;
    for (channel c : cns) {
      if (c.filtered) {
        continue;
      }
      JSONArray ja = c.raw_info.getJSONArray(fn);
      for (int k = 0; k<ja.size(); k++ ) {
        if (mv<getValue(ja.getString(k))) {
          mv=getValue(ja.getString(k));
        }
      }
    }
    return mv;
  }

  public float minVal() {
    float mv = 0;
    for (channel c : cns) {
      if (c.filtered) {
        continue;
      }
      JSONArray ja = c.raw_info.getJSONArray(fn);
      for (int k = 0; k<ja.size(); k++ ) {
        if (mv>getValue(ja.getString(k))) {
          mv=getValue(ja.getString(k));
        }
      }
    }
    return mv;
  }

  public float minAvg() {
    float mv = 0;
    for (channel c : cns) {

      switch(fn) {
      case 2:
        if (mv>c.avg_subs) {
          mv=c.avg_subs;
        }
        break;
      case 3:
        if (mv>c.avg_views) {
          mv=c.avg_views;
        }
        break;
      }
    }
    return mv;
  }

  public float maxAvg() {
    float mv = 0;
    for (channel c : cns) {

      switch(fn) {
      case 2:
        if (mv<c.avg_subs) {
          mv=c.avg_subs;
        }
        break;
      case 3:
        if (mv<c.avg_views) {
          mv=c.avg_views;
        }
        break;
      }
    }
    return mv;
  }

  public void filterRange(int hd, int tl) {
    if (hd>=tl) {
      this.resetFilterNone();
    } else {
      this.resetFilterAll();
      for (channel c : cns) {
        switch(fn) {
        case 2:
          if (c.avg_subs>=hd && c.avg_subs<=tl) {
            c.filtered=false;
          }
          break;
        case 3:
          if (c.avg_views>=hd && c.avg_views<=tl) {
            c.filtered=false;
          }
          break;
        }
      }
    }
    this.reVal();
  }

  public void resetFilterAll() {
    for (int k = 0; k<this.cns.length; k++) {
      this.cns[k].filtered=true;
    }
    this.reVal();
  }

  public void resetFilterNone() {
    for (int k = 0; k<this.cns.length; k++) {
      this.cns[k].filtered=false;
    }
    this.reVal();
  }


  public void filterCategories() {
    for (channel c : this.getChannels()) {
      for (int k = 0; k<this.categories.length; k++) {
        if (c.category.equals(this.categories[k])) {
          c.filtered=this.cstats[k];
        }
      }
    }
  }

  public channel[] getChannels() {
    ArrayList<channel> fcs = new ArrayList<channel>();

    for (channel c : this.cns) {
      if (!c.filtered) {
        fcs.add(c);
      }
    }

    channel[] ls = new channel[fcs.size()];
    return fcs.toArray(ls);
  }

  //public channel[] getAvgChannels() {
  //  channel[] cs = this.getChannels();
  //  channel[] avgs = new channel[9];
  //  //{"comedy","animals","entertainment","games","music","news","education","howto","tech"};
  //  for (channel ca : cs) {
  //    switch(ca.category) {
  //    case "comedy":
  //      avgs[0].category="comedy";
  //      avgs[0].
  //      break;
  //    case "animals":
  //      avgs[1].category="animals";
        
  //      break;
  //    case "entertainment":
  //      avgs[2].category="entertainment";
  //      break;
  //    case "games":
  //      avgs[3].category="games";
  //      break;
  //    case "music":
  //      avgs[4].category="music";
  //      break;
  //    case "news":
  //      avgs[5].category="news";
  //      break;
  //    case "education":
  //      avgs[6].category="education";
  //      break;
  //    case "howto":
  //      avgs[7].category="howto";
  //      break;
  //    case "tech":
  //      avgs[8].category="tech";
  //      break;
  //    }
  //  }

  //  return cs;
  //}
}
