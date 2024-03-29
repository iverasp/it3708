import pygame
from sys import exit, path, version_info
import distutils.util
from pygame.locals import *
from os.path import join, abspath
import numpy as np

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in version_info[:2])
))
path.append(abspath(libDir))
from dbindings import FlatlandAgent


class FlatlandGUI:

    # Delay between screen updates (ms)
    DELAY = 500

    # Set resources and map to cell integers
    TILESIZE = 80
    empty_tile = pygame.image.load(join('res', 'empty' + str(TILESIZE) + '.bmp'))
    food_tile = pygame.image.load(join('res', 'food' + str(TILESIZE) + '.bmp'))
    poison_tile = pygame.image.load(join('res', 'poison' + str(TILESIZE) + '.bmp'))
    agent_tile = pygame.image.load(join('res', 'agent' + str(TILESIZE) + '.bmp'))

    tilemap = {
        0: empty_tile,
        1: food_tile,
        2: poison_tile
    }

    # Keep track of our orientation and angle
    agent_angle = 0

    """
    Initialize GUI
    Cells is a 2D array containing integers [0, 3)
    denoting the content of a tile: 0 = blank, 1 = food, 2 = posion.
    Moves is an array of moves where 0 = forward, 1 = left, 2 = right.
    Start is a tuple of the starting coordinates for the agent.
    """
    def __init__(self, cells, start, moves):
        self.moves = moves
        self.cells = cells
        self.agent = FlatlandAgent(start[0], start[1])
        self.start = start

        self.mapsize = len(cells)
        self.move = 0

        self.food_eaten = 0
        self.poison_eaten = 0

        #self.ann = FlatlandANN()
        #self.ann.learn()

        pygame.init()
        self.display = pygame.display.set_mode((self.mapsize*self.TILESIZE, self.mapsize*self.TILESIZE))
        self.run()

    def run(self):
        clock = pygame.time.get_ticks()
        self.update()
        while self.move is not len(self.moves):
            self.listen()
            pygame.time.wait(5) # do not hog the CPU
            if clock + self.DELAY <= pygame.time.get_ticks():
                clock = pygame.time.get_ticks()
                self.update()

    def listen(self):
        for event in pygame.event.get():
            if event.type == QUIT:
                pygame.quit()
                exit()
            if event.type == KEYDOWN:
                if event.key == K_ESCAPE:
                    pygame.quit()
                    exit()
                if event.key == K_MINUS:
                    self.DELAY += 50
                    print("Delay set to:", self.DELAY)
                if event.key == K_PLUS:
                    self.DELAY -= 50
                    print("Delay set to:", self.DELAY)
                if event.key == K_w:
                    self.moves.append(0)
                if event.key == K_a:
                    self.moves.append(1)
                if event.key == K_d:
                    self.moves.append(2)
                if event.key == K_n:
                    self.move = len(self.moves)

    def update(self):
        # No more moves? Wait until user quits
        #self.moves.append(self.get_ann_move())
        if self.move == len(self.moves):
            return

        # Draw the map
        self.display.fill(Color('white'))
        for row in range(self.mapsize):
            for column in range(self.mapsize):
                self.display.blit(
                    self.tilemap[self.cells[row][column]],
                    pygame.rect.Rect(column*self.TILESIZE, row*self.TILESIZE, self.TILESIZE, self.TILESIZE)
                )

        #self.print_move()

        # Update angle of agent
        def update_angle(angle):
            self.agent_angle += angle
            self.agent_tile = pygame.transform.rotate(self.agent_tile, angle)

        if self.moves[self.move] == 1:
            update_angle(90)
            self.agent.turnLeft()

        elif self.moves[self.move] == 2:
            update_angle(-90)
            self.agent.turnRight()

        # Move forward and update cells
        self.cells = self.agent.moveForward(self.cells)

        # Draw the agent
        self.display.blit(
            self.agent_tile,
            pygame.rect.Rect(self.agent.getX() * self.TILESIZE, self.agent.getY() * self.TILESIZE, self.TILESIZE, self.TILESIZE)
        )

        pygame.display.flip()

        self.move += 1


    def print_move(self):
        output = [[0],[0],[0]]
        output[self.moves[self.move]][0] = 1
        print("ann.learn(" + str(self.sense()) + ", " + str(output) + ")")
