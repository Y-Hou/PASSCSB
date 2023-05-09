%This document generates the instance

rng(20);


sigma2 = 0.25;
L = 10;
K = 3;
delta = 0.05;

mean_variance = [0.5 0.24;
    0.45 0.24;
    0.4  0.04;
    0.35 0.01;
    0.3*ones(L-4,1), 0.01*ones(L-4,1)];

% compute the beta distribution parameters by their means and variances
para=bpara(mean_variance(:,1),mean_variance(:,2));
alpha=para(:,1);
beta=para(:,2);
expec=alpha./(alpha+beta);
variance=(alpha.*beta)./((alpha+beta).^2.*(alpha+beta+1));


%generate the set of super arms
basearm = (1:L)';
super=[];
for k = K:-1:1
    sub = nchoosek(basearm,k);
    superk = zeros(size(sub,1),L,'logical');  %convert it to the one-hot matrix, where each row is a super arm
    for i = 1:size(sub,1)
        superk(i,sub(i,:)) = 1;
    end
    super = [super;
            superk];
end
super = super>0;

% threshold on the variance
bsigma2 = 0.4;
super_variance = super * variance;
safe_super = super(super_variance < bsigma2,:);
mu_max = max(safe_super*expec);

%%
% get multipe trials

trial = 10;
iter = 10;
collect_reward = zeros(iter,2);
collect_regret = zeros(iter,2);
collect_violation = zeros(iter,2);
collect = zeros(iter,6,trial);
for trial_index = 1:trial
    trial_index
    for s = 1:iter

        s

        T = 5 * s * 10^5;
        
        oracle_reward = T*mu_max;
        
        % PASCombUCB
        [regret, reward, violation] = PASCombUCB(T,delta,para,super,sigma2,bsigma2,expec,variance);
        
        % ComUCB1
        [regret2, reward2, violation2] = ComUCB1(T,para,super,sigma2,bsigma2,expec,variance);
        regret2 = oracle_reward - reward2;

        collect_reward(s,:) = [reward,reward2];
        collect_regret(s,:) = [regret,regret2];
        collect_violation(s,:) = [violation,violation2];
    end
    collect(:,:,trial_index) = [collect_reward,collect_regret,collect_violation];
end

% save data
save("experiment_results_violation_trials.mat");

