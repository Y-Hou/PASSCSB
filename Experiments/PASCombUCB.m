function [regret, reward, violation] = PASCombUCB(T,delta,para,super,sigma2,bsigma2,expec,variance)
%Probably Anytime-Safe Combinatorial UCB
%Input Parameters:
%T  Time horizon
%delta  The confidence parameter for safeness
%para   The arms (parameters for the arms)
%sigma2 The subGaussian parameter (1/4 in [0,1] case)
%bsigma2    The threshold on the risk/variance
%variance   The true variance (used for violation count)

%Output Parameters:
%regret The cumulative regret over T
%violation  The number of times an unsafe super arm is pulled

K=3;
L=size(para,1);

%initialize regret and violation
regret = 0;
violation = 0;

%confidence parameters
omega_mu = 1/T^2;
omega_v = delta/T^2;

%arm pull counter
basearm = (1:L)';
count = zeros(L,1);
cmean = zeros(L,1);     %cumulative mean
smean = zeros(L,1);     %sample mean
sec = zeros(L,1);       %second moment
svar = zeros(L,1);      %sample variance
cr = zeros(L,1);        %confidence radius
crv = zeros(L,1);       %confidence radius for variance  
%phase counter
p = 1;
%step counter
t = 1;
%max number of items in absolutely safe super arms
q = ceil(bsigma2/sigma2);

tic
%warm-up
basearm_temp = basearm(count<2);
while ~isempty(basearm_temp)
    Ap = zeros(1,L,'logical');
    if length(basearm_temp) >= q
        Ap_temp = basearm_temp(1:q);
    else
        temp_length = q - length(basearm_temp);
        basearm_temp2 = setdiff(basearm,basearm_temp);
        Ap_temp = [basearm_temp;basearm_temp2(1:temp_length)];
    end
    Ap(Ap_temp) = 1;    
    sample = pull_super(Ap,para);
    p = p + 1;
    t = t + 1;
    count(Ap) = count(Ap) + 1;
    cmean(Ap) = cmean(Ap) + sample;
    smean(Ap) = cmean(Ap)./count(Ap);
    sec(Ap)=sec(Ap)+sample.^2;
    svar(Ap)=sec(Ap)./count(Ap)-smean(Ap).^2;
    basearm_temp = basearm(count<2);
    %violation detection
    violation = violation + (Ap*variance > bsigma2);
end
    cr = lil(count,omega_mu);
    crv = lil(count,omega_v);
    UCB_v = min(svar + 3* crv, sigma2);
    LCB_v = max(svar - 3 * cr, 0);
    UCB_mu = smean + cr;
    super_LCB_v = super * LCB_v;
    Safe_pb = super(super_LCB_v < bsigma2,:);
    super_UCB_mu = Safe_pb * UCB_mu;
    %end of warm-up

while t < T
    [~,index] = max(super_UCB_mu);
    Ap = Safe_pb(index,:);
    %Here we do not split the super arm Ap into subsuper arms explicitly.
    %Instead, we compute the number of subsuper arms.
    %This can increase the efficiency of the experiment.
    %It also computes the number of violations in this phase
    [np,n_violation] = GreedySplit(Ap,UCB_v,bsigma2,variance,K);
%     violation = violation + (Ap*variance > bsigma2);
    violation = violation + n_violation;
    np = min(np,T-t);
    sample = pull_super(Ap,para);
    %update the statistics
    count(Ap) = count(Ap) + 1;
    cmean(Ap) = cmean(Ap) + sample;
    smean(Ap) = cmean(Ap)./count(Ap);
    sec(Ap) = sec(Ap)+sample.^2;
    svar(Ap) = sec(Ap)./count(Ap)-smean(Ap).^2;
    cr = lil(count,omega_mu);
    crv = lil(count,omega_v);
    UCB_v = min(svar + 3* crv, sigma2);
    LCB_v = max(svar - 3 * cr, 0);
    UCB_mu = smean + cr;
    super_LCB_v = Safe_pb * LCB_v;
    %update the empirical possibly safe set
    super_temp = super_LCB_v < bsigma2;
    Safe_pb = Safe_pb(super_temp,:);
    super_LCB_v = super_LCB_v(super_temp);
    super_UCB_mu = Safe_pb * UCB_mu;

    p = p + 1;
    t = t + np;
    Safe_pb = Safe_pb(super_LCB_v < bsigma2,:);

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
