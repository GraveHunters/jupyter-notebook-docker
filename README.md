# Customizable Jupyter Notebook Docker

## To Build Docker Image

In its simplest form, this will build a Jupyter Notebook that can run the Python Standard Library. To build this image, change directory to the same directory as the Docker file, and enter the build command on your command line 

```bash
docker build -t jupyter --build-arg HOST_USER=$(id -u) --build-arg HOST_GROUP=$(id -g) .
```

This image makes it easy to include additional Python libraries that can be installed using [pip](https://pypi.org/). Simply include a comma-separated list of packages that you wish to install using the `PIPS` build argument. For instance, if you wanted to include `pillow` in your notebook, you could build with the command below.

```bash
docker build --no-cache -t jupyter:pillow --build-arg PIPS=pillow --build-arg HOST_USER=$(id -u) --build-arg HOST_GROUP=$(id -g) .
```

Functionality associated with some Python libraries relies on underlying programs installed in your OS. These can be included as a comma-separated list of programs you wish to install using the `APKS` build argument. For instance, if you wanted to install gnupg and a Python library to work with gnupg, you could use the build command below.

```bash
docker build --no-cache -t jupyter:gpg --build-arg PIPS=python-gnupg,pillow --build-arg APKS=gnupg --build-arg HOST_USER=$(id -u) --build-arg HOST_GROUP=$(id -g) .
```

## To Run Docker Image

Once you've built the Docker image, you can run it with the command below:

```bash
docker run -it --rm -v "$PWD:/notebooks" -p 8889:8888 jupyter:your-tag
```

Your notebooks would then be saved in whatever directory you executed that command from, and the notebook will be accessible in any browser at `http://localhost:8889`