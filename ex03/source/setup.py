from pyd.support import setup, Extension

projName = 'dbindings'

setup(
    name=projName,
    version='0.1',
    ext_modules=[
        Extension(projName, ['DBindings.d', 'ea/Population.d', 'ea/Individual.d', 'flatland/Agent.d', 'flatland/Simulator.d'],
            build_deimos=True,
            d_lump=True)
    ],
)
