# Use Ubuntu as the base image
FROM ubuntu:22.04

# Set environment variables
ENV TERRAFORM_VERSION=1.5.6
ENV HELM_VERSION=v3.13.0
ENV KUBECTL_VERSION=v1.28.0

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    gnupg2 \
    lsb-release \
    ca-certificates \
    git \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install Helm
RUN curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -rf helm-${HELM_VERSION}-linux-amd64.tar.gz linux-amd64

# Set the entrypoint to bash for interactive shell
ENTRYPOINT [ "/bin/bash", "-l", "-c" ]

CMD ["/bin/bash"]
