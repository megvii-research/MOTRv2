# MOTRv2: Bootstrapping End-to-End Multi-Object Tracking by Pretrained Object Detectors

[![arXiv](https://img.shields.io/badge/arXiv-2211.09791-COLOR.svg)](https://arxiv.org/abs/2211.09791)
[![PWC](https://img.shields.io/endpoint.svg?url=https://paperswithcode.com/badge/motrv2-bootstrapping-end-to-end-multi-object/multi-object-tracking-on-dancetrack)](https://paperswithcode.com/sota/multi-object-tracking-on-dancetrack?p=motrv2-bootstrapping-end-to-end-multi-object)
[![PWC](https://img.shields.io/endpoint.svg?url=https://paperswithcode.com/badge/motrv2-bootstrapping-end-to-end-multi-object/multiple-object-tracking-on-bdd100k)](https://paperswithcode.com/sota/multiple-object-tracking-on-bdd100k?p=motrv2-bootstrapping-end-to-end-multi-object)

This repository is an official implementation of [MOTRv2](https://arxiv.org/abs/2211.09791).


## Introduction

**TL; DR.** MOTRv2 improve MOTR by utilizing YOLOX to provide detection prior.

![Overview](https://raw.githubusercontent.com/zyayoung/oss/main/motrv2_main.jpg)

**Abstract.** In this paper, we propose MOTRv2, a simple yet effective pipeline to bootstrap end-to-end multi-object tracking with a pretrained object detector. Existing end-to-end methods, e.g. MOTR and TrackFormer are inferior to their tracking-by-detection counterparts mainly due to their poor detection performance.  We aim to improve MOTR by elegantly incorporating an extra object detector. We first adopt the anchor formulation of queries and then use an extra object detector to generate proposals as anchors, providing detection prior to MOTR. The simple modification greatly eases the conflict between joint learning detection and association tasks in MOTR. MOTRv2 keeps the end-to-end feature and scales well on large-scale benchmarks. MOTRv2 achieves the top performance (73.4% HOTA) among all existing methods on the DanceTrack dataset. Moreover, MOTRv2 reaches state-of-the-art performance on the BDD100K dataset. We hope this simple and effective pipeline can provide some new insights to the end-to-end MOT community.

## News
- **2023.02.28** MOTRv2 is accepted to CVPR 2023.
- **2022.11.18** MOTRv2 paper is available on [arxiv](https://arxiv.org/abs/2211.09791).
- **2022.10.27** Our DanceTrack challenge tech report is released [[arxiv]](https://arxiv.org/abs/2210.15281) [[ECCVW Challenge]](https://motcomplex.github.io/index.html#challenge).
- **2022.10.05** MOTRv2 achieved the 1st place in the [1st Multiple People Tracking in Group Dance Challenge](https://motcomplex.github.io/).

## Main Results

### DanceTrack

| **HOTA** | **DetA** | **AssA** | **MOTA** | **IDF1** |                                           **URL**                                           |
| :------: | :------: | :------: | :------: | :------: | :-----------------------------------------------------------------------------------------: |
|   69.9   |   83.0   |   59.0   |   91.9   |   71.7   | [model](https://drive.google.com/file/d/1EA4lndu2yQcVgBKR09KfMe5efbf631Th/view?usp=share_link) |

### Visualization

<!-- |OC-SORT|MOTRv2| -->
|SORT-like SoTA|MOTRv2|
|:-:|:-:|
|![](https://raw.githubusercontent.com/zyayoung/oss/main/2_ocsort.gif)|![](https://raw.githubusercontent.com/zyayoung/oss/main/2_motrv2.gif)|
|![](https://raw.githubusercontent.com/zyayoung/oss/main/19_ocsort.gif)|![](https://raw.githubusercontent.com/zyayoung/oss/main/19_motrv2.gif)|
|![](https://raw.githubusercontent.com/zyayoung/oss/main/1_ocsort.gif)|![](https://raw.githubusercontent.com/zyayoung/oss/main/1_motrv2.gif)|


## Installation

The codebase is built on top of [Deformable DETR](https://github.com/fundamentalvision/Deformable-DETR) and [MOTR](https://github.com/megvii-research/MOTR).

### Requirements

* Install pytorch using conda (optional)

    ```bash
    conda create -n motrv2 python=3.7
    conda activate motrv2
    conda install pytorch=1.8.1 torchvision=0.9.1 cudatoolkit=10.2 -c pytorch
    ```

* Other requirements
    ```bash
    pip install -r requirements.txt
    ```

* Build MultiScaleDeformableAttention
    ```bash
    cd ./models/ops
    sh ./make.sh
    ```

## Usage

### Dataset preparation

1. Download YOLOX detection from [here](https://drive.google.com/file/d/1cdhtztG4dbj7vzWSVSehLL6s0oPalEJo/view?usp=share_link).
2. Please download [DanceTrack](https://dancetrack.github.io/) and [CrowdHuman](https://www.crowdhuman.org/) and unzip them as follows:

```
/data/Dataset/mot
├── crowdhuman
│   ├── annotation_train.odgt
│   ├── annotation_trainval.odgt
│   ├── annotation_val.odgt
│   └── Images
├── DanceTrack
│   ├── test
│   ├── train
│   └── val
├── det_db_motrv2.json
```

You may use the following command for generating crowdhuman trainval annotation:

```bash
cat annotation_train.odgt annotation_val.odgt > annotation_trainval.odgt
```

### Training

You may download the coco pretrained weight from [Deformable DETR (+ iterative bounding box refinement)](https://github.com/fundamentalvision/Deformable-DETR#:~:text=config%0Alog-,model,-%2B%2B%20two%2Dstage%20Deformable), and modify the `--pretrained` argument to the path of the weight. Then training MOTR on 8 GPUs as following:

```bash 
./tools/train.sh configs/motrv2.args
```

### Inference on DanceTrack Test Set

```bash
# run a simple inference on our pretrained weights
./tools/simple_inference.sh ./motrv2_dancetrack.pth

# Or evaluate an experiment run
# ./tools/eval.sh exps/motrv2/run1

# then zip the results
zip motrv2.zip tracker/ -r
```

## Acknowledgements

- [MOTR](https://github.com/megvii-research/MOTR)
- [ByteTrack](https://github.com/ifzhang/ByteTrack)
- [YOLOX](https://github.com/Megvii-BaseDetection/YOLOX)
- [OC-SORT](https://github.com/noahcao/OC_SORT)
- [DanceTrack](https://github.com/DanceTrack/DanceTrack)
- [BDD100K](https://github.com/bdd100k/bdd100k)
