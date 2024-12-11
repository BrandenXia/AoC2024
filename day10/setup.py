from Cython.Build import cythonize
from setuptools import setup

setup(
    name='Advent of Code 2024 Day 10',
    ext_modules=cythonize('./*.pyx'),
)
