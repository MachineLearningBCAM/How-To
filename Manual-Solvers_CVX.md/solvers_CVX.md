# Introduction

This is the basic guide on how to install the Mosek and gurobi cvx solvers. For more information, go to [Gurobi](http://cvxr.com/cvx/doc/gurobi.html) or [Mosek](http://cvxr.com/cvx/doc/mosek.html).

## Gurobi

### Get the Licence

First of all we need to get the licence to use Gurobi.
We go to [Gurobi Register](https://www.gurobi.com/downloads/end-user-license-agreement-academic/) and register in the website to get an account.
In the university section, we can just write BCAM.
Once the account is created, just go to [Gurobi Licence Registration](https://www.gurobi.com/downloads/end-user-license-agreement-academic/) again and accept the conditions.
You will recieve an Academic Licence Detail, we need to copy the number **cvx_grbgetkey xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx**, it is the number of our licence key.

### Download Gurobi

We can download the cvx with all the solvers in the page [Download cvx](http://cvxr.com/cvx/download/).
We do not need to do anything different from when we download cvx.

### Use Gurobi Solver

To start using Gurobi solver, we need to open `/cvx/gurobi/maci64/grbgetkey`. We will get the following message:

    Enter the Key Code for the license you are activating
    (format is xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx):

Just paste the number of the licence.
Then it will return you the following message

    In which directory would you like to store the Gurobi license key file?
    [hit Enter to store it in /Users/_userid_]: 
    
Just hit Enter and that is it.

After that, the only thing you need to do to use it is run on your Matlab:

    cvx_setup
    cvx_solvers gurobi
    
To set it as default solver, run

    cvx_save_prefs
    
## Mosek

### Get the Licence

As with Gurobi, we need to request an academic licence.
We go to [Mosek Academic Licence](https://www.mosek.com/products/academic-licenses/) and request for a Personal Academic Licence.
Write BCAM on the organization section.

### Download Mosek

We can download the cvx with all the solvers in the page [Download cvx](http://cvxr.com/cvx/download/).
We do not need to do anything different from when we download cvx.

### Use Mosek Solver

To use the mosek solver, we need to wait until we receive the mail from mosek with the file **mosek.lic**. Then, go to `/Users/_userid_`, create a folder `/Users/_userid_/mosek` and copy the .lic file there.

After that, the only thing you need to do to use it is run on your Matlab:

    cvx_setup
    cvx_solvers mosek
    
To set it as default solver, run

    cvx_save_prefs
