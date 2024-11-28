// Main Sketch for Apple falling simulation

Apple apple;
World world;
OrbitCamera cam;
float timePrev, dy, dt, dv; // Vars for velocity & acceleration
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
  // "Erase" the last frame
  background(0);
  lights();
  cam.update();

  // Start of Frame
  pushMatrix();
  cam.applyRotation();

  // Calculations for Apple Velocity
  timePrev = millis();
  dy = apple.position.y;
  dt = (timePrev - apple.prevVelocity) / 1000.0f;
  dv = apple.velocity + apple.acceleration * dt;
  apple.velocity = dy / dt;
  apple.acceleration = dv / dt;

  // Render & Update Apple
  apple.prevPosition.y = apple.position.y;
  apple.prevVelocity = apple.velocity;
  if (!apple.grounded) {
    getCollision(3.75f); // The down Radius of the Apple is 3.75f
  }

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
  popMatrix();
}

void getCollision(float r) {
  // Raycast to see if the apple is colliding with the world
  if (apple.position.y <= world.position.y + r) { // less-or-equal operator increases the precision of the apple collision
    apple.grounded = true;
  } else {
    apple.position.y += apple.mass * -9.81f;
  }
}
