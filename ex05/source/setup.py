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
'tsp/tsp.d']

setup(
    name=projName,
    version='0.1',
    ext_modules=[
        Extension(projName, sources,
            build_deimos=True,
            d_lump=True)
    ],
)
