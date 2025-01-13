import random

@value
struct CellState():
    var value: Int
    var previous: Int
    var evolutions: Int
    var color: String

@value
struct Grid():
    var rows: Int
    var cols: Int
    var data: List[List[CellState]]

    fn __str__(self) raises -> String:
        # Create an empty String
        str = String()

        # Iterate through rows 0 through rows-1
        for row in range(self.rows):
            # Iterate through columns 0 through cols-1
            for col in range(self.cols):
                if self[row, col].value == 1:
                    str += "*"  # If cell is populated, append an asterisk
                else:
                    str += " "  # If cell is not populated, append a space
            if row != self.rows-1:
                str += "\n"     # Add a newline between rows, but not at the end
        return str

    fn __getitem__ (self, row: Int, col: Int) -> CellState:
        return self.data[row][col]

    fn __setitem__ (mut self, row: Int, col: Int, value: CellState) -> None:
        self.data[row][col] = value

    fn get_cell_state(self, row: Int, col: Int) -> CellState:
        return self.data[row][col]

    fn evolve(self) -> Self:
        # Seed the random number generator using the current time
        random.seed()

        next_generation = List[List[CellState]]()

        for row in range(self.rows):
            row_data = List[CellState]()

            # Reference: "wrap-around" - Example, if there are 8 rows, then -1 % 8 is 7.
            # Calc the neighboring row indices, handling "wrap-around"
            row_above = (row - 1) % self.rows
            row_below = (row + 1) % self.rows

            for col in range(self.cols):
                # Calc the neighboring col indices, handling "wrap-around"
                col_left = (col - 1) % self.cols
                col_right = (col + 1) % self.cols

                # Determine number of populated indices, handlnig "wrap-around"
                num_neighbors = (
                    self[row_above, col_left].value
                    + self[row_above, col].value
                    + self[row_above, col_right].value
                    + self[row, col_left].value
                    + self[row, col_right].value
                    + self[row_below, col_left].value
                    + self[row_below, col].value
                    + self[row_below, col_right].value
                )

                # Determine the state of the current cell for the next gneration
                current_state = self.get_cell_state(row, col)
                new_state = CellState(
                    0,
                    current_state.value,
                    current_state.evolutions + 1,
                    current_state.color # Keep the original color
                )

                if current_state.value == 1 and (num_neighbors == 2 or num_neighbors == 3):
                    # No change
                    new_state.value = 1
                elif current_state.value == 0:
                    evolution_cap = int(random.random_si64(5, 20))

                    if num_neighbors == 3 or (current_state.previous == 0 and current_state.evolutions > evolution_cap):
                        new_state.value = 1 # Toggle the state
                        new_state.previous = 0 # Set the previous state
                        new_state.evolutions = 1 # Reset the evolutions

                row_data.append(new_state)

            next_generation.append(row_data)

        return Self(self.rows, self.cols, next_generation)

    @staticmethod
    fn random(rows: Int, cols: Int) -> Self:
        # Seed the random number generator using the current time
        random.seed()

        data = List[List[CellState]]()

        for _ in range(rows):
            row_data = List[CellState]()
            for _ in range(cols):
                value = int(random.random_si64(0, 1))
                color = Self.random_color()
                # Generate a random 0 or 1 and append it to the row
                row_data.append(CellState(value, value, 0, color))
            data.append(row_data)

        return Self(rows, cols, data)

    @staticmethod
    fn random_color() -> String:
        color_index = random.random_si64(0, 15)
        if color_index == 0:
            return "azure"
        if color_index == 1:
            return "blue"
        if color_index == 2:
            return "brown"
        if color_index == 3:
            return "cyan"
        if color_index == 4:
            return "gold"
        if color_index == 5:
            return "gray"
        if color_index == 6:
            return "green3"
        if color_index == 7:
            return "indigo"
        if color_index == 8:
            return "khaki"
        if color_index == 9:
            return "limegreen"
        if color_index == 10:
            return "lightblue"
        if color_index == 11:
            return "magenta"
        if color_index == 12:
            return "yellow"
        if color_index == 13:
            return "orange"
        if color_index == 14:
            return "orangered"
        if color_index == 15:
            return "red"

        return "dodgerblue"


