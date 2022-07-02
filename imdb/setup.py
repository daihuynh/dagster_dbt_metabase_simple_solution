import setuptools

setuptools.setup(
    name="imdb",
    packages=setuptools.find_packages(exclude=["imdb_tests"]),
    install_requires=[
        "dagster==0.14.19",
        "dagit==0.14.19",
        "pytest",
    ],
)
