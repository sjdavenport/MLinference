from distutils import sysconfig
from setuptools import setup, Extension, find_packages
import os
import sys
import setuptools
from copy import deepcopy

with open("README.md", "r") as fh:
    long_description = fh.read()

setup(
    name='MLinference',
    install_requires=[
        'numpy',
        'sanssouci',
        'matplotlib',
        'sklearn',
        'scipy',
        'scikit-image',
        'nilearn'
    ],
    version = '0.1',
    license='SJD',
    author='Samuel DAVENPORT',
    download_url='https://github.com/sjdavenport/MLinference/',
    author_email='samuel.davenport@math.univ-toulouse.fr',
    url='https://github.com/sjdavenport/MLinference/',
    long_description=long_description,
    description='Python package for performing inference in machine learning models',
    keywords='Conformal Inference',
    packages=find_packages(),
    python_requires='>=3',
)
