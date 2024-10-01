# DEV 
Repository contains my docker development image. This Dockerfile is prepared to provide standard development env for usage.
To execute the same on windows
```
docker run -v C:/MYWORK:/opt/Kubernetes --privileged --rm -it singharunk/dev:latest
```

### Example Usage
To make sure you don’t need to set your Kubernetes configuration (kubeconfig) every day, you can mount your local kubeconfig file into the Docker container. By doing this, you ensure that your Kubernetes context and settings persist, and you'll be able to run kubectl commands without needing to reconfigure the environment every time.

Steps to Use Docker Container for Daily Tasks with Persistent kubeconfig
- On a Mac, the Kubernetes configuration file is typically located at: `~/.kube/config`
- Running the Docker Container with Mounted kubeconfig:

```
docker run -it --rm \
  -v ~/.kube/config:/root/.kube/config \
  singharunk/dev:latest \
  /bin/bash
```

or

- You could even create an alias in your shell (like ~/.bash_profile or ~/.zshrc) to make the command easier to run:
```
alias mydev='docker run -it --rm -v ~/.kube/config:/root/.kube/config singharunk/dev:latest /bin/bash'
```

- Running the Docker Container with Mounted folder:
```
docker run -it --rm -v /home/arun/myfolder:/root/myfolder singharunk/dev:latest /bin/bash
```