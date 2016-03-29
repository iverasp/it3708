from pyd.support import setup, Extension

projName = 'bindings'

setup(
    name=projName,
    version='0.1',
    ext_modules=[
        Extension(projName, ['Bindings.d', 'ea/Population.d', 'ea/Individual.d', 'flatland/Agent.d'],
            build_deimos=True,
            d_lump=True)
    ],
)
