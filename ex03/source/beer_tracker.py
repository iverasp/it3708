from beer_tracker.beer_tracker_gui import BeerTrackerGUI
import distutils.util
import os.path
import sys
from random import randint

# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
    ))
sys.path.append(os.path.abspath(libDir))

from dbindings import *

#beer = BeerTrackerGUI(4)

for i in range(100):
    sim = BeerTrackerSimulator(4, 600);
    while not sim.completed():
        sim.moveAgent(randint(0,1), randint(1,4))
        sim.descendObjects()
    print("Simulation:", i+1)
    print("Small objects captured:", sim.getCapturedSmallObjects)
    print("Big objects captured:", sim.getCapturedBigObjects)
    print("Avoided objects:", sim.getAvoidedObjects)
