Introduction
============

Hipatia is the name of BCAM cluster. It is based in Slurm, you can find more information about Slurm in the following links:

-   <https://slurm.schedmd.com/overview.html>

-   <https://support.ceci-hpc.be/doc/_contents/QuickStart/SubmittingJobs/SlurmTutorial.html>

This cluster is developed under a Debian distribution and you need to have an account in order to login to the server, if in the following steps you get a login error, ask IT to create an account.

Connection
==========

To connect to the server by using SSH on Linux and MAC, we’ve two options.
By name:

    ssh -p 6556 <username>@hpc.bcamath.org
        

or directly by IP:

    ssh <username>@150.241.212.41 -p6556
        

After this, we’re connected in our personal directory, `/home/<username>`.



Internal structure - Hipatia
============================

Personal directories - Hipatia
------------------------------

We’ve available mainly two personal directories to work in them:

-   `/home/<username>/` &rarr; We will usually work in this directory, so we’ll transfer the files/folders from local to here and then run the Slurm commands to run our application

-   `/workspace/scratch/users/<username>/`&rarr; In case that we work with a folder structure with local references, it’s advisable to work directly here.

Time Restrictions: Partitions
-----------------------------

Inside the cluster, we have the possibility of running our project in different partitions, to see what options we have, we execute the command `sinfo`. Here we see the following partitions

| Partition | Max Time Limit |
| :--: | :--: | 
| short | 30 minutes |
| medium | 6 hours |
| large | 5 days |
| xlarge| 30 days |
| extra | 90 days |

Memory Restrictions
-------------------

### Memory Restrictions in Hipatia

There is a **default** global memory limit of **4700MB** per cpu. Users can modify this limit by using the `--mem=` or `--mem-per-cpu=` parameters within their jobs, if necessary.

- **MAXIMUM MEMORY SPECIFICATION** &rarr; **377GB**


#### Explanation

The memory limit is the limit of the node with the most memory installed. Once an amount of memory is requested, SLURM will already know which nodes are candidates to run the job and will not allocate it to a node that does not meet the conditions. Unless we specify a list of nodes or a specific architecture whose nodes with maximum memory is less than the memory installed on the node with the most memory in the entire cluster, in which case SLURM would tell us that there is no possibility of launching jobs in that configuration.

### Basic Slurm Terms: Node, Core, CPU and Threading


- A (compute) **node** is a computer part of a larger set of nodes (a cluster). Besides compute nodes, a cluster comprises one or more login nodes, file server nodes, management nodes, etc. A compute node offers resources such as processors, volatile memory (RAM), permanent disk space (e.g. SSD), accelerators (e.g. GPU) etc.
- A **core** is the part of a processor that does the computations. A processor comprises multiple cores, as well as a memory controller, a bus controller, and possibly many other components. A processor in the Slurm context is referred to as a socket, which actually is the name of the slot on the motherboard that hosts the processor.
- A **CPU** in a general context refers to a processor, but in the Slurm context, a CPU is a consumable resource offered by a node. It can refer to a socket, a core, or a hardware thread, based on the Slurm configuration.

The role of Slurm is to match those resources to **jobs**. A job comprises one or more (sequential) **steps**, and each step has one or more (parallel) **tasks**. A task is an instance of a running program, i.e. at a process, possibly along with subprocesses or software threads.

- `--ntasks=N` &rarr; Reserves N cores to allocate 1 process on each of them (`N` = number of precesses).
- `--ntasks-per-node=N` &rarr; Makes a per-node task reservation to reserve a homogeneous number of cores per node, and assign each of those cores to a process  (`N` = number of precesses).
- `--cpus-per-task=N` &rarr; Refers to the number of threads that que aplication is going to need for each created procces  (`N` = number of threads).

**Difference between allocating memory with `--ntasks` and `--cpus-per-task`:** when using `srun`, it takes by default the number of tasks defined in `--ntasks` to create the processes.


[Source](https://stackoverflow.com/questions/65603381/slurm-nodes-tasks-cores-and-cpus)

Basic commands
==============

Here we can see several basic commands once we are connected:

-   `squeue` &rarr; Shows pending jobs.

	-   `squeue -u <username>` &rarr; Shows information about jobs located in the Slurm scheduling queue of a specific user.

	-   `squeue -w node1,node2` &rarr; Shows information about jobs located in the Slurm scheduling queue of one or more specific nodes.

	-   `scontrol -d show job <JOBID> | grep Reason`  &rarr; Shows why a job is in that state.

-   scancel <jobid> &rarr; Cancels the execution of a job.
	-  	`scancel {<first_jobid>..<last_jobid>}` &rarr; Cancels several consecutive jobs you can use.
	-   `scancel -u <username>` &rarr; To cancel all jobs of a specific user 

-   `sinfo` &rarr; View information about Slurm nodes and partitions.

-   `module avail` &rarr; Shows what modules are available to load.

-   `sbatch` &rarr; Submits script for a later execution. You can set options such as the number of tasks, the maximum execution time, the partition we want to use, the number of nodes we want to use for this job, etc
	-   `sbatch -w node1,node2` &rarr; Chooses the node or nodes. (Not needed)
	-  `sbatch -x node1,node2` &rarr; To exclude nodes. (Not needed)

-   `srun` &rarr;  To create job allocation and launch a job step, that is to run parallel jobs.

-   Slurm is based on Linux, let’s not forget that we can use all the Bash commands like: `ls`, `cat`, `rm`, `mkdir`, etc

File `.sl`
================

In order to simplify the commands that we write in the cluster to run our scripts, we create a file “.sl”.
We recommend started with the configuration commands, for example we can see here:

-   `–time` &rarr; Set a limit on the total run time of the job allocation, once elapsed, it will stop

-   `–output` &rarr; File name to save the output. The default file name is “slurm-%j.out”, where the “%j” is replaced by the job ID.

-   `–error` &rarr; File name to save the errors. The default file name is “slurm-%j.out”, where the “%j” is replaced by the job ID.

-   `–ntasks` &rarr; Request the maximum ntasks be invoked on each core.

-   `–ntasks-per-node` &rarr; Request that ntasks be invoked on each node. If used with the `–ntasks` option, the `–ntasks` option will take precedence and the `–ntasks-per-node` will be treated as a maximum count of tasks per node.

-   `–cpus-per-task` &rarr; Advise the Slurm controller how many processors will require per task, without this option, the default value is 1 per task.

-   `–mem-per-cpu` &rarr; Minimum memory required per allocated CPU. Default units are megabytes, but we can specified different units using the suffix [K|M|G|T]. It's important to specify a sufficient amount of memory. Otherwise, you could obtain OOM (out of memory) errors from Hipatia.

-   `–partition` &rarr; Request a specific partition for the execution of our program. If not specified, the default behavior is to allow the slurm controller to select the default partition as designated by the system administrator.

-   `–job-name` &rarr; This is the name that will appear when we look at the work in progress

We can see more options in <https://slurm.schedmd.com/sbatch.html>
A real example of this section is:

    #SBATCH --time=00:30:00 #Walltime
        #SBATCH --output=slurm-%j.out
        #SBATCH --error=slurm-%j_err.txt
        #SBATCH --ntasks=1 # number of tasks
        #SBATCH --ntasks-per-node=1 #number of tasks per node
        #SBATCH --cpus-per-task=1 # 4 OpenMP Threads
        #SBATCH --mem-per-cpu=1G # memory/core
        #SBATCH --partition=medium
        #SBATCH --job-name=Python_proj
        

After the initial configuration, we can see the modules required by the program/script we are going to run and load, remind you that we can see the different modules available with command “module avail”.
Here we can see an example to load Python 3.7:

    module load Python/3.7.4-GCCcore-8.3.0j
        

Here we can see an example to load Matlab:

    module load MATLAB
        

Finally, we will write the command to run the script/scripts we want. An example could be:

    srun python helloWorld.py
        

If you’re going to run a Matlab script, here an example:

    srun matlab -nodisplay -r "HEM 60 twice, exit"
        

This is enough to generate our “sl” file, but there is a lot of flexibility and we can develop it as complex as we want.
Beyond all the available configuration commands, we can perform file manipulation, run several scripts in a sequential way... there are no limits.
PS: Try to be careful with the resources requested to be in solidarity with the colleagues.


Examples
========

Hello World - Python
--------------------

We are going to develop a script to print “Hello World” and the current version of Python.

    import sys
        
        print("Hello Word")
        print(sys.version)
        

So, we’ll need develop as well the file “.sl” to configure the Slurm run in Hipatia.
This time, we’re going to seet a limit on the total run time (6 hours),we’re going to use just 500MB of memory and the name in the cluster will be “Python\_proj”, we’re going to save all the outputs and the errors that come out while the script is running, as our script is very simple, we don’t need more than 1 cpu per task and finally we are going to run it on partition “medium”.
We are going to load the module “python 3.7” with the command “module load...” and we finally write the command to run the python script with “srun python...”
We’ve the code:

    #!/bin/bash
        #SBATCH --time=6:00:00     # Walltime 
        #SBATCH --mem-per-cpu=500M  # memory/cpu 
        #SBATCH --job-name=Python_proj  # CAREFUL TO CHANGE IT ALSO IN THE RUN LINE
        #SBATCH --output=slurm-%j_out.txt
        #SBATCH --error=slurm-%j_err.txt
        #SBATCH --cpus-per-task=1 
        #SBATCH --partition=medium
        
        module load Python/3.7.4-GCCcore-8.3.0
        srun python helloWorld.py 
        

Now, all that remains is to transfer these two files to the cluster, for example with the command “scp”, execute the script with the command:

    sbatch testHipatiaL.sl 
        

We’ll receive a message with the job ID like “Submitted batch job 1170397”.
We can check the job with the command “squ”:

    JOBID PARTITION PRIOR     NAME     USER    STATE       TIME  TIME_LIMIT  NODES CPUS TRES_P           START_TIME     NODELIST(REASON)      QOS
        1170397    medium 14801 Python_p    adiaz  RUNNING       0:01     6:00:00      1    1    N/A  2020-10-26T15:13:21                 n001   normal
        

When our job is finished, we will see the errors file, “1170397\_err.txt” and the outputs file “1170397\_out.txt”, an easy way to read them is with the command “cat namefile.txt”.
In our example, we have said that it will generate the output and error files starting with the ID that Hipatia have assigned to the execution of the script, so that we can difference easily the different executions.
We can read the output file, for example with command “cat”, like “cat 1159037\_err.txt” and “cat 1159037\_out.txt”.

 Example file `.sl` Matlab
------------------------------

An example of file `.sl` for Matlab:

    #!/bin/bash
        #SBATCH --time=6:00:00     # Walltime 
        #SBATCH --mem-per-cpu=800M  # memory/cpu 
        #SBATCH --job-name=Matlab_proj 
        #SBATCH --output=%j_out.txt
        #SBATCH --error=%j_err.txt
        #SBATCH --cpus-per-task=4 
        #SBATCH --partition=medium
        
        module load MATLAB
        ## run Matlab
        srun matlab -nodisplay -r "matlab_parfor.m, exit" 
        ## option -noFigureWindows allows to create and save figures without opening figure
        

Once you have this .sl in your corresponding Hipatia folder (in which you also have the "matlab\_parfor.m" file), you must write the following command on terminal:
			
			sbatch example.sl
			
where I am assuming you called 'example.sl' the .sl file from above (REMARK: In order to save the text file from above as a .sl, I recommend to use a text editor from the terminal -such as 'vim'-).

Appendix 1: Copying working structure
=====================================

To transfer files between local and server, here we suggest the SCP command that allows you to securely copy files and directories between two locations.
When transferring data with scp, both the files and password are encrypted so that anyone snooping on the traffic doesn’t get anything sensitive.
If you’re not familiar with the commands and you prefer use a visual software, you can use Filezilla to transfer all the files and directories between local-server and server-local.
We need hence, use the command as follow:

    scp [OPTION] [user@]SRC_HOST:]file1 [user@]DEST_HOST:]file2
        

To transfer a file from local to server (remote) or from server to local, you will be asked for a user name and password.
An example of a single file:

    scp -P 6556 "/home/adiaz/Documents/MRC_bcam/minimax-hipatia.sl" adiaz@hpc.bcamath.org:/home/adiaz/minimax-risk-classifier 
        

The argument “-P” is to specify the port.
An example of copy a directory recursively (just add argument “-r”):

    scp -P 6556 -r "/home/adiaz/Documents/minimax-risk-classifier/" adiaz@hpc.bcamath.org:/home/adiaz/
        

Appendix 2: Use CVX in Matlab
=============================

If you need to use CVX in Matlab, Go to <http://cvxr.com/cvx/download/> and download CVX (Linux Version). **Important: Download version for linux since it is the OS of hipatia.**

N.B. If you want to use commercial solvers such as MOSEK or GUROBI make sure to download a package that contains those solvers and download the needed licences.
* MOSEK: Download licence as explained in [CVX solvers tutorial](https://github.com/MachineLearningBCAM/How-To/blob/main/Manual-Solvers_CVX/solvers_CVX.md). Create a folder called mosek in the directory `/home/<your_username>` in hipatia and upload the licence file `mosek.lic` to this folder.
* GUROBI: Just follow the steps to activate the licence explained in [CVX solvers tutorial](https://github.com/MachineLearningBCAM/How-To/blob/main/Manual-Solvers_CVX/solvers_CVX.md) **before** uploading the CVX folder to hipatia. 

Put all your matlab files (main and functions) and the file .sl in the folder CVX, that will be automatically created once you download CVX from the website. Instead you can have your files in whatever directory in your cluster outside the CVX folder and just add the path of the folder with

    addpath("relative CVX path")

N.B. The main of the matlab file shoud start with the following command 

    cvx setup

Transfer all the files Matlab and the file .sl (you can just upload the whole CVX folder as well) into the cluster, using FileZilla by dragging and dropping the files from your Local site (left in the FileZilla interface) to the Remote site (right in the FileZilla interface) in the folder named as your username.
Now that you have upload your files into the cluster, you are ready to run them.

Appendix 3: Matlab licenses
===========================

You use as many Matlab licenses (statistic toolbox) as nodes you are using in the cluster. However, you use only one license if you run several jobs on the same node. Hipatia allows you to choose and exclude nodes. You can choose a specific node by typing in the command line:

    sbatch -w node slurmfile.sl
            

and can exclude nodes by typing

    sbatch -x node1,node2 slurmfile.sl
            

In the case of excluding nodes, we write the sequence of nodes to which we do not want to send the job. The names of nodes are separated by commas without spaces. Hipatia includes 18 nodes: n001, n002, ..., n018. If you choose a node that is complete, the job remains pending until it can be executed.

Appendix 4: Use CVX in Python
=============================

_CVXPY_ module is already installed on Hipatia and can be loaded using any of the following modules - 

    SciPy-bundle/2019.10-foss-2019b-Python-3.7.4
    SciPy-bundle/2019.10-intel-2019b-Python-3.7.4
    SciPy-bundle/2019.10-fosscuda-2019b-Python-3.7.4
            

Using MOSEK solver with CVX
---------------------------
The _MOSEK_ solver is available in the following module - 

    Mosek/9.2.40-foss-2019b-Python-3.7.4
            

To use the solver, you also need to have license. You can get a free academic license from [here](https://www.mosek.com/products/academic-licenses/). Once you obtain the license, you have to save the license file in the mosek (you have to create this folder) folder on Hipatia server. The location of this license file would be ``/home/your_user_name/mosek/mosek.lic``

Appendix 5: Use MRCpy or any other package in Python
=============================

To install packages not available in the cluster firs it is necessary to open the terminal of the cluster and load the python module -

    module load Python/3.7.4-GCCcore-8.3.0
    
Once loaded just install any package with pip in your user folder of the cluster with the command - 

    pip install -user <name_package>
    
Install packages not in PyPI
---------------------------
To install packages not in the Python Package Index repository it is necessary to upload the package folder to the cluster via SFTP or dragging files if you are using an application such as FileZilla or MobaXterm. Then just go to the folder and install the package following the developers instructions. For the Minimax Risk Classifier package -

    module load Python/3.7.4-GCCcore-8.3.0
    cd <MRCpy folder in the cluster>
    python setup.py install --user
    
_Note: Make sure to have all dependencies installed to avoid posible installation errors._ 
