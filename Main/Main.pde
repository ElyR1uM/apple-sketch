// Main Sketch for Apple falling simulation

OrbitCamera cam;
void settings() {
  size(1290, 720, P3D);
}
void setup() {
    box(240, 240, 240);
    // Create Orbiting cam to rotate around the scene
    cam = new OrbitCamera();
}
void draw() {
    // draw
}