% Cumulative Impulse Responses
orient tall   
t = (0:Tirf-1)';
ncol = 6;

%'Figure a: Cumulative IRFs to the first 5 shocks'
nrow = 5;
h = figure;
for ngcom = 1:5
    readGCom;
    IR = 10*scIR(:,:,k,ngcom);
    IR1 = 10*scIR1(:,:,k,ngcom);
    IR2 = 10*scIR2(:,:,k,ngcom);
    for j = 1:nvar
        subplot(nrow,ncol,j+(ngcom-1)*nvar)
        plot(t,IR(:,j),'b-','LineWidth',1.25);
        hold on
        plot(t,IR1(:,j),'b--',t,IR2(:,j),'b--','LineWidth',0.25);
        hold off
        title(varnames{j})
    end
end
suptitle_a = strcat(regionnames{k},': Cumulative impulse responses');
suptitle(suptitle_a);

%'Figure b: Cumulative IRFs to the last 6 shocks'
nrow = 6;
h = figure;
for ngcom = 6:11
    readGCom;
    IR = 10*scIR(:,:,k,ngcom);
    IR1 = 10*scIR1(:,:,k,ngcom);
    IR2 = 10*scIR2(:,:,k,ngcom);
    for j = 1:nvar
        subplot(nrow,ncol,j+(ngcom-6)*nvar)
        plot(t,IR(:,j),'b-','LineWidth',1.25);
        hold on
        plot(t,IR1(:,j),'b--',t,IR2(:,j),'b--','LineWidth',0.25);
        hold off
        title(varnames{j})
    end
end
suptitle_a = strcat(regionnames{k},': Cumulative impulse responses (cont.)');
suptitle(suptitle_a);