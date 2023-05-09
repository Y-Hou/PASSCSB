function [sample] = pull_super(Ap,para)
%pull a super arm Ap
%output the vector of samples from each item

paras = para(Ap',:);
sample = betarnd(paras(:,1),paras(:,2));

end