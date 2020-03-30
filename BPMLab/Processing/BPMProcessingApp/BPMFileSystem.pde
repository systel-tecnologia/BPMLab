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
  float fsSize = 980;
  float fsUsed = 8;
  int fsCountFiles = 0;
  int fsBmpFiles = 0;
  String volType = "";
  String fatType = "";
  boolean openned = false;
  ArrayList<BPMFile> remoteFiles = new ArrayList<BPMFile>();
  ArrayList<BPMFile> localFiles = new ArrayList<BPMFile>();

  public BPMFileSystem() {
  }

  public void openBPMFileSystem(ArrayList<String> dataFileSystem) {
    if (!dataFileSystem.isEmpty()) {
      String data = dataFileSystem.get(0);
      String tokens[] = data.split(";");
      if (tokens.length >= 4) {
        volType = "SD1"; 
        if (tokens[1].equals("2")) {
          volType = "SD2";
        } 
        if (tokens[1].equals("3")) {
          volType = "SDHC";
        } 
        fatType = "FAT" + tokens[1];
        fsSize = new Float(tokens[2]);
        fsUsed = new Float(tokens[3]);
      }
    }
    openned = true;
  }

  public void loadLocalFiles() {
    localFiles.clear();
    File repo = new File(getParamValue("REPO"));
    if (repo.exists()) {
      File fls[] = repo.listFiles();
      for (File f : fls) {
        if (f.getName().contains(".CSV")) {
          Date mdf = new Date(f.lastModified());         
          String data = f.getName() + ";" + fmdtf.format(mdf) + ";" + Math.abs(f.length());
          BPMFile file = new BPMFile(data);
          localFiles.add(file);
        }
      }
      Collections.sort(localFiles, new Comparator<BPMFile>() {
        public int compare(BPMFile o2, BPMFile o1) {
          return o1.name.compareTo(o2.name);
        }
      }     
      );
    }
  }

  public void loadRemoteFiles(ArrayList<String> dataFiles) {
    remoteFiles.clear();
    fsCountFiles = 0;
    fsBmpFiles = 0;
    for (String data : dataFiles) {
      BPMFile file = new BPMFile(data);
      fsUsed += new Float(file.size);
      if (data.contains(".CSV")) {
        remoteFiles.add(file);
        fsBmpFiles++;
      }
      fsCountFiles++;
    }
    fsUsed = (fsUsed / 2048);
    Collections.sort(remoteFiles, new Comparator<BPMFile>() {
      public int compare(BPMFile o2, BPMFile o1) {
        return o1.name.compareTo(o2.name);
      }
    }     
    );
  }

  public boolean deleteFile(BPMFile file, ArrayList<String> deleteFileData) {
    String ret = deleteFileData.get(0);
    if (ret.contains("FILEDELETED")) {
      remoteFiles.remove(file);
      return true;
    }
    return false;
  }

  public boolean saveBPMFile(ArrayList<String> receivedFileData, File file) {
    PrintWriter output = createWriter(file.getAbsolutePath());
    int i = 0;
    for (String data : receivedFileData) {
      if (i > 0 ) {
        output.append(data);
      }
      i++;
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

  public ArrayList<BPMFile> getLocalFiles() {
    return localFiles;
  }

  public ArrayList<BPMFile> getRemoteFiles() {
    return remoteFiles;
  }
}
