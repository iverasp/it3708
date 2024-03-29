from pyd.support import Extension
from pyd.support import setup
from pyd import patch_distutils
from sys import argv

if argv[-1] == "opt":
    print("building with optimalization")
    argv.pop()
    argv.append("build")
    argv.append("-c")
    argv.append("ldc2")
    argv.append("-O")

else: argv.append("build")



projName = 'dbindings'
sources = ['dbindings.d',
'ea/ea_config.d',
'ea/population.d',
'ea/individual.d',
'ea/beer_tracker_individual.d',
'ea/beer_tracker_population.d',
'flatland/flatland_agent.d',
'flatland/flatland_simulator.d',
'flatland/flatland_evolve.d',
'ann/ann.d',
'ann/matrix.d',
'ann/ann_config.d',
'ann/ctrnn.d',
'beer_tracker/beer_tracker_agent.d',
'beer_tracker/beer_tracker_object.d',
'beer_tracker/beer_tracker_simulator.d',
'beer_tracker/beer_tracker_evolve.d']

setup(
    name=projName,
    version='0.2',
    ext_modules=[
        Extension(projName, sources,
            build_deimos=True,
            d_lump=True)
    ],
)
