import frames.timing.*;
import frames.primitives.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 5;
int maxN = 9;
// Grid antialiasing
int antialiasing_subdiv = 8;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = false;
boolean debug = false;
boolean antialiasingHint = false;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

float inv_antialiasing_subdiv = (float)1/antialiasing_subdiv;
int pow_antialiasing_subdiv = antialiasing_subdiv*antialiasing_subdiv;

void setup() {
  //use 2^n to change the dimensions
  size(700, 700, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it :)
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    public void execute() {
      spin();
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow( 2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

float orientacion(Vector a, Vector b, Vector c) {
  return ((b.x() - a.x()) *  (c.y() - a.y())) - ((b.y() - a.y()) *  (c.x() - a.x()));
}

Vector antialiasing(Vector V1, Vector V2, Vector V3, float x, float y){
  Vector PromedioColor = new Vector(0, 0, 0);
  Vector P = new Vector(0, 0);
  for (float i = 0; i < 1; i += inv_antialiasing_subdiv){
    for (float j = 0; j < 1; j += inv_antialiasing_subdiv){
      P.setX(x + i + inv_antialiasing_subdiv/2);
      P.setY(y + i + inv_antialiasing_subdiv/2);
      float W1 = orientacion(V1, V2, P);
      float W2 = orientacion(V2, V3, P);
      float W3 = orientacion(V3, V1, P);
      if (W1 >= 0 && W2 >= 0 && W3 >= 0) {
        float awgP = 255/(W1 + W2 + W3)/pow_antialiasing_subdiv;
        PromedioColor.setX(PromedioColor.x() + W1*awgP);
        PromedioColor.setY(PromedioColor.y() + W2*awgP);
        PromedioColor.setZ(PromedioColor.z() + W3*awgP);
      }
    }
  }
  return PromedioColor;
}

Vector noAntialiasing(Vector V1, Vector V2, Vector V3, float x, float y){
  Vector PromedioColor = new Vector(0, 0, 0);
  Vector P = new Vector(x, y);
  float W1 = orientacion(V1, V2, P);
  float W2 = orientacion(V2, V3, P);
  float W3 = orientacion(V3, V1, P);
  if (W1 >= 0 && W2 >= 0 && W3 >= 0) {
    float awgP = 255/(W1 + W2 + W3);
    PromedioColor.setX(PromedioColor.x() + W1*awgP);
    PromedioColor.setY(PromedioColor.y() + W2*awgP);
    PromedioColor.setZ(PromedioColor.z() + W3*awgP);
  }
  return PromedioColor;
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  Vector V1 = frame.coordinatesOf(v1);
  Vector V2 = frame.coordinatesOf(v2);
  Vector V3 = frame.coordinatesOf(v3);
  // frame.coordinatesOf converts from world to frame
  // here we convert v1 to illustrate the idea
  if (debug) {
    pushStyle();
    stroke(0,255,0,125);
    point(round(V1.x()), round(V1.y()));
    stroke(0,0,255,125);
    point(round(V2.x()), round(V2.y()));
    stroke(255,0,0,125);
    point(round(V3.x()), round(V3.y()));
    popStyle();
  }
  noStroke();
  Vector max = new Vector(round(max(V1.x(), V2.x(), V3.x())), round(max(V1.y(), V2.y(), V3.y())));
  Vector min = new Vector(round(min(V1.x(), V2.x(), V3.x())), round(min(V1.y(), V2.y(), V3.y())));
  
  if (orientacion(V1, V2, V3)<0)
  {
    V1 = frame.coordinatesOf(v2);
    V2 = frame.coordinatesOf(v1);
  }

  
  Vector PromedioColor;
  for (float x = min.x(); x <= max.x(); x++){
    for (float y = min.y(); y <= max.y(); y++) {
      PromedioColor = antialiasingHint ? antialiasing(V1, V2, V3, x, y) : noAntialiasing(V1, V2, V3, x, y);
      fill(round(PromedioColor.x()), round(PromedioColor.y()), round(PromedioColor.z()), 200);
      rect(x, y, 1, 1);
    }
  }
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void spin() {
  if (scene.is2D())
    scene.eye().rotate(new Quaternion(new Vector(0, 0, 1), PI / 100), scene.anchor());
  else
    scene.eye().rotate(new Quaternion(yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100), scene.anchor());
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < maxN ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : maxN;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
    
  if (key == 'a')
    antialiasingHint = !antialiasingHint;
}
