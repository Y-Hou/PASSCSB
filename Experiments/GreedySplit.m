function [np,n_violation] = GreedySplit(Ap,UCB_v,bsigma2,variance,K)
%This function greedily split the super arm Ap and outputs the number of
%subsuper arms np

n = sum(Ap);
np = 1;
n_violation = 0;
s = 1;
Ap_UCB = UCB_v(Ap');
Ap_v = variance(Ap');
u = 0;
v = 0;
k=0;

if sum(Ap_UCB) >= bsigma2
    while s <= n 
        if (u + Ap_UCB(s) < bsigma2)  && (k < K)
            u = u + Ap_UCB(s);
            v = v + Ap_v(s);
            k = k + 1;
        else
            np = np + 1;
            u = Ap_UCB(s);
            n_violation = n_violation + (v>bsigma2);
            v = Ap_v(s);
            k = 1;
        end
        s = s + 1;
    end
end

end
