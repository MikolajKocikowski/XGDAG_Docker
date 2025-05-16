# XGDAG_Docker

XGDAG is a graph neural network tool for prioritizing disease-associated genes: [original repo](https://github.com/GiDeCarlo/XGDAG). While working with it during the [CeNT Bio-AI hackathon](https://github.com/SFGLab/Team1_Gene_Prioritization_GNN), we ran into environment issues that made it difficult to run across systems. To address this, I created a working Docker setup along with a couple of minimal fixes. 

The original hackathon repository is now archived in connection with an upcoming BioHackrXiv preprint. Any further updates & fixes will be maintained here. Suggestions welcome! If this setup proves useful in your work, feel free to cite the preprint (link to follow). This repository includes:

- a `Dockerfile` (in two versions)
- instructions for building and using the container (see below)

### Choose one of the paths, tired wanderer:

- A - `Dockerfile_quick_2025-05-14` - has code mods integrated for speed, may stop working with future XGDAG releases.
- B - `Dockerfile` - clean docker, requires manual changes to the XGDAG code (as accessed on 2025-05-14), all detailed below.


### A - Instructions for Dockerfile_quick_2025-05-14

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




### B - Instructions for Dockerfile

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

## Further analysis

The above may allow to replicate the analysis in the paper, but performing an analysis of another disease requires further, undocumented, steps.
The script requires several input files, including a .gml interactome and .txt files with genes, scores and ranking, which appantly need to be generated with another tool - see here:
https://github.com/GiDeCarlo/XGDAG/issues/1
and
https://github.com/AndMastro/NIAPU/?tab=readme-ov-file



