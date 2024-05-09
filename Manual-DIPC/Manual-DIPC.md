# Introduction

This is a basic guide on how to use the HPC systems hosted by the DIPC Supercomputing Center. There are two different hosted HPC systems that we can use: Atlas EDR and Altas FDR

- **Atlas EDR**:	Based on SLURM (like Hipatia). HPC system running a total of 45 nodes and features a total of 2224 cores and 15 TB of distributed memory. Some of the nodes are powered with either one or two NVIDIA Tesla P40 GPGPUS. The network technlogy interconnection the nodes is a fat-tree topology EDR Infiniband at 100 Gbps with a 5:1 blocking factor.

- **Atlas FDR**:	Based on TORQUE. A cluster type HPC system running a total of 210 nodes and features a total of 6100 computing cores and 80 TB of distributed RAM memory. The network technology interconnection the nodes is a FDR Infiniband at 56 Gbps with a fat-tree topology with a 5:1 blocking factor.


# Getting an account
In order to utilize the high performance computing (HPC) resources offered by DIPC, you are required to have a valid DIPC cluster account. 
If you don't possess one yet, you are encouraged to apply for an account.
Please fill out the necessary form, which can be accessed through the following [link](https://scc.dipc.org/docs/access/accounts/files/dipc_account_form.pdf), and send it via email to IT.

# Login

Open a Terminal to establish a connection with the login node of any of out HPC systems:

```
ssh username@atlas-edr.sw.ehu.es # recommended
ssh username@atlas-fdr.sw.ehu.es
```

You will need to replace `username` with the username you were assigned in the confirmation email from DIPC and enter your password.
You will be asked to change your temporal password, and the new password must meet the following criteria:

- It must contain at least two uppercase characters.     
- It must include at least two lowercase characters.
- It must have at least two digits.     
- It must feature at least two special characters.     
- It should be at least 8 characters in length.     
- It should not be a repetition or overly similar to any of your previous passwords.

Please, refer to [SSH](http://dipc.ehu.es/cc/computing_resources/general/connect/ssh/) and [accounts](https://scc.dipc.org/docs/access/accounts/) for more information.

# File system
There is a home directory `/dipc/username` **shared** along the access nodes, Altas EDR and Atlas FDR (it runs on top of a Ceph parallel filesystem). It is intended for permanent file storage, ***not* for running your scripts**. Your shell refers to it as “∼” (tilde), and its absolute path is also stored in the environment variable $HOME. Daily backups of these directories are performed and backups are saved up to 2 months old.

The **directory meant to be used as the work space** for jobs is `/scratch/username`. It is **not shared**: each HPC system has its own `/scratch` directory. It is a shared high performance storage that system provides access to large amounts of disk for short periods of time at much higher speed than `/dipc`.

Remember that `/scratch` filesystems are not meant to be used as a permanent storage solution (the capacity is capped at 1.5 TB).

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

Open FileZilla and set it up as follows:
- Protocol: SFTP - SSH
- Host: atlas-edr.sw.ehu.es
- User: `username`
- Password: your Atlas password
  
### With EHU/UPVs VPN
As long as you are in the subnet using EHU/UPVs VPN, you can establish direct connection with the login nodes and therefore with FileZilla:
New connection:
- Protocol: SFTP
- Host: 
  - For Atlas EDR: `atlas-edr-login-01.sw.ehu.es` or `atlas-edr-login-02.sw.ehu.es` 
  - For Atlas FDR: `atlas-fdr-login-01.sw.ehu.es` or `atlas-fdr-login-02.sw.ehu.es` 
- Port: 22
- User: username

# Atlas EDR
## Job submission
Atlas EDR is based on Slurm, like BCAM's cluster Hipatia (You can see a wider description of this in [Hipatia's manual](https://github.com/MachineLearningBCAM/How-To/blob/main/Manual-Hipatia/hipatia.md) or directly in [DIPC Documentation](http://dipc.ehu.es/cc/computing_resources/systems/atlas-edr/)). There are some differences like the available partitions or how to load modules. To submit a job it is recommended to write a `.sl` file to simplify the commands that we write in the cluster to run our scripts. Simple example:

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
    
*Note*: if your ATLAS account was not activated correctly, when using BCAM's exclusive partition, the following error can be raised
```
sbatch: error: Batch job submission failed: Invalid account or account/partition combination specified
```
In this case, the unique solution is to contact DIPC's support.

*Note*: The total memory of each node in the bcam-exclusive partition is 96GB. Therefore the specification `--mem-per-cpu` cannot exceed this limit. If you need more memory, yoy can run your job in a shared DIPC node.

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

***TEMPORARY REMOVAL OF AC-01 AND AC-02 ACCESS NODES AND UNMOUNTING OF /DIPC ON ATLAS-EDR COMPUTING NODES***

***Additionally of the removal of the AC nodes, DIPC haS also unmounted the /dipc filesystem from all EDR computing nodes in order to minimize the accesses to it, since with the recent growth of users we were starting to have problems with it. So now, for a computing node to have access to your environment [you should move it to your /scratch folder](http://dipc.ehu.es/cc/computing_resources/programming/languages/python/python/#creating-an-environment-in-a-custom-location). If you don want to create a new environment from scratch, you can just clone your current environment:***

    conda create --prefix /scratch/cguerrero/conda-envs/<environment_name> --clone <my_original_environment_name>
    
***And then just call this environment on the .sl file:***

    conda activate /scratch/cguerrero/conda-envs/<environment_name>


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

### MATLAB
Different versions of MATLAB can be listed by using the `module spider` command as shown below:
```
module spider MATLAB
```
Since Atlas EDR is based on SLURM, the procedure to submit a job is the same as in Hipatia. 
However, the `.sl` will be stilightly different.
To run a MATLAB script, say `test.m`, we need to both load MATLAB and execute the script in the `.sl` file:
```
module load MATLAB/R2020b
matlab -nodisplay -nosplash -singleCompThread < test.m > output.log
```

Here is an example illustrating how to use MATLAB with cvx at ATLAS.
In order to properly use cvx, the folder should be located inside `/scratch/username`.
If we do not place the cvx folder in the same directory as the main script, we will have to add the MATLAB `addpath` function in our main script, and specify the relative path of the folder.

For instance, consider the following `slurm.sl` file
```
#!/bin/bash
#SBATCH --partition=bcam-exclusive
#SBATCH --account=bcam-exclusive
#SBATCH --job-name=MATLAB_test
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err

module load MATLAB/R2020b

matlab -nodisplay -nosplash -singleCompThread < test.m > output.log
```
together with the following MATLAB script `test.m`:
```
clear
addpath("../cvx")
cvx_setup
cvx_solver mosek
cvx_save_prefs
m = 16; n = 8;
A = randn(m,n);
b = randn(m,1);
x_ls = A \ b;
cvx_begin quiet
    variable x(n)
    minimize( norm(A*x-b) )
cvx_end
mkdir("results")
save("results/solutions.mat","x","x_ls")
exit
```
The job is submitted using `sbatch`
```
sbatch slurm.sl
```

*Note*: It is recommended to end your main script with an `exit` statement to ensure MATLAB quits after execution.



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
