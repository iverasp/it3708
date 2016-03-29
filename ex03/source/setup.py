from pyd.support import Extension
from pyd.support import setup 

projName = 'dbindings'

setup(
    name=projName,
    version='0.2',
    ext_modules=[
        Extension(projName, ['DBindings.d', 'ea/config.d', 'ea/population.d', 'ea/individual.d', 'flatland/Agent.d', 'flatland/Simulator.d'],
            build_deimos=True,
            d_lump=True)
    ],
)
