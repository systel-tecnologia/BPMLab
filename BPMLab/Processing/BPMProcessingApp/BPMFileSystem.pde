/*
 File: BPMFileSystem.pde
 Version: 1.0
 Date: 22/04/2019
 Project: Systel BPM Lab Application Simple Connection
 Author: Daniel Valentin - dtvalentin@gmail.com
 */
import java.*;

class BPMFile {
  String name;
  String date;
  String size;

  BPMFile(String data) {
    String tokens[] = data.split(";");
    name = tokens[0];
    date = tokens[1];
    Float f = new Float(tokens[2]) / 1024;
    size = f.intValue() == 0? "1": f.intValue() + "";
  }
}

public class BPMFileSystem {

  PApplet parent;

  float fsSize = 980;

  float fsUsed = 8;

  int fsCountFiles = 0;

  String volType = "Micro SD";

  String fatType = "FAT 16";

  boolean openned = false;

  ArrayList<BPMFile> files = new ArrayList<BPMFile>();

  public BPMFileSystem(PApplet parent) {
    super();
    this.parent = parent;
  }


  public void openBPMFileSystem(ArrayList<String> dataFileSystem) {
    String data = dataFileSystem.get(0);
    String tokens[] = data.split(";");
    fsSize = new Float(tokens[2]);
    fsUsed = new Float(tokens[3]);
    openned = true;
  }

  public void loadFiles(ArrayList<String> dataFiles) {
    fsCountFiles = 0;
    for (String data : dataFiles) {
      BPMFile file = new BPMFile(data);
      fsUsed += new Float(file.size);
      if (data.contains(".CSV")) {
        files.add(file);
      }
      fsCountFiles++;
    }
    fsUsed = (fsUsed / 2048);
  }

  public boolean deleteFile(BPMFile file, ArrayList<String> deleteFileData) {
    String ret = deleteFileData.get(0);
    if (ret.contains("FILEDELETED")) {
      files.remove(file);
      return true;
    }
    return false;
  }

  public boolean saveBPMFile(ArrayList<String> receivedFileData, File file) {
    PrintWriter output = createWriter(file.getAbsolutePath());
    for (String data : receivedFileData) {
      output.println(data);
    }
    output.flush(); // Write the remaining data
    output.close(); // Finish the file
    return true;
  }

  public void closeFileSystem() {
    openned = false;
  }

  public void update() {
  }

  public boolean isOpenned() {
    return openned;
  }

  public ArrayList<BPMFile> getFileNames() {
    return files;
  }
}
