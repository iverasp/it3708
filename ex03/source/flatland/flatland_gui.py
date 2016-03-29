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
from bindings import Agent


class FlatlandGUI:

    # Delay between screen updates (ms)
    DELAY = 250

    # Set resources and map to cell integers
    TILESIZE = 80
    empty_tile = pygame.image.load(join('res', 'empty' + str(TILESIZE) + '.png'))
    food_tile = pygame.image.load(join('res', 'food' + str(TILESIZE) + '.png'))
    poison_tile = pygame.image.load(join('res', 'poison' + str(TILESIZE) + '.png'))
    agent_tile = pygame.image.load(join('res', 'agent' + str(TILESIZE) + '.png'))

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
    Moves is an array of moves where 0 = forward, 1 = right, 2 = left.
    Start is a tuple of the starting coordinates for the agent.
    """
    def __init__(self, cells, start, moves):
        self.moves = moves
        self.cells = cells.tolist()
        self.agent = Agent(start[0], start[1])

        self.mapsize = len(cells)
        self.move = 0

        self.food_eaten = 0
        self.poison_eaten = 0

        pygame.init()
        self.display = pygame.display.set_mode((self.mapsize*self.TILESIZE, self.mapsize*self.TILESIZE))
        self.run()

    def run(self):
        clock = pygame.time.get_ticks()
        self.update()
        while True:
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

    def update(self):
        # No more moves? Wait until user quits
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

        # Update angle of agent
        def update_angle(angle):
            self.agent_angle += angle
            self.agent_tile = pygame.transform.rotate(self.agent_tile, angle)

        if self.moves[self.move] == 1:
            update_angle(-90)
            self.agent.turnRight()

        elif self.moves[self.move] == 2:
            update_angle(+90)
            self.agent.turnLeft()

        # Move forward and update cells
        self.cells = self.agent.moveForward(self.cells)

        # Draw the agent
        self.display.blit(
            self.agent_tile,
            pygame.rect.Rect(self.agent.getX() * self.TILESIZE, self.agent.getY() * self.TILESIZE, self.TILESIZE, self.TILESIZE)
        )

        pygame.display.flip()

        self.move += 1
