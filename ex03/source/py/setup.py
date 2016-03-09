from pyd.support import setup, Extension

projName = 'population'

setup(
    name=projName,
    version='0.1',
    ext_modules=[
        Extension(projName, ['../Population.d', '../Individual.d'],
            build_deimos=True,
            d_lump=True)
    ],
)
