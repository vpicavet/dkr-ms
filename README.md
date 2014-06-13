A MapServer Docker setup
========================

Presentation
------------

This Docker image is a container with a MapServer Setup, featuring the MapServer suite.It is based on Ubuntu 14.04 and UbuntuGIS packages.

Build and/or run the container
------------------------------

Git clone this repository to get the Dockerfile, and cd to it.

You can build the image with :

```sh
sudo docker.io build -t oslandia/vws-ms .
```

Run the container with :

```sh
sudo docker.io run --rm -P --name vws-ms-test oslandia/vws-ms /sbin/my_init
```

Access the server
-----------------

Once the container run, you can access MapServer and MapCache services. You need to use docker ps to find out what local host port the container is mapped to first:

```sh
$ sudo docker.io ps
CONTAINER ID        IMAGE                    COMMAND             CREATED             STATUS              PORTS                   NAMES
a2d16f1a0540        oslandia/vws-ms:latest   /sbin/my_init       23 seconds ago      Up 22 seconds       0.0.0.0:49157->80/tcp   vws-ms-test
```

SSH connection
--------------

This is for a temporary connexion (insecure key). Start a container with --enable-insecure-key:

docker run -rm -P --name vws-ms-test oslandia/vws-ms /sbin/my_init --enable-insecure-key

Find out the ID of the container that you just ran:

docker ps

Once you have the ID, look for its IP address with:

docker inspect <ID> | grep IPAddress

Now SSH into the container as follows:

curl -o insecure_key -fSL https://github.com/phusion/baseimage-docker/raw/master/image/insecure_key
chmod 600 insecure_key
ssh -i insecure_key root@<IP address>

More info and secure connection : https://github.com/phusion/baseimage-docker



References
==========

Dockerfile reference :
http://docs.docker.io/reference/builder/

