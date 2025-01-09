// Main Sketch for Apple falling simulation

Apple apple;
World world;
OrbitCamera cam;
float currentTime, previousTime; 
PVector deltaVel, deltaPos, deltaTime, wForce; // deltaTime is the duration of the current acceleration in seconds

void settings() {
  size(1290, 720, P3D);
}
 
void setup() {
  cam = new OrbitCamera();
  apple = new Apple();
  world = new World();
  deltaVel = new PVector(0, 0, 0);
  deltaPos = new PVector(0, 0, 0);
  deltaTime = new PVector(0, 0, 0);
  wForce = new PVector(0, 0, 0);
  apple.position.y = -0.1f;
  apple.velocity.y = -9.81f;
}

void draw() {
  // "Erase" the last frame
  background(122, 183, 255);
  lights();
  cam.update();
  cam.applyRotation();

  // Calculations for Apple Velocity
  previousTime = currentTime;
  currentTime = millis() / 1000.0f;
  deltaTime.add(currentTime - previousTime, currentTime - previousTime, currentTime - previousTime); // xd forgot to make it "+=" instead of just "=" Will have to redo adjustments to the calculations now
  deltaPos.set(-1 * abs(apple.position.x - apple.prevPosition.x), -1 * abs(apple.position.y - apple.prevPosition.y), -1 * abs(apple.position.z - apple.prevPosition.z));
  deltaVel.set(apple.velocity.x + apple.acceleration.x * deltaTime.x, apple.velocity.y + apple.acceleration.y * deltaTime.y, apple.velocity.z + apple.acceleration.z * deltaTime.z);
  apple.velocity.set(deltaPos.x / deltaTime.x, deltaPos.y / deltaTime.y, deltaPos.z / deltaTime.z);
  apple.acceleration.set(deltaVel.x / deltaTime.x, deltaVel.y / deltaTime.y, deltaVel.z / deltaTime.z);

  // Terminal velocity check & hard limit
  if (abs(apple.velocity.x) >= apple.v_t) {
    apple.velocity.x = apple.velocity.x > 0 ? apple.v_t : -apple.v_t;
  }
  if (abs(apple.velocity.y) >= apple.v_t) {
    apple.velocity.y = apple.velocity.y > 0 ? apple.v_t : -apple.v_t;
  }
  if (abs(apple.velocity.z) >= apple.v_t) {
    apple.velocity.z = apple.velocity.z > 0 ? apple.v_t : -apple.v_t;
  }

  // Render & Update Apple
  apple.prevPosition.set(apple.position);
  apple.prevVelocity.set(apple.velocity);
  getCollision(3f); // The down Radius of the Apple is around 3f

  // Render all scene objects
  pushMatrix();
  shape(apple.model);
  shape(world.model);

  // Set the world platform to desired coordinates
  world.model.resetMatrix();
  world.model.translate(world.position.x, world.position.y, world.position.z);

  // Update Apple's position
  apple.model.resetMatrix(); // Always sets the models *visible* position to the position of the apple object
  apple.model.translate(apple.position.x, apple.position.y, apple.position.z);

  // End of Frame (visually)
  popMatrix();

  // For debugging purposes
  if (keyPressed) {
    switch (key) {
      case 'r':
        deltaTime.set(0, 0, 0);
        apple.position.set(0, -0.1f, 0);
        apple.velocity.set(0, -9.81f, 0);
        apple.acceleration.set(0, 0, 0);
        deltaVel.set(0, 0, 0);
        wForce.set(0, 0, 0);
        break;
      case 's':
        windForce(-5, false);
        break;
      case 'w':
        windForce(5, false);
        break;
      case 'a':
        windForce(5, true);
        break;
      case 'd':
        windForce(-5, true);
        break;
      default:
        break;
    }
  }

  // Logging
  // println("speedValues: " + apple.acceleration + " // " + apple.velocity);
  // println("prevValues: " + apple.prevPosition.y + " // " + apple.prevVelocity);
  // println("deltaValues: " + deltaPos.y + " // " + deltaTime + " // " + deltaVel);
}

void getCollision(float r_d) {
  // Raycast to see if the apple is colliding with the world
  if (apple.position.dist(world.position) <= r_d) { // less-or-equal operator increases the precision of the apple collision 
    apple.position.y = world.position.y + r_d; // Dirty fix to prevent clipping, subject to change
    apple.acceleration.y = 0;
    if (apple.prevVelocity.y != 0 && apple.velocity.y < 0) {
      println("--------------------");
      println("Collision: " + apple.prevVelocity.y + "m/s");
      println("Velocity: " + apple.velocity.y + "m/s" +  " // Acceleration: " + apple.acceleration.y);
      println("--------------------");
    }
  } else { // Doing these calculations using PVector.add() doesn't produce realistic results as far as my attempts go
    apple.velocity.x += apple.acceleration.x * deltaTime.x * 0.001f;
    apple.position.x += apple.velocity.x * deltaTime.x;
    apple.velocity.y += apple.acceleration.y * deltaTime.y * 0.001f; // Factor is here to slow down the apple
    apple.position.y += apple.velocity.y * deltaTime.y;
    apple.velocity.z += apple.acceleration.z * deltaTime.z * 0.001f;
    apple.position.z += apple.velocity.z * deltaTime.z;
  }
}

void windForce(float F, boolean axis) {
  // Formula for wind force: F = 0.5 * p * v^2 * A * C_d
  // p = air density, v = wind speed, A = cross-sectional area, C_d = drag coefficient
  if (axis) {
    wForce.x += F > 0 ? 0.5f * 1.225f * pow(F, 2) * 0.2827f * 0.47f : 0.5f * 1.225f * -pow(F, 2) * 0.2827f * 0.47f;
  } else {
    wForce.z += F > 0 ? 0.5f * 1.225f * pow(F, 2) * 0.2827f * 0.47f : 0.5f * 1.225f * -pow(F, 2) * 0.2827f * 0.47f;
  }
  apple.acceleration.add(wForce);
}
