from pyd.support import Extension
from pyd.support import setup
from pyd import patch_distutils
from sys import argv

argv.append("build")
argv.append("-c")
argv.append("ldc2")
argv.append("-O")

projName = 'dbindings'
sources = ['dbindings.d',
'ea/ea_config.d',
'ea/population.d',
'ea/individual.d',
'flatland/flatland_agent.d',
'flatland/flatland_simulator.d',
'ann/ann.d',
'ann/matrix.d',
'beer_tracker/beer_tracker_agent.d',
'beer_tracker/beer_tracker_object.d',
'beer_tracker/beer_tracker_simulator.d',
'ann/ann_config.d']

setup(
    name=projName,
    version='0.2',
    ext_modules=[
        Extension(projName, sources,
            build_deimos=True,
            d_lump=True)
    ],
)
