// Main Sketch for Apple falling simulation

OrbitCamera cam;
void settings() {
  size(1290, 720, P3D);
}
void setup() {
    // Create Orbiting cam to rotate around the scene
    cam = new OrbitCamera();
    background(0);
}
void draw() {
    // draw
    lights();
    cam.update();
    pushMatrix();
    cam.applyRotation();
    // Place any object that the camera is supposed to rotate around here
    box(10);
    popMatrix();
}