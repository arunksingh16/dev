FROM ubuntu:20.10

# Installing required packages
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
    gnupg \
    build-essential \
    vim \
    git \
    nmap \
    curl \
    cmake \
    wget \
    sudo \
    iputils-ping \
    ssh \
    ansible \
    netcat \
    python-dev \
    python-setuptools \
    python3-pip \
    unzip \
    jq \
    tree \
    maven \
    locate \
    rsync \
    bash-completion \
    apt-transport-https \
    dnsutils \
    software-properties-common \
    ca-certificates \
    zsh \
    fonts-powerline \
    nodejs \
    npm \ 
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# Installaing Docker CLI
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get -y update && apt-get install -y docker-ce-cli

# Installing Additional PIP based libraries
RUN pip install awscli \
    six \
    docker \
    httpie \
    python-bash-utils \
    pywinrm \
    xmltodict \
    pyOpenSSL==16.2.0 

# Installing + Setting Up GO Environment
ENV GOLANG_VERSION 1.15.2
ENV GOLANG_DOWNLOAD_URL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_SHA256 b49fda1ca29a1946d6bb2a5a6982cf07ccd2aba849289508ee0f9918f6bb4552
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
	&& echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
	&& sudo tar -C /usr/local -xzf golang.tar.gz \
	&& rm golang.tar.gz

# Setting up GOPATH. For me, i'm using $HOME/code/go
ENV HOME /root
ENV GOPATH $HOME/code/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

# Installing HashiCorp Stack
# Installing Terraform 
ENV TERRAFORM_VERSION 0.14.5
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip
RUN unzip terraform.zip  -d /usr/local/bin  
RUN rm terraform.zip

# Installing Vault
ENV VAULT_VERSION 1.6.2
RUN curl https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -o vault.zip
RUN unzip vault.zip  -d /usr/local/bin  
RUN rm vault.zip

# Installing ccat (https://github.com/jingweno/ccat)
RUN go get -u github.com/jingweno/ccat

# Installing gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

# Kubernetes Tools : kubectl, kubectx, and kubens
ENV KUBECTL_VER 1.19.2
RUN wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx -O /usr/local/bin/kubectx && chmod +x /usr/local/bin/kubectx
RUN wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens -O /usr/local/bin/kubens && chmod +x /usr/local/bin/kubens
RUN wget https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VER/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

# Installing Helm
ENV HELM_VERSION 3.5.0
RUN wget https://get.helm.sh/helm-v$HELM_VERSION-linux-amd64.tar.gz -O /tmp/helm-v$HELM_VERSION-linux-amd64.tar.gz && \
    tar -zxvf /tmp/helm-v$HELM_VERSION-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm

# Setting WORKDIR and USER 
ARG OC_VERSION=4.5
RUN curl -sLo /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v$(echo $OC_VERSION | cut -d'.' -f 1)/clients/oc/$OC_VERSION/linux/oc.tar.gz && \
    tar xzvf /tmp/oc.tar.gz -C /tmp/ && \
    mv /tmp/oc /usr/local/bin/ && \
    rm -rf /tmp/oc.tar.gz && \
    rm -rf /tmp/kubectl

ENV KUSTOMIZE_VERSION 3.9.3
RUN curl -sLo /tmp/kustomize.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \    
    tar xzvf /tmp/kustomize.tar.gz -C /usr/local/bin/ && \
    rm -rf /tmp/kustomize.tar.gz

USER root
WORKDIR /root
CMD ["bash"]
