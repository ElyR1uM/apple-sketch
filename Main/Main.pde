// Main Sketch for Apple falling simulation

Apple apple;
World world;
OrbitCamera cam;
PVector deltaTime, deltaVel, deltaPos; // Vars for velocity & acceleration
PShape platform;
void settings() {
  size(1290, 720, P3D);
}

void setup() {
  cam = new OrbitCamera();
  apple = new Apple();
  apple.position.y = -1f;
  world = new World();
  deltaTime = new PVector(0, 0, 0);
  deltaVel = new PVector(0, 0, 0);
  deltaPos = new PVector(0, 0, 0);
}

void draw() {
  // "Erase" the last frame
  background(122, 183, 255);
  lights();
  cam.update();

  // Start of Frame
  pushMatrix();
  cam.applyRotation();

  // Calculations for Apple Velocity
  deltaTime.x = (millis() - apple.prevVelocity.x) / 1000.0f;
  deltaTime.y = (millis() - apple.prevVelocity.y) / 1000.0f;
  deltaTime.z = (millis() - apple.prevVelocity.z) / 1000.0f;
  deltaPos.x = -1 * abs(apple.position.x - apple.prevPosition.x);
  deltaPos.y = -1 * abs(apple.position.y - apple.prevPosition.y);
  deltaPos.z = -1 * abs(apple.position.z - apple.prevPosition.z);
  deltaVel.x = apple.velocity.x + apple.acceleration.x * deltaTime.x;
  deltaVel.y = apple.velocity.y + apple.acceleration.y * deltaTime.y;
  deltaVel.z = apple.velocity.z + apple.acceleration.z * deltaTime.z;
  apple.velocity.x = deltaPos.x / deltaTime.x;
  apple.velocity.y = deltaPos.y / deltaTime.y;
  apple.velocity.z = deltaPos.z / deltaTime.z;
  apple.acceleration.x = deltaVel.x / deltaTime.x;
  apple.acceleration.y = deltaVel.y / deltaTime.y;
  apple.acceleration.z = deltaVel.z / deltaTime.z;

  // Render & Update Apple
  apple.prevPosition = apple.position;
  apple.prevVelocity = apple.velocity;
  getCollision(3f); // The down Radius of the Apple is around 3f

  // Render all scene objects
  shape(apple.model);
  shape(world.model);

  // Set the world platform to desired coordinates
  world.model.resetMatrix();
  world.model.translate(world.position.x, world.position.y, world.position.z);

  // Update Apple's position
  apple.model.resetMatrix(); // Always sets the models *visible* position to the position of the apple object
  apple.model.translate(apple.position.x, apple.position.y, apple.position.z);

  // For debugging purposes
  if (keyPressed) {
    if (key == 'r') {
      apple.position.y = 0f;
    }
  }

  // Logging
  println("speedValues: " + apple.acceleration + " // " + apple.velocity);
  println("prevValues: " + apple.prevPosition.y + " // " + apple.prevVelocity);
  println("deltaValues: " + deltaPos.y + " // " + deltaTime + " // " + deltaVel);

  // End of Frame
  popMatrix();
}

void getCollision(float r_d) {
  // Raycast to see if the apple is colliding with the world
  if (apple.position.y <= world.position.y + r_d) { // less-or-equal operator increases the precision of the apple collision 
    apple.position.y = world.position.y + r_d; // Dirty fix to prevent clipping, subject to change
    apple.acceleration.y = 0;
  } else {
    apple.velocity.y += apple.acceleration.y * deltaTime.y * 0.1f; // 0.1f is here to slow down the apple a bit
    apple.position.y += apple.velocity.y * deltaTime.y;
  }
}
