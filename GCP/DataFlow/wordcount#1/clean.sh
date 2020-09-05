#!/bin/bash

echo "delete buckets"
gsutil -m rm -r gs://cs-for-dataflow-dla

echo "Fin"
