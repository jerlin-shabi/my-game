python
import random

# Define the colors for the bubbles
colors = [(255, 0, 0), (0, 255, 0), (0, 0, 255), (255, 255, 0), (255, 0, 255), (0, 255, 255)]

# Define the function to create a bubble
def create_bubble(x, y, radius, color):
    return {"x": x, "y": y, "radius": radius, "color": color}

# Define the function to draw a bubble on the game window
def draw_bubble(bubble):
    pygame.draw.circle(game_window, bubble["color"], (bubble["x"], bubble["y"]), bubble["radius"])

# Create a random bubble
bubble = create_bubble(random.randint(0, window_width), random.randint(0, window_height), random.randint(10, 50), random.choice(colors))
