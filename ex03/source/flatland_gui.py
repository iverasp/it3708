import pygame
from sys import exit
from pygame.locals import *
from os.path import join
import numpy as np


class FlatlandGUI:

    # Delay between screen updates (ms)
    DELAY = 1500

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

    movemap = {
        1: (1, 0),
        2: (0, -1),
        3: (-1, 0),
        0: (0, 1)
    }

    """
    Initialize GUI
    Cells is a 2D array containing integers [0, 3)
    denoting the content of a tile: 0 = blank, 1 = food, 2 = posion.
    Moves is an array of moves where 0 = forward, 1 = right, 2 = left.
    Start is a tuple of the starting cordinates for the agent.
    """
    def __init__(self, cells, start, moves):
        self.moves = moves
        self.cells = cells
        self.agent_pos = start

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

        # Make angles wrap around 360 degrees
        def update_angle(angle):
            if self.agent_angle + angle > 360:
                self.agent_angle = self.agent_angle + angle - 360
            elif self.agent_angle + angle < 0:
                self.agent_angle = self.agent_angle + angle + 360
            else: self.agent_angle = self.agent_angle + angle

        def move_forward():
            direction = int((self.agent_angle / 360) * 4)
            if direction == 4: direction = 0
            self.agent_pos = tuple(
                np.subtract(self.agent_pos, self.movemap[direction])
            )

            # Wrap-around world
            if self.agent_pos[0] < 0: self.agent_pos = (self.mapsize - 1, self.agent_pos[1])
            elif self.agent_pos[0] > self.mapsize - 1: self.agent_pos = (0, self.agent_pos[1])
            elif self.agent_pos[1] < 0: self.agent_pos = (self.agent_pos[0], self.mapsize - 1)
            elif self.agent_pos[1] > self.mapsize - 1: self.agent_pos = (self.agent_pos[0], 0)

        # Find next position for agent and rotate
        # Forward
        if self.moves[self.move] == 0:
            move_forward()

        # Right
        elif self.moves[self.move] == 1:
            update_angle(-90)
            self.agent_tile = pygame.transform.rotate(self.agent_tile, -90)
            move_forward()

        # Left
        elif self.moves[self.move] == 2:
            update_angle(+90)
            self.agent_tile = pygame.transform.rotate(self.agent_tile, +90)
            move_forward()

        # Draw the agent
        self.display.blit(
            self.agent_tile,
            pygame.rect.Rect(self.agent_pos[0] * self.TILESIZE, self.agent_pos[1] * self.TILESIZE, self.TILESIZE, self.TILESIZE)
        )

        pygame.display.flip()

        # Check if agent ate something
        self.remove_item(self.agent_pos)

        self.move += 1

    def remove_item(self, position):
        item = self.cells[position[1]][position[0]]
        if item == 0: return
        if item == 1:
            self.food_eaten += 1
            print(self.food_eaten, "foods eaten")
        if item == 2:
            self.poison_eaten += 1
            print(self.poison_eaten, "poisons eaten")
        self.cells[position[1]][position[0]] = 0
