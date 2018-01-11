#!/usr/bin/bash

echo "launching an interactive session:"

srun -p gpu --gres gpu:1 --pty /usr/bin/bash

echo "leaving interactive session"

