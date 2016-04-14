import pygame
from pygame.locals import *
from sys import exit, path, version_info
import distutils.util
from os.path import join, abspath
from random import randint, choice
import curses

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in version_info[:2])
))
path.append(abspath(libDir))
from dbindings import *


class BeerTrackerGUI:

    def __init__(self, config, phenotype):
        self.WIDTH = 30
        self.HEIGHT = 15
        self.TILESIZE = 40
        self.agent = BeerTrackerAgent()
        self.agent_color = (255, 0, 0)
        self.big_object_color = (0, 0, 255)
        self.small_object_color = (0, 255, 0)
        self.DELAY = 500
        self.config = config
        self.sim = BeerTrackerSimulator(config)
        ann_config = AnnConfig()
        self.ann = CTRNN(ann_config, config)
        self.ann.loadPhenotype(phenotype)

        #self.report_stuff(phenotype)

        self.stdscr = curses.initscr()
        curses.noecho()
        curses.cbreak()

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
                self.iterateSim()
                self.update()

    def report_stuff(self, phenotype):
        print(phenotype)
        test1 = [0,0,0,1,1]
        test2 = [0,0,1,1,0]
        test3 = [0,1,1,1,1]
        test4 = [1,1,1,1,1]
        test5 = [1,1,1,1,1]
        test6 = [1,1,1,1,1]
        test7 = [1,1,1,1,1]

        print(self.ann.predict(test1))
        print(self.ann.predict(test2))
        print(self.ann.predict(test3))
        print(self.ann.predict(test4))
        print(self.ann.predict(test5))
        print(self.ann.predict(test6))
        print(self.ann.predict(test7))

        pygame.quit()
        exit()

    def flash_agent(self):
        self.agent_color = (0, 255, 255)
        self.update()
        pygame.time.wait(100)
        self.agent_color = (255, 0, 0)
        self.update()

    def iterateSim(self):
        inputs = self.sim.getSensors()
        move = self.ann.getMove(inputs)
        if self.config.isPullMode and move[1] == 0:
            self.flash_agent()
        self.sim.moveAgent(move[0], move[1])
        """
        print("\nAvoided big objects (+): ", self.sim.getAvoidedBigObjects, end="\r")
        print("Avoided small objects (-): ", self.sim.getAvoidedSmallObjects, end="\r")
        print("Captured big objects (-): ", self.sim.getCapturedBigObjects, end="\r")
        print("Captured small objects (+): ", self.sim.getCapturedSmallObjects, end="\r")
        """
        self.report(self.sim.getAvoidedBigObjects, self.sim.getAvoidedSmallObjects, self.sim.getCapturedBigObjects, self.sim.getCapturedSmallObjects)

    def report(self, a, b, c, d):
        self.stdscr.addstr(0, 0, "Avoided big objects: {0}".format(a))
        self.stdscr.addstr(1, 0, "Avoided small objects: {0}".format(b))
        self.stdscr.addstr(2, 0, "Catpured big objects: {0}".format(c))
        self.stdscr.addstr(3, 0, "Captured small objects: {0}".format(d))
        self.stdscr.addstr(4, 0, "Delay: {0} ms".format(self.DELAY))

        self.stdscr.refresh()

    def listen(self):
        for event in pygame.event.get():
            if event.type == QUIT:
                curses.echo()
                curses.nocbreak()
                curses.endwin()
                pygame.quit()
                exit()
            if event.type == KEYDOWN:
                if event.key == K_ESCAPE:
                    curses.echo()
                    curses.nocbreak()
                    curses.endwin()
                    pygame.quit()
                    exit()
                if event.key == K_MINUS:
                    self.DELAY += 50
                    #print("Delay set to:", self.DELAY)
                if event.key == K_PLUS:
                    self.DELAY -= 50
                    #print("Delay set to:", self.DELAY)
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
        object_color = self.small_object_color if obj.getSize < 5 else self.big_object_color
        for x in range(obj.getX, obj.getX + obj.getSize):
            surface = Rect(
                x * self.TILESIZE,
                obj.getY * self.TILESIZE,
                self.TILESIZE,
                self.TILESIZE
            )
            pygame.draw.rect(
                self.display,
                object_color,
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
