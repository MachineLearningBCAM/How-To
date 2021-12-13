# Introduction

This is a basic guide on how to use the HPC systems hosted by the DIPC Supercomputing Center. There are two different hosted HPC systems that we can use: Atlas EDR and Altas FDR

- **Atlas EDR**:	Based on SLURM. HPC system running a total of 45 nodes and features a total of 2224 cores and 15 TB of distributed memory. Some of the nodes are powered with either one or two NVIDIA Tesla P40 GPGPUS. The network technlogy interconnection the nodes is a fat-tree topology EDR Infiniband at 100 Gbps with a 5:1 blocking factor.

- **Atlas FDR**:	Based on TORQUE. A cluster type HPC system running a total of 210 nodes and features a total of 6100 computing cores and 80 TB of distributed RAM memory. The network technology interconnection the nodes is a FDR Infiniband at 56 Gbps with a fat-tree topology with a 5:1 blocking factor.

# Login
Prior connecting to Atlas EDR or Atlas FDR you need to establish connection with the access nodes first. In order to do that, a SSH client is necessary. Please, refer to [SSH](http://dipc.ehu.es/cc/computing_resources/general/connect/ssh/) for more information.

    ssh user@ac.sw.ehu.es
 
You can also establish connection with access nodes manually:

    ssh username@ac-01.sw.ehu.es
    ssh username@ac-02.sw.ehu.es

Once you are logged into an access node you can establish a connection with the login node of any of the HPC systems:

    ssh atlas-fdr 
    ssh atlas-edr
You can also choose the login node you want to connect to.
- Atlas-EDR has 2 login nodes (`atlas-edr-login-01.sw.ehu.es` and `atlas-edr-login-02.sw.ehu.es`). Each node has two sockets populated with a 48 core Intel Xeon Platinum 8260 each.
Each node has 64 GB of RAM.
- Atlas FDR has 2 login nodes (`atlas-fdr-login-01.sw.ehu.es` and `atlas-fdr-login-02.sw.ehu.es`). Each node has two sockets populated with a 6 core Intel Xeon E5-2609 v3 each.
Each node has 64 GB of RAM.
For example,

    ssh atlas-edr-login-01.sw.ehu.es

## Login while connected to EHU/UPVs VPN
*Note:* It is **not** necessary to have access to the EHU/UPVs VPN, we are giving options to perform every action without it. But we explain this option because in some cases it may be easier or quicker to use it if you can.

As long as you are in the subnet using EHU/UPVs VPN, you also establish direct connection with the login nodes (no need to connect first to access nodes). 

    ssh username@atlas-edr-login-01.sw.ehu.es
    ssh username@atlas-edr-login-02.sw.ehu.es
    
    ssh username@atlas-fdr-login-01.sw.ehu.es
    ssh username@atlas-fdr-login-02.sw.ehu.es
    

# File system
There is a home directory `/dipc/username` **shared** along the access nodes, Altas EDR and Atlas FDR (it runs on top of a Ceph parallel filesystem). It is intended for permanent file storage. Your shell refers to it as “∼” (tilde), and its absolute path is also stored in the environment variable $HOME. Daily backups of these directories are performed and backups are saved up to 2 months old.

The directory meant to be used as the work space for jobs is `/scratch/username`. It is **not shared**: each HPC system has its own `/scratch` directory. It is a shared high performance storage that system provides access to large amounts of disk for short periods of time at much higher speed than `/dipc`.

Remember that `/scratch` filesystems are not meant to be used as a permanent storage solution.

# File transfer
To transfer files between local and server, you can either use bash commands or use a visual software like Fillezilla.
## Console file managing
To copy files from local to server `/dipc/username` (run this command from a local terminal, not logged in the cluster):

    scp -p /<local_file_path> username@ac.sw.ehu.es:/dipc/username 
To copy files from server `/dipc/username` to local (run this command from a local terminal, not logged in the cluster):

    scp -p username@ac.sw.ehu.es:/dipc/username/filename /<local_file_path>
To delete file:

    rm filename
To move files from one folder to another:

    cp source_file destiny_file

## FileZilla

### General: Without EHU/UPVs VPN
<!-- There are tho options to use FileZilla while not being connected to  EHU/VPN:
- Option 1. Connect FileZilla directly to the access computers and use your home directory (`/dipc/username`) to bring your data over the cluster. You home directory is also present on Atlas FDR's and EDR's logins nodes.
  - Protocol: SFTP - SSH
  - Host: `ac-01.sw.ehu.es` or `ac-02.sw.ehu.es`
  - Port: 2222
  - User: username

- Option 2. -->

Create a SSH tunnel via the access nodes to establish a direct connection with the login nodes. In this way you can only connect to one cluster at a time Atlas EDR or Atlas FDR. Perform the following steps:

  1. Set up the tunnel from the command line and keep the connection alive
  
          ssh -L 2222:atlas-edr-login-0X.sw.ehu.es:22 username@ac-0Y.sw.ehu.es 
     Where X specifies the login node (can be 1 or 2) and Y specifies the access node (can be 1 or 2).

  2. Open FileZilla and set it up as follows:
    - Protocol: SFTP - SSH
    - Host: localhost
    - Port: 2222
    - User: username
  If you want to change connections between clusters, terminate the tunnel with `exit`, close the connection in FileZilla and repeat the process.
  
### With EHU/UPVs VPN
As long as you are in the subnet using EHU/UPVs VPN, you can establish direct connection with the login nodes and therefore with FileZilla:
New connection:
- Protocol: SFTP
- Host: 
  - For Atlas EDR: `atlas-edr-login-01.sw.ehu.es` or `atlas-edr-login-02.sw.ehu.es` 
  - For Atlas FDR: `atlas-fdr-login-01.sw.ehu.es` or `atlas-fdr-login-02.sw.ehu.es` 
- Port: 2222
- User: username

# Atlas EDR
## Job submission
Atlas EDR is based on Slurm, like BCAM's cluster Hipatia (You can see a wider description of this in [Hipatia's manual](https://github.com/MachineLearningBCAM/How-To/blob/main/Manual-Hipatia/hipatia.md) or directly in [DIPC Documentation](http://dipc.ehu.es/cc/computing_resources/systems/atlas-edr/)). There are some differences like the available partitions or how to load modules. To submit a job it is recommended to write a `.sl` file to to simplify the commands that we write in the cluster to run our scripts. Simple example:

    #!/bin/bash
    #SBATCH --partition=bcam-exclusive
    #SBATCH --account=bcam-exclusive
    #SBATCH --job-name=JOB_NAME
    #SBATCH --cpus-per-task=1
    #SBATCH --mem=200gb
    #SBATCH --nodes=8
    #SBATCH --ntasks-per-node=48

    module load intel/2020a # Load compiler
    module load program/program_version

    srun binary < input 
You can also use all the slurm commands: `squeue`, `scontrol`, `scancel`, `sinfo`, `sbatch`, `srun`... and all the Bash commands: `ls`, `cat`, `rm`, `mkdir`...
## Partitions

### BCAM Exclusive Partition
There are now **21 computing nodes** that are available on DIPC cluster (called ATLAS). These new nodes are available only for BCAM researchers and not shared with other organizations like the rest of ATLAS computing nodes. You only have to add these lines in your script:

    #SBATCH --partition=bcam-exclusive
    #SBATCH --account=bcam-exclusive

The bcam-exclusive partition has actually **no time-limit**.

You can check the jobs running and pending in the BCAM exclusive partititon using the option:

    squeue -p bcam-exclusive

On the other hand, you also have the possibility to use a **GPU Quadro RTX 8000**. You only need to specify this line in your script:

    #SBATCH --gres=gpu:rtx8000:1
    
Note: The total memory of each node in the bcam-exclusive partition is 96GB. Therefore the specification `--mem-per-cpu` cannot exceed this limit. If you need more memory, yoy can run your job in a shared DIPC node.

### Shared Partitions
The available partitions on Atlas EDR shared with other organizations are:

QoS/Partition |	Priority |	MaxWall |	MaxNodesPU |	MaxJobsPU |	MaxSubmitPU |	MaxJobs
-----------|---------|------|---------|--------|--------|-------
regular	|200	|1-00:00:00|	12|	10		
test|	500	|00:10:00	|2	|2	|2	
long	|200	|2-00:00:00|	12	|5		
xlong|	200|	8-00:00:00|	6	|2		
large|	200|	2-00:00:00	|20|	1		
xlarge|	200|	2-00:00:00	|40|	1		
serial	|200|	1-00:00:00	|12	|120		

*Note:* The notation used is `days-hours:minutes:seconds`.

## Module loading
Another difference with Hipatia is the names of the modules. To list the modules available to load: `module avail`.

For example to load Python, we should write the following line to the `.sl`.

    module load Python/3.7.6-Anaconda3-2020.02
### Loading Python modules
Once you have loaded Python, we need to use the `conda` command to load the modules you want to import in your Python script.
From console you are creating a conda environment in which you are going to load the desired Python modules: 

    conda create -n <myenv_name>  
    conda install -n <myenv_name> <package_name>
Or directly
    
    conda create -n <myenv_name>  <package1_name>, <package2_name>, ...
    
You can list all the available packages with `conda list` and check the packages installed in an existing environment with `conda list -n <myenv_name>`. Some of the most used ones:
    
    conda install -n <myenv_name> scipy
    conda install -n <myenv_name> numpy
    conda install -n <myenv_name> -c conda-forge cvxpy
    conda install -n <myenv_name> -c intel scikit-learn

Environments are saved in `/dipc/username/.conda/envs` and you can use them again in a new session. You can check the available conda environments with

    conda env list
Then you are activating this environment in your slurm file:

    #!/bin/bash
    #SBATCH --partition=regular
    #SBATCH --job-name=JOB_NAME
    #SBATCH --cpus-per-task=1
    #SBATCH --mem=200gb
    #SBATCH --nodes=8
    #SBATCH --ntasks-per-node=48

    module load intel/2020a
    module load Python/3.7.6-Anaconda3-2020.02
    conda activate <myenv_name>
    python <filename>.py
    
You can find more info on conda environments in the [conda documentation](https://docs.conda.io/projects/conda/en/4.6.1/user-guide/tasks/manage-environments.html) and in the [DIPC manual](http://dipc.ehu.es/cc/computing_resources/programming/languages/python/python/#default-python-version).
# Atlas FDR
## Job submission
Atlas FDR is based on Torque.
**ON TORQUE YOU NEED TO SEND YOUR JOBS TO THE "bcam" QUEUE INSTEAD OF THE "parallel" QUEUE: **
    
    #PBS -q bcam

# Other actions
## Changing your password

Once your account is created you will be provided a password. However, you can change it just doing:

    passwd
You will be asked to type your current password and the new one.

These are the requirements for the new password:
- A minimum of two uppercase characters.
- A minimum of two lowercase characters.
- A minimum of two digits.
- A minimum of two special characters.
- Password must be at least 8 characters.
- Passwords cannot be repeated or be too similar to the previous ones.
