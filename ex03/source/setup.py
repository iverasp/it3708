from pyd.support import Extension
from pyd.support import setup

projName = 'dbindings'

setup(
    name=projName,
    version='0.2',
    ext_modules=[
        Extension(projName, ['dbindings.d', 'ea/config.d', 'ea/population.d', 'ea/individual.d', 'flatland/agent.d', 'flatland/simulator.d', 'ann/ann.d', 'ann/matrix.d'],
            build_deimos=True,
            d_lump=True)
    ],
)
