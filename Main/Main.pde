// Main Sketch for Apple falling simulation

Apple apple;
World world;
OrbitCamera cam;
float currentTime, previousTime, deltaTime, g, p, C_d;
PVector deltaVel, deltaPos, wForce, boundaries0, boundaries1;

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
	background(122, 183, 255);
	lights();
	cam.update();
	cam.applyRotation();

	// Calculations for Apple Velocity
	previousTime = currentTime;
	currentTime = millis() / 1000.0f;
	deltaTime += currentTime - previousTime; // Accumulate deltaTime since the last restart
	deltaPos.set(apple.position.x - apple.prevPosition.x, apple.position.y - apple.prevPosition.y, apple.position.z - apple.prevPosition.z);
	deltaVel.set(apple.velocity.x + apple.acceleration.x * deltaTime, apple.velocity.y + apple.acceleration.y * deltaTime, apple.velocity.z + apple.acceleration.z * deltaTime);
	apple.velocity.set(deltaPos.x / deltaTime, deltaPos.y / deltaTime, deltaPos.z / deltaTime);
	apple.acceleration.set(deltaVel.x / deltaTime, deltaVel.y / deltaTime, deltaVel.z / deltaTime);

	switch (apple.state) {
		case 0:
			apple.velocity.x += apple.acceleration.x * deltaTime * 0.005f; // Constant to adjust the speed of the apple
			apple.position.x += apple.velocity.x * deltaTime;
			apple.velocity.y += apple.acceleration.y * deltaTime * 0.005f;
			apple.position.y += apple.velocity.y * deltaTime;
			apple.velocity.z += apple.acceleration.z * deltaTime * 0.005f;
			apple.position.z += apple.velocity.z * deltaTime;
			if (apple.velocity.y >= 0) {
				apple.velocity.y -= 0.2f * apple.velocity.y;
			}
			break;
		case 1:
			apple.velocity.x += apple.acceleration.x * deltaTime * 0.001f;
			apple.position.x += apple.velocity.x * deltaTime;
			apple.velocity.z += apple.acceleration.z * deltaTime * 0.001f;	
			apple.position.z += apple.velocity.z * deltaTime;
			apple.velocity.x *= 0.001f;
			apple.velocity.z *= 0.001f;
			apple.acceleration.x *= 0.001f;
			apple.acceleration.z *= 0.001f;
			apple.velocity.y = 0;
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
				deltaTime = 0;
				apple.position.set(0, 11f, 0);
				apple.velocity.set(0, -9.81f, 0);
				apple.acceleration.set(0, 0, 0);
				deltaVel.set(0, 0, 0);
				wForce.set(0, 0, 0);
				apple.wasThrown = false;
				apple.state = 3;
				break;
			case 's':
				windForce(3, 1);
				break;
			case 'w':
				windForce(-3, 1);
				break;
			case 'a':
				windForce(3, 0);
				break;
			case 'd':
				windForce(-3, 0);
				break;
			case 'e':
				throwApple(1000);
				break;
			case 'm':
				break;
			case 'n':
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
	world.surfaceVertexMesh.add(new PVector(1000, -50, 1000)); // As of right now this is redundant but in case I want to add a 
	world.surfaceVertexMesh.add(new PVector(-1000, -50, -1000)); // colliding surface with more vertices this approach hopefully saves time and effort
}

void windForce(float F, int axis) {
	// Formula for wind force: F = 0.5 * p * v^2 * A * C_d
	// p = air density, v = wind speed, A = cross-sectional area, C_d = drag coefficient
	// Axis: 0 = left / right, 1 = forward / backward
	switch (axis) {
		case 0:
			wForce.x += F > 0 ? 0.5f * 1.225f * pow(F, 2) * 0.2827f * 0.47f : 0.5f * 1.225f * -pow(F, 2) * 0.2827f * 0.47f;
			break;
		case 1:
			wForce.z += F > 0 ? 0.5f * 1.225f * pow(F, 2) * 0.2827f * 0.47f : 0.5f * 1.225f * -pow(F, 2) * 0.2827f * 0.47f;
			break;
	}
	apple.acceleration.add(wForce);
}

void throwApple(float F) {
	float finishingTime = deltaTime + 60 * (currentTime - previousTime);
	PVector throwDirection = cam.getDir();
	throwDirection.mult(F * 0.5f * 1.225f * 0.2827f * 0.47f);
	if (apple.wasThrown == false) {
		apple.acceleration.add(throwDirection);
		println("Apple was thrown");
		apple.state = 2;
		if (finishingTime >= deltaTime) {
			apple.wasThrown = true;
		}
	}
}
