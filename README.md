### Resources
- [Docker Hub repository](https://registry.hub.docker.com/u/kalaksi/airsonic/)
- [GitHub repository](https://github.com/kalaksi/docker-airsonic)
- [Airsonic documentation](https://airsonic.github.io/docs)
- [ArchWiki documentation about Subsonic](https://wiki.archlinux.org/index.php/Subsonic)

### Why use this container?
**Simply put, this container has been written with simplicity and security in mind.**

Surprisingly, _many_ community containers run unnecessarily with root privileges by default and don't provide help for dropping unneeded CAPabilities.
Additionally, overly complex shell scripts and unofficial base images make it harder to verify the source.

To remedy the situation, these images have been written with security and simplicity in mind. See [Design Goals](#design-goals) further down.

### Supported tags
See the ```Tags``` tab on Docker Hub for specifics. Basically you have:
- The default ```latest``` tag that always has the latest changes.
- Minor versioned tags (follow Semantic Versioning), e.g. ```1.0``` which would follow branch ```1.0.x``` on GitHub.

### Configuration
There are 2 environment variables for changing the configuration of this container:
- ```AIRSONIC_CONTEXT_PATH``` sets the context path for reverse proxying. For example, the value could be ```/airsonic```.
- ```AIRSONIC_JAVA_OPTS``` lets you define arbitrary options for Java. Multiple options should be separated by space like so: ```-Dserver.port=8080 -Dserver.address=127.0.0.1```

These are the volumes you should mount:
- The ```/media``` path should contain the media library that you wish to use. Can be read-only.
- The ```/var/airsonic``` path should contain the persistent data that Airsonic will use. **Note:** if you're using bind-mounts, the source directory may not have the correct owner, so see that it's writable by airsonic (UID 163769 and GID 163769). Named volumes (like the one in ```docker-compose.yml```) should work fine.

As usual, check the ```docker-compose.yml``` file to see specifics on how to run this container.
You can customize the application further by modifying the ```airsonic.properties``` (or use the Web UI) after it's been created.

#### Using SSL/TLS
Airsonic doesn't support SSL/TLS directly. It is recommended to use a reverse proxy for that purpose.
See Airsonic's documentation for more information on how to achieve that.

### Development
#### Design Goals
- Never run as root unless necessary.
- Use only official base images.
- Provide an example ```docker-compose.yml``` that also shows what CAPabilities can be dropped.
- Offer versioned tags for stability.
- Try to keep everything in the Dockerfile (if reasonable, considering line count and readability).
- Don't restrict configuration possibilities: provide a way to use native config files for the containerized application.
- Handle signals properly.


#### Contributing
See the repository on <https://github.com/kalaksi/docker-airsonic>.
All kinds of contributions are welcome!

### License
View [license information](https://github.com/kalaksi/docker-airsonic/blob/master/LICENSE) for the software contained in this image.
As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.