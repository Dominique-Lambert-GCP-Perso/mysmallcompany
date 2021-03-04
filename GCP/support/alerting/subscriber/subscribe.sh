#!/bin/bash
virtualenv env
source env/bin/activate
pip install -r requirements.txt
python subscriber2.py ocb-big-data-sandbox receive alerts-sub