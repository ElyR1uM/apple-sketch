// Main Sketch for Apple falling simulation

Apple apple;
OrbitCamera cam;
void settings() {
  size(1290, 720, P3D);
}

void setup() {
  cam = new OrbitCamera();
  apple = new Apple();
}

void draw() {
  
  background(0);
  lights();
  cam.update();

  // Start of Frame
  pushMatrix();
  cam.applyRotation();

  // Render & Update Apple
  apple.position.y += apple.mass * -9.81f;

  // Render all scene objects
  shape(apple.model);

  // Update Apple's position
  apple.model.resetMatrix(); // Always sets the models *visible* position to the position of the apple object
  apple.model.translate(apple.position.x, apple.position.y, apple.position.z);

  // End of Frame
  println(apple.position);
  popMatrix();
}

void detectCollision(Apple apple) {
  
}
