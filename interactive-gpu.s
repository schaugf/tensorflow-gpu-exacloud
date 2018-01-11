#!/usr/bin/bash

echo "launching an interactive session:"

# default config resource allocation is single CPU core and 2GB memory for 1 hour

#srun -t6:00:00 --pty /usr/bin/bash
 
# To request 4 CPU cores, 4 GB memory, and 2 hour running duration

#srun -c4 -t2:00:00 --mem=4000 --pty /bin/bash--pty /usr/bin/bash -l

# To request one GPU card, 3 GB memory, and 1.5 hour running duration

#srun --partition=gpu -t6:00:00 --mem=3000 --gres=gpu:1 --pty /usr/bin/bash
#srun --partition=gpu -t6:00:00 --mem=3000 --pty /usr/bin/bash

srun -p gpu --gres gpu:1 --pty /usr/bin/bash

# To request computing resources, and export x11 display on allocated node(s)

#srun --x11 -c4 -t2:00:00 --mem=4000 --pty /bin/bash
#xterm  # check if xterm popping up okay
  
# To request GPU card etc, and export x11 display

#srun --x11 -t1:30:00 --mem=3000 --gres=gpu:1 --pty /bin/bash

echo "leaving interactive session"

