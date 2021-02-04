% Orthogonalized Impulse Responses
orient tall   
t = (0:Tirf-1)';
ncol = 6;

%'Figure a: IRFs to the first 5 shocks'
nrow = 5;
h = figure;
for ngcom = 1:5
    readGCom; %define varnames, depending on data & global shock
    IR = 10*sIR(:,:,k,ngcom); %to 10% global comm. price shock
    IR1 = 10*sIR1(:,:,k,ngcom);
    IR2 = 10*sIR2(:,:,k,ngcom);
    for j = 1:nvar
        subplot(nrow,ncol,j+(ngcom-1)*nvar)
        plot(t,IR(:,j),'b-','LineWidth',1.25);
        hold on
        plot(t,IR1(:,j),'b--',t,IR2(:,j),'b--','LineWidth',0.25);
        hold off
        title(varnames{j})
    end %for j=1:nvar
end %for ngcom=1:5
suptitle_a = strcat(regionnames{k},': Impulse responses');
suptitle(suptitle_a);


%'Figure b: IRFs to the last 6 shocks'
nrow = 6;
h = figure;
for ngcom = 6:11
    readGCom;
    IR = 10*sIR(:,:,k,ngcom);
    IR1 = 10*sIR1(:,:,k,ngcom);
    IR2 = 10*sIR2(:,:,k,ngcom);
    for j = 1:nvar
        subplot(nrow,ncol,j+(ngcom-6)*nvar)
        plot(t,IR(:,j),'b-','LineWidth',1.25);
        hold on
        plot(t,IR1(:,j),'b--',t,IR2(:,j),'b--','LineWidth',0.25);
        hold off
        title(varnames{j})
    end
end
suptitle_a = strcat(regionnames{k},': Impulse responses (cont.)');
suptitle(suptitle_a);