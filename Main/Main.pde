// Main Sketch for Apple falling simulation

Apple apple;
World world;
OrbitCamera cam;
float currentTime, previousTime, deltaTime, elapsedTime;
PVector deltaVel, deltaPos, wForce, boundaries0, boundaries1;
boolean worldStateChanged = false;

void settings() {
  size(1290, 720, P3D);
}
 
void setup() {
  cam = new OrbitCamera();
  apple = new Apple();
  world = new World();
  deltaVel = new PVector(0, 0, 0);
  deltaPos = new PVector(0, 0, 0);
  wForce = new PVector(0, 0, 0);
  deltaTime = 0;
  configureVertexMesh();
  boundaries0 = new PVector(world.surfaceVertexMesh.get(0).x, world.surfaceVertexMesh.get(0).y, world.surfaceVertexMesh.get(0).z);
  boundaries1 = new PVector(world.surfaceVertexMesh.get(1).x, world.surfaceVertexMesh.get(1).y, world.surfaceVertexMesh.get(1).z);
}

void draw() {
  // "Erase" the last frame
  switch (world.worldState) {
    case 0:
      background(122, 183, 255);
      break;
    case 1:
      background(0);
      break;
  }
  lights();
  cam.update();
  cam.applyRotation();

  // Switch levels if worldState changed
  if (worldStateChanged) {
    switch (world.worldState) {
      case 0:
      // Earth
        apple.g = 9.81f;
        apple.p = 1.225f;
        apple.C_d = 0.47f;
        apple.v_t = apple.calculateTerminalVelocity();
        println("Terminal Velocity: " + apple.v_t);
        break;
      case 1:
      // Moon
        apple.g = 1.62f;
        apple.p = 0.020f;
        apple.C_d = 0.47f;
        apple.v_t = apple.calculateTerminalVelocity();
        println("Terminal Velocity: " + apple.v_t);
        break;
    }
    worldStateChanged = false;
  }

  // Calculations for Apple Velocity
  previousTime = currentTime;
  currentTime = millis() / 1000.0f;
  deltaTime = currentTime - previousTime; // Time between frames
  elapsedTime += deltaTime;
  deltaPos.set(apple.position.x - apple.prevPosition.x, apple.position.y - apple.prevPosition.y, apple.position.z - apple.prevPosition.z);
  deltaVel.set(apple.velocity.x + apple.acceleration.x * deltaTime, apple.velocity.y + apple.acceleration.y * deltaTime, apple.velocity.z + apple.acceleration.z * deltaTime);
  apple.velocity.set(deltaPos.x / deltaTime, deltaPos.y / deltaTime, deltaPos.z / deltaTime);
  apple.acceleration.set(deltaVel.x / deltaTime, deltaVel.y / deltaTime, deltaVel.z / deltaTime);

  switch (apple.state) {
    case 0:
      // Update velocity with acceleration
      apple.velocity.x += apple.acceleration.x * deltaTime;
      apple.velocity.y += apple.acceleration.y * deltaTime;
      apple.velocity.z += apple.acceleration.z * deltaTime;

      // Update position with velocity
      apple.position.x += apple.velocity.x * deltaTime;
      apple.position.y += apple.velocity.y * deltaTime;
      apple.position.z += apple.velocity.z * deltaTime;
      
      if (apple.velocity.y > 0) {
        apple.velocity.y *= 0.9f;
        apple.acceleration.y *= 0.9f;
      }
      break;
    case 1:
      apple.velocity.x += apple.acceleration.x * deltaTime * apple.C_d;
      apple.position.x += apple.velocity.x * deltaTime;
      apple.velocity.z += apple.acceleration.z * deltaTime * apple.C_d;	
      apple.position.z += apple.velocity.z * deltaTime;
      apple.velocity.z -= deltaTime;
      apple.velocity.x -= deltaTime;
      apple.velocity.y = 0;
      apple.acceleration.mult(0);
      break;
    case 2:
      apple.velocity.y = 0;
      break;
  }
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

  // Player Controls
  if (keyPressed) {
    switch (key) {
      case 'r':
        elapsedTime = 0;
        apple.position.set(0, 11f, 0);
        apple.velocity.set(0, 0, 0);
        apple.acceleration.set(0, -apple.g, 0);
        deltaVel.set(0, 0, 0);
        wForce.set(0, 0, 0);
        apple.wasThrown = false;
        apple.state = 3;
        break;
      case 's':
        windForce(1, 1);
        break;
      case 'w':
        windForce(-1, 1);
        break;
      case 'a':
        windForce(1, 0);
        break;
      case 'd':
        windForce(-1, 0);
        break;
      case 'e':
        throwApple(5);
        break;
      case 'm':
        world.worldState = 1;
        worldStateChanged = true;
        break;
      case 'n':
        world.worldState = 0;
        worldStateChanged = true;
        break;
    } 
  } else {
    // Gradually slow down the apple if no other forces are applied
    apple.velocity.x *= 0.9f;
    apple.velocity.z *= 0.9f;
  }
}

void getCollision(float r_d) {
  // Raycast to see if the apple is colliding with the world
  if (apple.position.x <= boundaries0.x && apple.position.x >= boundaries1.x && apple.position.z <= boundaries0.z && apple.position.z >= boundaries1.z && apple.position.y <= boundaries0.y + r_d) {
    apple.position.y = boundaries0.y + r_d;
    apple.state = 1; // Sets the state to Collide
  } else {
    apple.state = 0;
  }
}

void configureVertexMesh() {
  world.surfaceVertexMesh.add(new PVector(300, -50, 300)); // As of right now this is redundant but in case I want to add a 
  world.surfaceVertexMesh.add(new PVector(-300, -50, -300)); // colliding surface with more vertices this approach hopefully saves time and effort
}

void windForce(float F, int axis) {
  // Formula for wind force: F = 0.5 * p * v^2 * A * C_d
  // p = air density, v = wind speed, A = cross-sectional area, C_d = drag coefficient
  // Axis: 0 = left / right, 1 = forward / backward
  switch (axis) {
    case 0:
      wForce.x += F > 0 ? 0.5f * apple.p * pow(F, 2) * 0.2827f * apple.C_d : 0.5f * apple.p * -pow(F, 2) * 0.2827f * apple.C_d;
      break;
    case 1:
      wForce.z += F > 0 ? 0.5f * apple.p * pow(F, 2) * 0.2827f * apple.C_d : 0.5f * apple.p * -pow(F, 2) * 0.2827f * apple.C_d;
      break;
  }
  apple.acceleration.add(wForce);
}

void throwApple(float F) {
  float finishingTime = elapsedTime + 120 * deltaTime;
  PVector throwDirection = cam.getDir();
  throwDirection.mult(F);
  if (apple.wasThrown == false) {
    apple.acceleration.add(throwDirection);
    apple.state = 2;
  }
  if (finishingTime >= elapsedTime) {
    println("Apple was thrown");
    apple.wasThrown = true;
    apple.state = 0;
  }
}
