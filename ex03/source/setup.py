from pyd.support import Extension
from pyd.support import setup 

projName = 'population'

setup(
    name=projName,
    version='0.2',
    ext_modules=[
        Extension(projName, ['ea/population.d', 'ea/individual.d', 'ea/config.d'],
            build_deimos=True,
            d_lump=True)
    ],
)
