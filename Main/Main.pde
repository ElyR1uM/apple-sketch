// Main Sketch for Apple falling simulation

Apple apple;
World world;
OrbitCamera cam;
float currentTime, previousTime, deltaTime;
PVector deltaVel, deltaPos; // Vars for velocity & acceleration
PShape platform;

void settings() {
  size(1290, 720, P3D);
}

void setup() {
  cam = new OrbitCamera();
  apple = new Apple();
  world = new World();
  deltaVel = new PVector(0, 0, 0);
  deltaPos = new PVector(0, 0, 0);
  apple.position.y = -0.1f;
  apple.velocity.y = -9.81f;
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
  previousTime = currentTime;
  currentTime = millis() / 1000.0f;
  deltaTime = currentTime - previousTime;
  deltaPos.set(-1 * abs(apple.position.x - apple.prevPosition.x), -1 * abs(apple.position.y - apple.prevPosition.y), -1 * abs(apple.position.z - apple.prevPosition.z));
  deltaVel.set(apple.velocity.x + apple.acceleration.x * deltaTime, apple.velocity.y + apple.acceleration.y * deltaTime, apple.velocity.z + apple.acceleration.z * deltaTime);
  apple.velocity.set(deltaPos.x / deltaTime, deltaPos.y / deltaTime, deltaPos.z / deltaTime);
  apple.acceleration.set(deltaVel.x / deltaTime, deltaVel.y / deltaTime, deltaVel.z / deltaTime);

  // Render & Update Apple
  apple.prevPosition.set(apple.position);
  apple.prevVelocity.set(apple.velocity);
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
      apple.position.y = -0.1f;
      apple.velocity.y = -9.81f;
      println(apple.velocity.y);
    }
    if (key == 's') {
      world.position.y -= 10f;
    }
  }

  // Logging
  // println("speedValues: " + apple.acceleration + " // " + apple.velocity);
  // println("prevValues: " + apple.prevPosition.y + " // " + apple.prevVelocity);
  // println("deltaValues: " + deltaPos.y + " // " + deltaTime + " // " + deltaVel);

  // End of Frame
  popMatrix();
}

void getCollision(float r_d) {
  // Raycast to see if the apple is colliding with the world
  if (apple.position.y <= world.position.y + r_d) { // less-or-equal operator increases the precision of the apple collision 
    apple.position.y = world.position.y + r_d; // Dirty fix to prevent clipping, subject to change
    apple.acceleration.y = 0;
    if (apple.prevVelocity.y != 0 && apple.velocity.y < 0) {
      println("--------------------");
      println("Collision: " + apple.prevVelocity.y);
      println("Velocity: " + apple.velocity.y + " // Acceleration: " + apple.acceleration.y);
      println("--------------------");
    }
  } else {
    apple.velocity.y += apple.acceleration.y * deltaTime * 0.001f; // Factor is here to slow down the apple
    apple.position.y += apple.velocity.y * deltaTime;
  }
}
