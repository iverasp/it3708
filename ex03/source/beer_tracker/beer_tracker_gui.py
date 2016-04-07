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

    def __init__(self, timesteps):
        self.WIDTH = 30
        self.HEIGHT = 15
        self.TILESIZE = 40
        self.agent = BeerTrackerAgent()
        self.agent_color = (255, 0, 0)
        self.object_color = (0, 0, 255)
        self.DELAY = 500

        self.sim = BeerTrackerSimulator(timesteps)

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

        # Draw the map
        self.display.fill(Color('white'))

        # Draw the objects
        obj = self.sim.getObject
        for x in range(obj.getX, obj.getX + obj.getSize):
            surface = Rect(
                x * self.TILESIZE,
                obj.getY * self.TILESIZE,
                self.TILESIZE,
                self.TILESIZE
            )
            pygame.draw.rect(
                self.display,
                self.object_color,
                surface,
                5
            )

        # Draw the agent with wrap-around
        for x in range(
            self.sim.getAgent.getX,
            self.sim.getAgent.getX + self.sim.getAgent.getSize
            ):

            surface = Rect(
                (x % 30) * self.TILESIZE,
                self.sim.getAgent.getY * self.TILESIZE,
                self.TILESIZE,
                self.TILESIZE
            )
            pygame.draw.rect(
                self.display,
                self.agent_color,
                surface,
                5
            )
        pygame.display.flip()

        self.sim.moveAgent(randint(0, 1), randint(1, 4))
        self.sim.descendObject()
