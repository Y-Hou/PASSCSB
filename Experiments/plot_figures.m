close all;

% indicator = 1;

%  indicator = 2;

indicator = 3;

if indicator ==1
    
    load('experiment_results_trials.mat');
    
    %process the results
    average = mean(collect,3);
    stand_dv = std (collect,0,3);

    %plot figures
    f=figure(1);
    Thorizon = (0:s)'*10^5;
    errorbar(Thorizon,[0;average(:,1)],[0;stand_dv(:,1)],'-o');
    hold on;
    errorbar(Thorizon,[0;average(:,2)],[0;stand_dv(:,2)],'-^');
    hold on;
    errorbar(Thorizon,[0;average(:,3)],[0;stand_dv(:,3)],'-*');
    ylabel('Cumulative reward');
    xlabel('Time horizon $T$','Interpreter','latex');
    legend('PASCombUCB with $\bar{\sigma}^2=0.6$','PASCombUCB with $\bar{\sigma}^2=0.751$', ...
        'CombUCB1','Interpreter','latex','Location','northwest');
%     title('Experiment 1: the cumulative reward v.s. $T$','Interpreter','latex');
    set(gca, 'Fontname', 'Times New Roman','FontSize',16);
    str=['Experiment_1_reward','.eps'];
    exportgraphics(f,str);
    %%
    regret_add = [0;average(:,4)] -[0;average(:,5)];
    std_add = sqrt([0;stand_dv(:,4).^2] + [0;stand_dv(:,5).^2]);
    g=figure(2);
    errorbar(Thorizon,[0;average(:,4)],[0;stand_dv(:,4)],'-o');
    hold on;
    errorbar(Thorizon,[0;average(:,5)],[0;stand_dv(:,5)],'-^');
    hold on;
    errorbar(Thorizon,[0;average(:,6)],[0;stand_dv(:,6)],'-*');
    errorbar(Thorizon,regret_add,std_add,'-x');
    ylabel('Cumulative regret');
    xlabel('Time horizon $T$','Interpreter','latex');
    legend('PASCombUCB with $\bar{\sigma}^2=0.6$','PASCombUCB with $\bar{\sigma}^2=0.751$', ...
        'CombUCB1','Additional regret','Interpreter','latex','Location','east');
%     title('Experiment 1: the cumulative regret v.s. $T$','Interpreter','latex');
    set(gca, 'Fontname', 'Times New Roman','FontSize',16);
    str=['Experiment_1_regret','.eps'];
    exportgraphics(g,str);

    %%
elseif indicator ==2
        
    load('experiment_results_violation_trials.mat');

    %process the results
    average = mean(collect,3);
    stand_dv = std (collect,0,3);
    f21=figure(21);
    %plot figures
    Thorizon = (0:s)'*5*10^5;
    errorbar(Thorizon,[0;average(:,1)],[0;stand_dv(:,1)],'-o');
    hold on;
    errorbar(Thorizon,[0;average(:,2)],[0;stand_dv(:,2)],'-^');
    ylabel('Cumulative reward');
    xlabel('Time horizon $T$','Interpreter','latex');
    legend('PASCombUCB with $\bar{\sigma}^2=0.4$', ...
        'CombUCB1','Interpreter','latex','Location','northwest');
    for i=1:s
        percent=100*average(i,5)/(i*5*10^5);
        text((i-0.2)*5*10^5,average(i,1)-2*10^5,[num2str(percent,'%3.2f'),'%'],'Fontname', 'Times New Roman','FontSize',14)
    end
    for i=1:s
        percent=100*average(i,6)/(i*5*10^5);
        text((i-0.5)*5*10^5,average(i,2)+2.5*10^5,[num2str(percent,'%3.2f'),'%'],'Fontname', 'Times New Roman','FontSize',14)
    end
%     title('Experiment 2: the cumulative reward v.s. $T$','Interpreter','latex');
    set(gca, 'Fontname', 'Times New Roman','FontSize',16);
    str=['Experiment_2_reward','.eps'];
    exportgraphics(f21,str);
    
    regret_add = [0;average(:,3)] -[0;average(:,4)];
    std_add = sqrt([0;stand_dv(:,3).^2] + [0;stand_dv(:,4).^2]);
    f22=figure(22);
    errorbar(Thorizon,[0;average(:,3)],[0;stand_dv(:,3)],'-o');
    hold on;
    errorbar(Thorizon,[0;average(:,4)],[0;stand_dv(:,4)],'-^');
    hold on;
    errorbar(Thorizon,regret_add,std_add,'-x');
    ylabel('Cumulative regret');
    xlabel('Time horizon $T$','Interpreter','latex');
    legend('PASCombUCB with $\bar{\sigma}^2=0.4$', ...
        'CombUCB1','Additional regret','Interpreter','latex','Location','east');
%     title('Experiment 2: the cumulative regret v.s. $T$','Interpreter','latex');
    set(gca, 'Fontname', 'Times New Roman','FontSize',16);
    saveas(gcf,'Experiment_2_regret','eps');
    str=['Experiment_2_regret','.eps'];
    exportgraphics(f22,str);

    f23=figure(23);
    errorbar(Thorizon,[0;average(:,5)],[0;stand_dv(:,5)],'-o');
    hold on;
    errorbar(Thorizon,[0;average(:,6)],[0;stand_dv(:,6)],'-^');
    ylabel('Violations');
    xlabel('Time horizon $T$','Interpreter','latex');
    legend('PASCombUCB with $\bar{\sigma}^2=0.4$','CombUCB1', ...
        'Location','northwest','Interpreter','latex');
%     title('Experiment 2: the number of violations v.s. $T$','Interpreter','latex');
    set(gca, 'Fontname', 'Times New Roman','FontSize',16);
    str=['Experiment_2_violations','.eps'];
    exportgraphics(f23,str);

elseif indicator ==3
        
    load('experiment_results_reg_add_vs_Delta.mat');
    %process the results
    average = mean(collect,3);
    stand_dv = std (collect,0,3);
    Delta = 1./(0.14*1.2.^(0:9)-0.03).^2;
    regret_add = average(:,3) - average(:,4);
    std_add = sqrt(stand_dv(:,3).^2 + stand_dv(:,4).^2);

%%
    f33=figure(33);
    errorbar(Delta,regret_add,std_add,'o');
    ylabel('Additional regret');
    xlabel('$1/(\Delta_S^v)^2$','Interpreter','latex');

    hold on;
    p = polyfit(Delta, regret_add, 1);
    regret_add_fit = polyval(p,Delta)';
    x_max=max(Delta);
    x_min=min(Delta);
    x1=x_min:1:9/8*x_max;
    plot(x1, polyval(p, x1));

    legend('Additional Regret','Linear fit','Location','northwest');

    SStot = sum((regret_add-mean(regret_add)).^2);      % Total Sum-Of-Squares
    SSres = sum((regret_add-regret_add_fit).^2);        % Residual Sum-Of-Squares
    Rsq = 1-SSres/SStot;
    text(60,10^6,['R^2=',num2str(Rsq)],'Fontname', 'Times New Roman','FontSize',14);
%     title('Experiment 3: the additional regret v.s. $1/(\Delta_S^v)^2$','Interpreter','latex');
    set(gca, 'Fontname', 'Times New Roman','FontSize',16);
    saveas(gcf,'Experiment_3_AddReg','eps');
    str=['Experiment_3_AddReg','.eps'];
    exportgraphics(f33,str);
    
end

