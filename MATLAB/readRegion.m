    [numcn,regionnames] = xlsread('regionnames.xlsx');%region names
    nreg = size(regionnames,1); %number of regions
    shocknames = {'Energy price';'Agriculture price';'Beverages price';'Food price';'Vegetable oils and meals price';'Cereal price';'Other food price';'Raw materials price';'Timber price';'Other raw materials price';'Metal price'};%global shock names
%create balanced data 'region' as cell
    for k = 1:nreg
        region(:,:,k) = xlsread('region.xlsx',k); %each page is a region
        %transform variables: country macro variables
        unemp(:,k) = region(2:end,16,k); % col 16 = unemployment
        infl(:,k) = region(2:end,17,k); % col 17 = q-o-q inflation
    end
%transformed variables: global com. price: same across regions
        energy = 100*(log(region(2:end,1,1)) - log(region(1:end-1,1,1)));
        agri = 100*(log(region(2:end,2,1)) - log(region(1:end-1,2,1)));
        bev = 100*(log(region(2:end,3,1)) - log(region(1:end-1,3,1)));
        food = 100*(log(region(2:end,4,1)) - log(region(1:end-1,4,1)));
        fats = 100*(log(region(2:end,5,1)) - log(region(1:end-1,5,1)));
        cereal = 100*(log(region(2:end,6,1)) - log(region(1:end-1,6,1)));
        otfood = 100*(log(region(2:end,7,1)) - log(region(1:end-1,7,1)));
        material = 100*(log(region(2:end,8,1)) - log(region(1:end-1,8,1)));
        timber = 100*(log(region(2:end,9,1)) - log(region(1:end-1,9,1)));
        otmaterial = 100*(log(region(2:end,10,1)) - log(region(1:end-1,10,1)));
        metal = 100*(log(region(2:end,11,1)) - log(region(1:end-1,11,1)));
        %transform variables: country comm. TOT: same across regions
        totr = 100*(log(region(2:end,12,1)) - log(region(1:end-1,12,1))); % col 12 = TOT, rolling weighted by trade balance
        totgdpr = 100*(log(region(2:end,13,1)) - log(region(1:end-1,13,1))); % col 13 = TOT, rolling weighted by GDP
        totf = 100*(log(region(2:end,14,1)) - log(region(1:end-1,14,1))); % col 14 = TOT, fixed weighted by trade balance
        totgdpf = 100*(log(region(2:end,15,1)) - log(region(1:end-1,15,1))); % col 15 = TOT, fixed weighted by GDP
        %transform variables: country macro variables: same across regions
        int = region(2:end,18,1); % col 18 = interest rate
        ex = 100*(log(region(2:end,19,1)) - log(region(1:end-1,19,1))); % col 19 = real exchange rate
%full transformed data
    for k = 1:nreg
        yall(:,:,k) = [energy agri bev food fats cereal otfood material timber otmaterial metal totr totgdpr totf totgdpf unemp(:,k) infl(:,k) int ex];
    end
%5 domestic varibles
    ntot = 12; %can change to column 13-14-15 for other commodity TOT indices
    necon = 16; %unemployment
    ninf = 17;
    nir = 18;
    nrer = 19;