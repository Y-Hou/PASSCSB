function [cr] = lil(t,rho)
%compute the lil confidence radius
%epsilon = 1/2

cr = (1+sqrt(1/2))*sqrt(0.75./t.*log(log(1.5.*t)/rho));
end