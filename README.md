# docker-opentsdb

[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)]()

**Ready-to-run OpenTSDB image.**  


## Usage
To build image from Dockerfile:  
```
cd <path-to-Dockerfile> && docker build -t eacon/docker-opentsdb:latest .
```

To run image:  
```
docker run -d -p 4242:4242 --name opentsdb eacon/docker-opentsdb
```

Supported tags:  
- latest(default to 2.3)
- 2.3


## DockerHub
This image is published on docker hub([docker-opentsdb](https://hub.docker.com/r/eacon/docker-opentsdb/)), each push into this repo will trigger its automated build, so your Pull Requests are welcome!  
By default, the branch name would be image's tag(master would be "lastest").
