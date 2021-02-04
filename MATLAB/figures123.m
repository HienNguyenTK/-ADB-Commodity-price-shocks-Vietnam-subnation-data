
%Figure 1: Global real commodity prices, level
readCountry; %data
orient tall   
time = (1996.25:0.25:2020.5)';
figure(1);
for jj = 1:11
    subplot(3,4,jj)
    plot(time,country(:,jj),'k-','LineWidth',1.25);
    title(shocknames{jj})
end

%Figure 2: Global real commodity prices, % of GDP
readCountry; %data
orient tall   
time = (1996.25:0.25:2020.5)';
figure(2);
for jj = 1:11
    subplot(3,4,jj)
    plot(time(2:end),yall(:,jj),'k-','LineWidth',1.25);
    title(shocknames{jj})
end

%Figure 3: Vietnam's commodity trade
load figure3.txt
figure(3);
plot(figure3(:,1),figure3(:,2),'g','LineWidth',1.5);
hold on
plot(figure3(:,1),figure3(:,3),'--b','LineWidth',1.5);
plot(figure3(:,1),figure3(:,4),':rs','LineWidth',1.5);
plot(figure3(:,1),figure3(:,5),'-.k*','LineWidth',1.5);
hold off
xlabel('Year')
ylabel('Percent of GDP')
legend('Agriculture net export', 'Energy net export', 'Metal net export', 'Commodity net export');

