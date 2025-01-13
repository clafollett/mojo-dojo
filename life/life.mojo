from gridv1 import Grid
from python import Python, PythonObject
import time

def run_display(
    owned grid: Grid,
    window_height: Int = 1024,
    window_width: Int = 1024,
    background_color: String = "black",
    pause: Float64 = 0.1,
) -> None:
    var window: PythonObject
    var pygame: PythonObject

    try:
        # Import and initialize "pygame"
        pygame = Python.import_module("pygame")
        pygame.init()
    except err:
        print("The following error has occured loading pygame: ", err)
        return

    try:
        # Create a window and set the title
        window = pygame.display.set_mode((window_height, window_width))
        pygame.display.set_caption("Conway's Game of Life")
    except err:
        print("The following error occured setting the up the pygame display: ", err)
        pygame.quit()
        return

    cell_height = window_height / grid.rows
    cell_width = window_width / grid.cols
    border_size = 1
    background_fill_color = pygame.Color(background_color)
    running = True
    
    while running:
        try:
            # Poll for events
            event = pygame.event.poll()

            if event.type == pygame.QUIT:
                # Quit if the window is closed
                running = False
            elif event.type == pygame.KEYDOWN:
                # Also quit if the user presses <Escape> or 'q'
                if event.key == pygame.K_ESCAPE or event.key == pygame.K_q:
                    running = False
        except err:
            print("The following error ocurred during processing of the pygame event: ", err)
            pygame.quit()
            return

        try:
            # Clear the window by painting with the background color
            window.fill(background_fill_color)

            # Draw each live cell in the grid
            for row in range(grid.rows):
                for col in range(grid.cols):
                    cell = grid[row, col]
                    if cell.value:
                        x = col * cell_width + border_size
                        y = row * cell_height + border_size
                        width = cell_width - border_size
                        height = cell_height - border_size
                        pygame.draw.rect(
                            window, pygame.Color(cell.color), (x, y, width, height)
                        )

            # Update the display
            pygame.display.flip()
        except err:
            print("The following error ocurred rendering the pygame screent: ", err)
            pygame.quit()
            return

        # Pause to let the user appreciate the scene
        time.sleep(pause)

        # Evolve the grid and reapply
        grid = grid.evolve()
    
    pygame.quit()

def main():
    start = Grid.random(128, 128)
    run_display(start)

