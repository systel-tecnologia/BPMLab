/*
 File: BPMDataFileReader.pde
 Version: 1.0
 Date: 25/03/2019
 Project: Systel BPM Lab Application Simple Connection
 Author: Daniel Valentin - dtvalentin@gmail.com
 */

public class DataLocation {
  private String fileName = "";
  private String date = "";
  private String time = "";
  private int x;
  private int y;
  private int z;
  private int h;
  private int w;
  private int l;
  private int hp;

  public String getFileName() { 
    return fileName;
  };

  public String getDate() { 
    return date;
  };

  public String getTime() { 
    return time;
  };

  public int getX() { 
    return x;
  };

  public int getY() { 
    return y;
  };

  public int getZ() { 
    return z;
  };

  public int getH() { 
    return h;
  };

  public int getW() { 
    return w;
  };
  
  public int getL() { 
    return l;
  };


  public int getHp() { 
    return hp;
  };
}

public class BPMDataFileReader {

  private String fileName = "";

  private boolean fileOpen = false;

  public BPMDataFileReader(PApplet parent) {
    super();
  }

  public DataLocation processData(String data) {
    setFileName(data);
    return extractDataLocation(data);
  }

  public void processData(File file) {
  }

  public void closeFile() {
    fileOpen = false;
  }

  private DataLocation extractDataLocation(String data) {
    DataLocation dataLocation = new DataLocation();
    dataLocation.fileName = fileName;
    String[] parts = data.split(";");
    if (parts.length == 9 && !parts[0].equals("DATE")) {
      dataLocation.date = parts[0];
      dataLocation.time = parts[1];
      dataLocation.x = parseInt(parts[2]);
      dataLocation.y = parseInt(parts[3]);
      dataLocation.z = parseInt(parts[4]);
      dataLocation.h = parseInt(parts[5]);
      dataLocation.w = parseInt(parts[6]);
      dataLocation.l = parseInt(parts[7]);
      dataLocation.hp = parseInt(parts[8].replace("\r\n", ""));
    }
    return dataLocation;
  }

  private void setFileName(String data) {
    if (!fileOpen) {
      String[] parts = data.split(" ");
      for (int i = 0; i < parts.length; i++) {
        if (parts[i].startsWith("BPMDF")) {
          fileOpen = true;
          fileName = parts[i];
          break;
        }
      }
    }
  }
}
