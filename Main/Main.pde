// Main Sketch for Apple falling simulation

Apple apple;
OrbitCamera cam;
void settings() {
  size(1290, 720, P3D);
}

void setup() {
    // Create Orbiting cam to rotate around the scene
    cam = new OrbitCamera();
    apple = new Apple();
}

void draw() {
    // draw
    // Cam creator was doing some dirty workarounds by blacking out the last frame to prevent ghosting, need to find a fix for this
    background(0);
    lights();
    cam.update();
    // Start of Frame
    pushMatrix();
    cam.applyRotation();
    // Place any object that the camera is supposed to rotate around here
    shape(apple.model);
    apple.model.translate(apple.position.x, apple.position.y * force, apple.position.z);
    println(apple.position);
    popMatrix();
}

void detectCollision(Apple apple) {
  
}
