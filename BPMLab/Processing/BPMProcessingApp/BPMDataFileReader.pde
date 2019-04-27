/*
 File: BPMDataFileReader.pde
 Version: 1.0
 Date: 25/03/2019
 Project: Systel BPM Lab Application Simple Connection
 Author: Daniel Valentin - dtvalentin@gmail.com
 */
import java.time.format.DateTimeFormatter;

class BPMRoute {
  BPMRoute(String quadA, String quadB) {
    from = quadA;
    to = quadB;
  }
  String from;
  String to;
}

public class BPMRegister {
  String date ="";
  String time ="";
  Integer pos_x = -1;
  Integer pos_y = -1;
  Integer pos_z = -1;
  Integer hp = -1;

  BPMRegister() {
    date ="";
    time ="";
    pos_x = 0;
    pos_y = 0;
    pos_z = 0;
    hp = 0;
  }

  BPMRegister(String data) {
    String[] parts = data.split(";");
    if (parts.length == 6 && !parts[0].equals("DATE")) {
      date = parts[0];
      time = parts[1];
      pos_x = parseInt(parts[2]);
      pos_y = parseInt(parts[3]);
      pos_z = parseInt(parts[4]);
      hp = parseInt(parts[5].replace("\r\n", ""));
    }
  }
}

class BPMAnalysis { 
  int registers = 0;
  int moviments = 0;
  int holePokes = 0;
  int rearings = 0;
  int timeCount = 0;
  List<BPMRoute> route = new ArrayList<BPMRoute>();
  List<BPMRegister> row = new ArrayList<BPMRegister>();
}

public class BPMDataFileReader {

  public BPMDataFileReader() {
    super();
  }

  public BPMRegister processData(String data) {
    BPMRegister register = new BPMRegister(data);
    return register;
  }


  public BPMAnalysis analyzeBPMFile(File file) {
    logger("Processing:: Analyzing "+ file.getName()  +" File...");

    BPMAnalysis analysis = new BPMAnalysis();
    int transitions = 0;
    int hps = 0;
    int reags = 0;
    String quad = BPMQuadrant.QUAD_A;
    Integer hp = 0;
    Integer rg = -1;
    String table[] = loadStrings(file.getAbsolutePath());
    String initTime ="";
    String endTime = "";
    int i = 0;
    for (String row : table) {
      if (i == 0) {
        if (!row.contains("DATE;TIME;X;Y;Z;HP")) {
          break;
        }
      }
      if (i > 0) {
        BPMRegister register = new BPMRegister(row); 
        analysis.row.add(register);

        // Start Time Process
        if (i == 1) {
          initTime = register.date + " "+ register.time;
        }

        // Analyzes Transitions
        String newQuad = findQuad(register.pos_x, register.pos_y, quad);
        if (!quad.equals(newQuad)) {
          BPMRoute route = new BPMRoute(quad, newQuad);
          analysis.route.add(route);
          transitions++;
        }
        quad = newQuad;

        // Analyzys HP
        Integer newHp = register.hp; 
        if (!newHp.equals(hp)) {
          if (!newHp.equals(0)) {
            hps++;
          }
        }
        hp = newHp;

        // Analyzys Rearing
        Integer newRg = register.pos_z;
        if (!rg.equals(-1)) {
          if (newRg.equals(-1)) {
            reags++;
          }
        }
        rg = newRg;
        endTime = register.date + " "+ register.time;
      }
      i++;
    }

    analysis.timeCount = calculateTimeCount(initTime, endTime);
    analysis.rearings = reags;
    analysis.holePokes = hps;
    analysis.registers = analysis.row.size();
    analysis.moviments = transitions;
    logger(analysis.moviments + " Transitions Found");
    logger(analysis.holePokes + " HolePokes Found");
    logger(analysis.rearings + " Rearings Found");

    return analysis;
  }

  private int calculateTimeCount(String initTime, String endTime) {
    if (!endTime.isEmpty() && !initTime.isEmpty()) {
      DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
      LocalDateTime i = LocalDateTime.parse(initTime, formatter);
      LocalDateTime e = LocalDateTime.parse(endTime, formatter);
      Duration duration = Duration.between(i, e);
      Long period = Math.abs(duration.toMinutes());
      Long milis = Math.abs(duration.toMillis());
      if (milis <= 60000) {
        return 1;
      }
      return period.intValue();
    }
    return 0;
  }


  private String findQuad(int x, int y, String oldQuad) {
    if (x == -1 || y == -1) {
      return oldQuad;
    }
    String quadx = bpmArena.quadsX.get(x);
    String quady = bpmArena.quadsY.get(y);
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
