#	Tutorial: GPU Computing on Exacloud

Training neural networks on GPU architecture will demonstrably decrease required training time.
This tutorial is meant to illustrate the process of configuring a system to train a simple neural network on a GPU on Exacloud, which is managed by the Slurm job scheduler.

Slurm is designed to process a submit script (suffixed with a .s) to allocate necessary resources for program execution.
I'll walk through both how to launch an interactive session with a GPU and how to tell Exacloud to use a GPU to run your program.

##	Get access to GPU partition

If you're new to this, you will need to request access to a GPU-equipped partition on Exacloud.
If you're unsure whether you have access or not, simply run

```
./interactive-gpu.s
```

If an error is returned, then you probably don't have access and need to contact ACC.
If no error is returned, and instead you see a message saying you're launching an interactive session, congrats!
You can confirm that you have access to GPU hardware by typing

```
nvidia-smi
```

Depending on which GPU partition you have been allocated to, you should see a list of at least one device that looks like a GPU.
If you don't, contact ACC.
Otherwise, you're in good shape, and and quit the interactive session by pressing ctrl+d.
You should see a "leaving interactive session" message on the console.

##	Create a virtual environment

A virtual environment will allow us to install any necessary python packages needed to run our model.
If you don't already have virtualenv installed, check an online resource to learn how.
I recommend installing a local version of brew to manage installed packages.

Once you have virtualenv installed, create your own environment using the following command.
Note that I am using python3 which seems to work, although I have not tested this process with python2.7.
If you are usure of which python version you'd like to use, I recommend use python3.

```
virtualenv -p python3 tensorflow
```

Once that's finished, begin using your virtual environment by sourcing the activation script.

```
source tensorflow/bin/activate
```

We will keep the virtualenv open for now, but you can terminate the environment at any time by simply typing

```
deactivate
```

##	Installing Tensorflow

Since virtualenv automatically installs a local version of pip, you can install tensorflow and any other requisite dependencies as you would on a normal system.
However, because we will be utilizing GPU architecture, we want to be sure to install the GPU-capable version of tensorflow.

```
pip install tensorflow-gpu
```

## Configure LD_LIBRARY_PATH

Tensorflow requires access to NVIDIA's CUDA library to communicate with the GPU hardware, so you will need to add pointers to CUDA installations to your library path.
Edit your .bash_profile to include the following line (after any other modifications to LD_LIBRARY_PATH.

```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-8.0/lib64:/usr/lib64/nvidia
```

Once done, either log out and back onto Exacloud, or source your .bash_profile.

##	Test your installation

Assuming you're still in an interactive session with GPU access and you are in your virtual environment, you can test your installation with

```
python -c "import tensorflow"
```

If you get an error, then you may well be missing a required CUDA dependency.
If problems persist, ask ACC.

Otherwise, if the above command doesn't return an error (nothing happens), then you should be good to go.

Try running

```
python gpu-tutorial.py
```

If everything is working, you should see a bunch of stuff spit out into the console.
Read through it and make sure there are no errors. 
If everything is working, you should see Tensorflow running the same computation twice, once on a CPU and once on a GPU (each computation completes by spitting out a 2x2 matrix [[22, 28],[49, 64]])

##	Submitting GPU job

Assuming that all works, you'll want to be sure you can submit your job through Slurm to a GPU.
First, exit out of the interactive session and reactivate your virtualenv.
Take a look at submit-gpu.s.
This is a sample batch script that will execute the gpu-tutorial.py on a GPU and tell Slurm how to handle your job.

```
#!/usr/bin/bash			# tells slurm to start a shell
#SBATCH --partition=gpu 	# tells slurm to request access to a gpu-equipped partition
#SBATCH --gres=gpu:1		# tells slurm to use the first gpu core for computation
#SBATCH --get-user-env		# tells slurm to use the virtualenv you are currently running
srun python gpu-tutorial.py	# runs your python script
```

Close out and send this to Slurm using the following

```
sbatch submit-gpu.s
```

Assuming everything works right, after a few seconds you should see your current directory populated with a new file called slurm-[a bunch of numbers].out.
This file should contain the same contents you saw printed out to the terminal above.
If it doesn't work, you'll see a similar file but with a .err suffix.
Read this, as it will tell you when your script errored out.

## Concluding remarks

I hope this has been helpful or useful, and I'm sorry if you have run into a problem that I haven't really addressed.
You are more than welcome to send me any problems you have with their solutions (if you have them), so I can update this document accordingly.

Otherwise, happy training!

-Geoff

