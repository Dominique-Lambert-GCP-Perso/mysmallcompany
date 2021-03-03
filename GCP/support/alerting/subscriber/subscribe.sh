#!/bin/bash
virtualenv env
source env/bin/activate
pip install -r requirements.txt
python subscriber2.py data-proc-test-dla receive alerts-sub