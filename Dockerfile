# Dockerfile

# The first instruction is what image we want to base our container on
# We Use an official Python runtime as a parent image
FROM python:3.8

# Allows docker to cache installed dependencies between builds
RUN apt-get update && apt-get install -y gcc make cmake g++ zlib1g-dev gfortran libopenblas-dev liblapack-dev build-essential
RUN pip3 install --upgrade pip setuptools wheel
COPY ./api/requirements.txt ./django_api/requirements.txt
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir -r ./django_api/requirements.txt

# Mounts the application code to the image
COPY ./api django_api
WORKDIR /django_api

RUN ./setup.sh
RUN python3 manage.py migrate

EXPOSE 8000

# runs the production server
ENTRYPOINT ["python", "./manage.py"]
CMD ["runserver", "0.0.0.0:8000"]