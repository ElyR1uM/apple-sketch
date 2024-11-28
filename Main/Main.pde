// Main Sketch for Apple falling simulation

Apple apple;
World world;
OrbitCamera cam;
PShape platform;
void settings() {
  size(1290, 720, P3D);
}

void setup() {
  cam = new OrbitCamera();
  apple = new Apple();
  world = new World();
}

void draw() {
  
  background(0);
  lights();
  cam.update();

  // Start of Frame
  pushMatrix();
  cam.applyRotation();

  // Render & Update Apple
  getCollision();

  // Render all scene objects
  shape(apple.model);
  shape(world.model);

  // Set the world platform to desired coordinates
  world.model.resetMatrix();
  world.model.translate(world.position.x, world.position.y, world.position.z);

  // Update Apple's position
  apple.model.resetMatrix(); // Always sets the models *visible* position to the position of the apple object
  apple.model.translate(apple.position.x, apple.position.y, apple.position.z);

  // End of Frame
  println(apple.position.y + " // " + world.position.y);
  popMatrix();
}

void getCollision() {
  float r = 3.75f;

  // Raycast to see if the apple is colliding with the world
  if (apple.position.y <= world.position.y + r) {
    println("Colliding!");
  } else {
    apple.position.y += apple.mass * -9.81f;
  }
}
