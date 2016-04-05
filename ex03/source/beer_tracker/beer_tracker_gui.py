import pygame
from pygame.locals import *
from sys import exit, path, version_info
import distutils.util
from os.path import join, abspath
from random import randint, choice

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in version_info[:2])
))
path.append(abspath(libDir))
from dbindings import BeerTrackerAgent, BeerTrackerObject, BeerTrackerSimulator


class BeerTrackerGUI:

    def __init__(self, number_of_objects):
        self.WIDTH = 30
        self.HEIGHT = 15
        self.TILESIZE = 40
        self.agent = BeerTrackerAgent()
        self.agent_color = (255, 0, 0)
        self.object_color = (0, 0, 255)
        self.move = 0
        self.moves = [1,1,1,1]
        self.DELAY = 0

        self.sim = BeerTrackerSimulator(4)

        pygame.init()
        self.display = pygame.display.set_mode((self.WIDTH*self.TILESIZE, self.HEIGHT*self.TILESIZE))
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
                if event.key == K_w:
                    self.moves.append(0)
                if event.key == K_a:
                    self.moves.append(1)
                if event.key == K_d:
                    self.moves.append(2)

    def update(self):
        # No more moves? Wait until user quits
        #self.moves.append(self.get_ann_move())
        #if self.move == len(self.moves):
        #    return

        # Draw the map
        self.display.fill(Color('white'))

        for obj in self.sim.getObjects:
            surface = Rect(
                obj.getX * self.TILESIZE,
                obj.getY * self.TILESIZE,
                self.TILESIZE * obj.getSize,
                self.TILESIZE
            )
            pygame.draw.rect(
                self.display,
                self.object_color,
                surface,
                5
            )

        """
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

        """
        pygame.display.flip()

        self.sim.descendObjects()
        self.move += 1
