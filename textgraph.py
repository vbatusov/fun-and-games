import math

def graph(fu, scale=1.0, h0=-40, h1=40, v0=-20, v1=20):
    """ Graph an arbitrary function fu in a text terminal. Just for fun. """

    y = [round(scale * fu(x / scale)) for x in range(h0, h1 + 1)]

    for j in range(v1, v0 - 1, -1): # 15, 14, ..., -15
        line = ""
        for i in range(h0, h1 + 1):  # -50, -49, ..., 50
            i_z0 = i - h0  # 0, 1, ..., 100
            symbol = " "
            if y[i_z0] == j:
                symbol = "*"
            elif j == 0 and i == 0:
                symbol = "0"
            elif j == 0:
                symbol = "-"
            elif i == 0:
                symbol = "|"
            line += symbol
        print(line)

if __name__ == "__main__":
    graph(lambda x: ((x**2/80 - 10) + 5*math.sin(x/5))/2 - 10, scale=0.4, h0=-30, h1=30, v0=-10, v1=5)

# >>> graph.graph(lambda x: ((x**2/80 - 10) + 5*math.sin(x/5))/2 - 10, 0.7)
#                                                   |
#                                                   |                                                 *
#                                                   |                                                *
#                                                   |                                               *
#                                                   |                                              *
# *                                                 |
#  *                                                |                                             *
#   **                                              |                                            *
#     ***                                           |                                           *
#        ***                                        |                                          *
#           **                                      |
#             *                                     |                                         *
#              *                                    |                                        *
#               *                                   |                                       *
#                *                                  |                                     **
# ----------------*---------------------------------0-----------------------------------**-------------
#                  *                                |                            *******
#                   *                               |                          **
#                    *                              |                         *
#                     *                             |                       **
#                      **                           |                      *
#                        ************               |                     *
#                                    **             |                    *
#                                      *            |     **            *
#                                       **          |  ***  ****      **
#                                         *         ***         ******
#                                          **     **|
#                                            *****  |
#                                                   |
#                                                   |
#                                                   |
