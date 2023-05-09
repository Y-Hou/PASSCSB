# PASSCSB
Code for ``Probably Anytime-Safe Stochastic Combinatorial Semi-Bandits'' 

"main_iteration_exp1.m" creates an instance and runs experiment 1 multiple times and finally outputs a ".mat" file. By running "plot_figures.m", the figures for experiment 1 can be plotted. Similarly for "main_iteration_exp2.m" and "main_iteration_exp3.m".

The original results are provided (the three files ending with ".mat") in order to save the running time.

**Code list**:
- bpara.m
- ComUCB1.m
- GreedySplit.m
- lil.m
- main_iteration_exp1.m
- main_iteration_exp2.m
- main_iteration_exp3.m
- PASCombUCB.m
- plot_figures.m
- pull_super.m
- experiment_results_reg_add_vs_Delta.mat
- experiment_results_trials.mat
- experiment_results_violation_trials.mat
