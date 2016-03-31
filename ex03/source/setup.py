from pyd.support import Extension
from pyd.support import setup
from pyd import patch_distutils
from sys import argv

#argv.append("-c")
#argv.append("ldc2")
#argv.append("-O")

projName = 'dbindings'
sources = ['dbindings.d',
'ea/config.d',
'ea/population.d',
'ea/individual.d',
'flatland/agent.d',
'flatland/simulator.d',
'ann/ann.d',
'ann/matrix.d']

setup(
    name=projName,
    version='0.2',
    ext_modules=[
        Extension(projName, sources,
            build_deimos=True,
            d_lump=True)
    ],
)
