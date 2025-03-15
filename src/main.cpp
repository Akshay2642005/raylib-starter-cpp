#include "raylib.h"

// Function that keeps the window running until the user closes it
void gameWindow() {
  while (!WindowShouldClose()) { // Check if the window should close
    BeginDrawing();              // Start rendering frame
    ClearBackground(WHITE);      // Clear screen with white background

    // Draw text in the center of the window
    DrawText("First Raylib Window", 400, 350, 30, BLACK);

    EndDrawing(); // End rendering frame
  }
}

int main() {
  int windowWidth = 1280; // Define window width
  int windowHeight = 720; // Define window height

  // Initialize a window with the given dimensions and title
  InitWindow(windowWidth, windowHeight, "Raylib Window");

  SetTargetFPS(60); // Set frame rate to 60 FPS for smooth rendering

  gameWindow(); // Run the game loop

  CloseWindow(); // Close the window after exiting the loop
  return 0;
}
