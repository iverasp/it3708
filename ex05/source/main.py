# Append the directory in which the binaries were placed to Python's sys.path,
# then import the D DLL.
libDir = os.path.join('build', 'lib.%s-%s' % (
    distutils.util.get_platform(),
    '.'.join(str(v) for v in sys.version_info[:2])
    ))
sys.path.append(os.path.abspath(libDir))

from dbindings import *

def main():
    config = EaConfig()
    population = Population(config)

    for _ in range(config.getGenerations):
        population.develop()
        population.evaluate()
        population.adultSelection()
        population.parentSelection()
        population.reproduce()

if __name__ == "__main__":
    main()
