#!/usr/bin/env sh

for qtt in query test train; do
    ./embed.py \
        --experiment_root $1 \
        --dataset data/dukemtmc-reid_$qtt.csv \
        --checkpoint checkpoint-$2 \
        --filename embs_$qtt-$2.h5 \
        --crop_augment five --flip_augment --aggregator mean
done

./evaluate.py \
    --excluder market1501 \
    --query_dataset data/dukemtmc-reid_query.csv \
    --query_embeddings $1/embs_query-$2.h5 \
    --gallery_dataset data/dukemtmc-reid_test.csv \
    --gallery_embeddings $1/embs_test-$2.h5 \
    --filename $1/embs_query-$2-euclidean.json \
    --metric euclidean

./evaluate.py \
    --excluder diagonal \
    --query_dataset data/dukemtmc-reid_train.csv \
    --query_embeddings $1/embs_train-$2.h5 \
    --gallery_dataset data/dukemtmc-reid_train.csv \
    --gallery_embeddings $1/embs_train-$2.h5 \
    --filename $1/embs_train-$2-euclidean.json \
    --metric euclidean
