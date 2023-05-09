function [regret, reward, violation] = ComUCB1(T,para,super,sigma2,bsigma2,expec,variance)
%CombUCB1 in Kevton2015
%Input Parameters:
%T  Time horizon
%para   The arms (parameters for the arms)
%sigma2 The subGaussian parameter (1/4 in [0,1] case)
%bsigma2    The threshold on the risk/variance (used to compute number of violations
%expec      The true expectation (used to compute the true regret)
%variance   The true variance (used for violation count)

%Output Parameters:
%regret The cumulative regret over T
%violation  The number of times an unsafe super arm is pulled

K=3;
L=size(para,1);

%initialize regret and violation
regret = 0;
violation = 0;

%% initialization of CombUCB1
count = zeros(L,1);     %arm pull counter
cmean = zeros(L,1);     %cumulative mean
smean = zeros(L,1);     %sample mean
cr = zeros(L,1);        %confidence radius

%step counter
t = 0;

tic

u = ones(L,1);
while sum(u) > 0
    f_temp = super * u;
    [~,index] = max(f_temp);
    At = super(index,:);  
    sample = pull_super(At,para);    
    count(At) = count(At) + 1;
    cmean(At) = cmean(At) + sample;
    smean(At) = cmean(At)./count(At);
    u(At) = 0;
    t = t + 1;
    %violation detection
    violation = violation + (At*variance > bsigma2);
end
%end of initialization
    

while t < T
    %compute UCBs
    cr = sqrt(1.5.*log(t-1)./count);
    UCB_mu = smean + cr;
    %find the max UCB
    super_UCB_mu = super * UCB_mu;
    [~,index] = max(super_UCB_mu);
    At = super(index,:);
    %observe the weights of chosen items
    sample = pull_super(At,para);

    %update the statistics
    count(At) = count(At) + 1;
    cmean(At) = cmean(At) + sample;
    smean(At) = cmean(At)./count(At);

    t = t + 1;
    
    %violation detection
    violation = violation + (At*variance > bsigma2);
    
    
end
toc
%%
% count
% cr
%%
%compute the regret
reward = sum(cmean);
super_variance = super * variance;
safe_super = super(super_variance < bsigma2,:);
mu_max = max(safe_super*expec);
regret = T*mu_max - reward;
end
