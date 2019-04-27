/*
 File: BPMDataFileReader.pde
 Version: 1.0
 Date: 25/03/2019
 Project: Systel BPM Lab Application Simple Connection
 Author: Daniel Valentin - dtvalentin@gmail.com
 */

class BPMRoute {
  BPMRoute(String quadA, String quadB) {
    from = quadA;
    to = quadB;
  }
  String from;
  String to;
}

class BPMAnalysys {
  int registers = 0;
  int transitions = 0;
  int holePokes = 0;
  int rearings = 0;
  String rows[] = {};
  List<BPMRoute> routes = new ArrayList<BPMRoute>();
}

public class DataLocation {
  private int x;
  private int y;
  private int z;
  private int h;
  private int w;
  private int l;
  private int hp;
}

public class BPMDataFileReader {

  private boolean fileOpen = false;

  public BPMDataFileReader() {
    super();
  }

  public DataLocation processData(String data) {
    return extractDataLocation(data);
  }

  public void closeFile() {
    fileOpen = false;
  }

  private DataLocation extractDataLocation(String data) {
    DataLocation dataLocation = new DataLocation();
    String[] parts = data.split(";");
    if (parts.length == 9 && !parts[0].equals("DATE")) {
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

  public BPMAnalysys analyzeBPMFile(File file) {
    logger("Processing:: Analyzing "+ file.getName()  +" File...");

    BPMAnalysys analysys = new BPMAnalysys();
    int transitions = 0;
    int hps = 0;
    int rgs = 0;
    String quad = BPMArena.QUAD_A;
    String hp = "00";
    String rg = "-01";
    String table[] = loadStrings(file.getAbsolutePath());

    int i = 0;
    for (String row : table) {
      if (i > 0 ) {
        String cols[] = row.split(";");

        // Analyzes Transitions
        String newQuad = findQuad(cols[2], cols[3], quad);
        if (!quad.equals(newQuad)) {
          BPMRoute route = new BPMRoute(quad, newQuad);
          analysys.routes.add(route);
          transitions++;
        }
        quad = newQuad;

        // Analyzys HP
        String newHp = cols[8]; 
        if (!newHp.equals(hp)) {
          if (!newHp.equals("00")) {
            hps++;
          }
        }
        hp = newHp;

        // Analyzys Rearing
        String newRg = cols[4];
        if (!rg.equals("-01")) {
          if (newRg.equals("-01")) {
            rgs++;
          }
        }
        rg = newRg;
      }
      i++;
    }

    analysys.rows = table;
    analysys.rearings = rgs;
    analysys.holePokes = hps;
    analysys.registers = table.length;
    analysys.transitions = transitions;

    logger(analysys.transitions + " Transitions Found");
    logger(analysys.holePokes + " HolePokes Found");
    logger(analysys.rearings + " Rearings Found");

    return analysys;
  }

  private String findQuad(String x, String y, String oldQuad) {
    if (x.equals("-01") || y.equals("-01")) {
      return oldQuad;
    }
    String quadx = quadsX.get(x);
    String quady = quadsY.get(y);
    if (quadx != null && quady != null) {
      String qd[] = quadx.split(",");
      for (String q : qd) {
        if (quady.contains(q)) {
          return q;
        }
      }
    }
    return oldQuad;
  }
}
