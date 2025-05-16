FROM ubuntu:22.04

# Set noninteractive mode to avoid tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system packages
RUN apt-get update && apt-get install -y \
    wget git curl build-essential cmake \
    python3.10 python3.10-venv python3.10-dev python3-pip \
    && apt-get clean

# Set Python 3.10 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Create working directory
WORKDIR /workspace

# Copy the XGDAG codebase into the container
COPY XGDAG /workspace/XGDAG

# Modify the forked XGDAG contents
RUN touch /workspace/XGDAG/SubgraphX/__init__.py

# Modify the code
RUN sed -i 's/from SubgraphXshapley/from .SubgraphXshapley/' /workspace/XGDAG/SubgraphX/SubgraphX.py


# Create venv and activate it
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install PyTorch 1.12 and PyTorch Geometric 2.1
RUN pip install --upgrade pip
RUN pip install torch==1.12.0 torchvision==0.13.0 torchaudio==0.12.0 \
    --extra-index-url https://download.pytorch.org/whl/cpu

# torch-scatter
RUN pip install https://data.pyg.org/whl/torch-1.12.0+cpu/torch_scatter-2.1.0+pt112cpu-cp310-cp310-linux_x86_64.whl

# torch-sparse
RUN pip install https://data.pyg.org/whl/torch-1.12.0+cpu/torch_sparse-0.6.16+pt112cpu-cp310-cp310-linux_x86_64.whl

# torch-cluster
RUN pip install https://data.pyg.org/whl/torch-1.12.0+cpu/torch_cluster-1.6.0+pt112cpu-cp310-cp310-linux_x86_64.whl

# torch-spline-conv
RUN pip install https://data.pyg.org/whl/torch-1.12.0+cpu/torch_spline_conv-1.2.1+pt112cpu-cp310-cp310-linux_x86_64.whl


# Install Torch geometric    
RUN pip install torch-geometric==2.1.0 -f https://data.pyg.org/whl/torch-1.12.0+cpu.html

# Install other needed Python packages
RUN pip install \
    numpy==1.22.3 \
    pandas==1.4.3 \
    scipy==1.8.1 \
    scikit-learn==1.0.2 \
    seaborn==0.11.2 \
    matplotlib==3.5.2 \
    networkx==2.7.1 \
    tqdm==4.64.0 \
    jupyterlab \
    ipykernel \
    yacs \
    pyyaml


# Added, might not work
RUN pip install rdkit-pypi


# Set entrypoint (default shell, so XGDAG commands need prefacing with 'python')
WORKDIR /workspace/XGDAG
ENTRYPOINT ["bash"]
