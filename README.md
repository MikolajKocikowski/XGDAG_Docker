# XGDAG_Docker

XGDAG is a graph neural network tool for prioritizing disease-associated genes: [original repo](https://github.com/GiDeCarlo/XGDAG). While working with it during the [CeNT Bio-AI hackathon](https://github.com/SFGLab/Team1_Gene_Prioritization_GNN), we ran into environment issues that made it difficult to run across systems. To address this, I created a working Docker setup along with a couple of minimal fixes. 

The original hackathon repository is now archived in connection with the BioHackrXiv [preprint](https://osf.io/preprints/biohackrxiv/vbw4t_v1). Any further updates & fixes will be maintained here. Suggestions welcome! If this setup proves useful in your work, feel free to cite the preprint.

This repository includes:

- a `Dockerfile` (in two versions)
- instructions for building and using the container (see below)
<br>

## Choose one of the paths, weary wanderer:

- A - `Dockerfile_quick_2025-05-14` - has code mods integrated for speed, may stop working with future XGDAG releases.
- B - `Dockerfile` - clean docker, requires manual changes to the XGDAG code (as accessed on 2025-05-14), all detailed below.
<br>

## A - Instructions for Dockerfile_quick_2025-05-14

1. Download the XGDAG repository
```bash
mkdir test
cd test
git clone https://github.com/GiDeCarlo/XGDAG
```

2. Create `Dockerfile` in the same dir, with content identical to `Dockerfile_quick_2025-05-14` and save
```bash
nano Dockerfile
```

3. Build the Docker image
```bash
docker build -t xgdag_test .
```

4. Run a Docker container
```bash
docker run -it xgdag_test
```

5. Test if XGDAG works (and stop it)
```bash
python TrainerScript.py
```
<br>

## B - Instructions for Dockerfile

1. Download the XGDAG repository
   
```bash
mkdir test
cd test
git clone https://github.com/GiDeCarlo/XGDAG
```

2. Modify the XGDAG codebase before it is copied into the container

#### Add a missing __init__.py file
```bash
touch XGDAG/SubgraphX/__init__.py
```
#### Fix relative import in SubgraphX.py
```bash
sed -i 's/from SubgraphXshapley/from .SubgraphXshapley/' XGDAG/SubgraphX/SubgraphX.py
```
3. Create a docker file with content identical to `Dockerfile` and save
```bash
nano Dockerfile
```

4. Build the Docker image
```bash
docker build -t xgdag_test .
```

5. Run a Docker container
```bash
docker run -it xgdag_test
```

6. Test if XGDAG works (and stop it)
```bash
python TrainerScript.py
```
<br>

## Further analysis

These instructions should yield a functional Docker image (which can also be exported as a portable container) and make the scripts run correctly. However, there remain issues with running specific datasets (also ones from the original XGDAG paper). This makes replicating the analysis or conducting it with new dataset challenging until more documentation is available - please consult the issues in the original XGDAG repository for discussion and potential solutions. 

As currently understood, the tool requires several input files:

- a .gml interactome - can be converted from .sif with the script below (to get it, Reactome, Biogrid and [this repo](https://github.com/jjjk123/GBA-centrality) may be useful)
- multiple .txt files containing disease genes, scores, and rankings. They [appear to](https://github.com/GiDeCarlo/XGDAG/issues/1) be generated with a separate tool: [NIAPU](https://github.com/AndMastro/NIAPU/?tab=readme-ov-file).

```python
# Python script to convert .sif to .gml
# Usage: python convert_sif_to_gml.py mynetwork.sif

import os
import sys

import networkx

IN_FILE = sys.argv[1]
OUT_FILE = os.path.splitext(IN_FILE)[0] + "." + "gml"

def read_sif(file_path):
    G = networkx.Graph()
    with open(file_path) as f:
        for line in f:
            parts = line.strip().split()
            if len(parts) == 3:
                node1, interaction, node2 = parts
                G.add_edge(node1, node2, interaction=interaction)
            elif len(parts) == 2:
                node1, node2 = parts
                G.add_edge(node1, node2)
            elif len(parts) == 1:
                G.add_node(parts[0])
    return G

def convert_sif_to_gml(sif_path, gml_path):
    G = read_sif(sif_path)
    networkx.write_gml(G, gml_path)
    print(f"GML file saved to: {gml_path}")

convert_sif_to_gml(IN_FILE, OUT_FILE)

```

## Badges

![Docker](https://img.shields.io/badge/docker-ready-blue)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/MikolajKocikowski/XGDAG_Docker)](https://github.com/yourusername/xgdag_docker/commits/main)


