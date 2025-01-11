import random

@value
struct Grid(StringableRaising):
    var rows: Int
    var cols: Int
    var data: List[List[Int]]

    def __str__(self) -> String:
        # Create an empty String
        str = String()

        # Iterate through rows 0 through rows-1
        for row in range(self.rows):
            # Iterate through columns 0 through cols-1
            for col in range(self.cols):
                if self[row, col] == 1:
                    str += "*"  # If cell is populated, append an asterisk
                else:
                    str += " "  # If cell is not populated, append a space
            if row != self.rows-1:
                str += "\n"     # Add a newline between rows, but not at the end
        return str

    def __getitem__ (self, row: Int, col: Int) -> Int:
        return self.data[row][col]

    def __setitem__ (mut self, row: Int, col: Int, value: Int) -> None:
        self.data[row][col] = value
    
    # def evolve(self) -> Self:
    #     next_generation = List[List[Int]]()

    #     for row in range(self.rows):
    #         row_data = List[Int]()

    #         # Calc the neighboring row indices, make sure to handle "wrap-around"

    @staticmethod
    def random(rows: Int, cols: Int) -> Self:
        # Seed the random number generator using the current time
        random.seed()

        data = List[List[Int]]()

        for row in range(rows):
            row_data = List[Int]()
            for col in range(cols):
                # Generate a random 0 or 1 and append it to the row
                row_data.append(int(random.random_si64(0, 1)))
            data.append(row_data)

        return Self(rows, cols, data)