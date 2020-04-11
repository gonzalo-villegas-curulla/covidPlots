
clear all
close all
delete time_series_covid19_confirmed_global.csv

% url = ['https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'];

url = ['https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'];

filename = 'time_series_covid19_confirmed_global.csv';
options = weboptions('TimeOut',Inf);
outputfilename = websave(filename, url, options)

data = readtable('time_series_covid19_confirmed_global.csv');
% data = readtable('time_series_19-covid-Confirmed_global.csv'); %
% Deprecated

country = [18 20 161 408];

LL = size(data); LL = LL(2);

temp = data(1,5:LL);
for n = 1:LL-4, t(n) = temp.(n); end
t = cellfun(@str2num,t); t = t'; t = t(2:end);

temp = data(139,5:LL);
for n = 1:LL-4, italy(n) = temp.(n); end

temp = data(203,5:LL);
for n = 1:LL-4, spain(n) = temp.(n); end

temp = data(118,5:LL);
for n = 1:LL-4, france (n) = temp.(n); end

temp = data(225,5:LL);
for n = 1:LL-4, uk(n) = temp.(n); end

spain = cellfun(@str2num,spain); spain = spain';
france  = cellfun(@str2num,france); france = france';
italy = cellfun(@str2num,italy); italy = italy';
uk = cellfun(@str2num,uk); uk = uk';

figure,
plot(france(2:end)./france(1:end-1), 'linewidth',1),
% ylim([0 7]),
grid on, hold on
plot(spain(2:end)./spain(1:end-1), 'linewidth',1),
plot(italy(2:end)./italy(1:end-1), 'linewidth',1),
plot(uk(2:end)./uk(1:end-1), 'linewidth',1),

% figure,
% plot((france(3:end)-france(2:end-1))./(france(2:end-1)-france(1:end-2)), 'linewidth',1)
% ylim([0 7]), grid on, hold on
% plot((spain(3:end)-spain(2:end-1))./(spain(2:end-1)-spain(1:end-2)), 'linewidth',1)
% plot((italy(3:end)-italy(2:end-1))./(italy(2:end-1)-italy(1:end-2)), 'linewidth',1)
% plot((uk(3:end)-uk(2:end-1))./(uk(2:end-1)-uk(1:end-2)), 'linewidth',1)
legend('france','spain','italy','uk');
%%%%%%%%%%%%
figure
subplot(221), plot(spain), yyaxis right, plot(gradient(spain)), hold on, plot(del2(spain)), legend('spain','grad','del2','location','northwest'), grid on
title('Total confirmed cases');
subplot(222), plot(italy), yyaxis right, plot(gradient(italy)), hold on, plot(del2(italy)), legend('italy','grad','del2','location','northwest'), grid on
subplot(223), plot(france), yyaxis right, plot(gradient(france)), hold on, plot(del2(france)), legend('france','grad','del2','location','northwest'), grid on
subplot(224), plot(uk), yyaxis right, plot(gradient(uk)), hold on, plot(del2(uk)), legend('uk','grad','del2','location','northwest'), grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% New cases

ESP = [0; spain(2:end)-spain(1:end-1)];
ESPor = ESP;
ESP(5:end) = (ESP(5:end) +ESP(4:end-1) +ESP(3:end-2) +ESP(2:end-3) +ESP(1:end-4) )/5; ESP = [0;0;0;0; ESP];

IT  = [0; italy(2:end)-italy(1:end-1)];
ITor = IT;
IT(5:end) = (IT(5:end) +IT(4:end-1) +IT(3:end-2) +IT(2:end-3) +IT(1:end-4) )/5; IT = [0;0;0;0; IT];

FR  = [0; france(2:end)-france(1:end-1)];
FRor = FR;
FR(5:end) = (FR(5:end) +FR(4:end-1) +FR(3:end-2) +FR(2:end-3) +FR(1:end-4) )/5; FR = [0;0;0;0; FR];

UK  = [0; uk(2:end)-uk(1:end-1)];
UKor = UK;
UK(5:end) = (UK(5:end) +UK(4:end-1) +UK(3:end-2) +UK(2:end-3) +UK(1:end-4) )/5; UK = [0;0;0;0; UK];

figure
subplot(221), yyaxis left, plot(ESPor), hold on, plot(ESP), ylim([-0.66*max(ESP) 1.05*max(ESP)]);
    yyaxis right, plot(gradient(ESP)), hold on, plot(del2(ESP)), legend('spain','5dayav','grad','del2','location','northwest'), grid on, ylim([1.05*min(min(gradient(ESP)),min(del2(ESP))), 2.5*max(max(gradient(ESP)),max(del2(ESP)))]);
title('Confirmed new cases');

subplot(222), yyaxis left, plot(ITor), hold on, plot(IT), ylim([-0.66*max(IT) 1.05*max(IT)]);
    yyaxis right, plot(gradient(IT)), hold on, plot(del2(IT)), legend('italy','5dayav','grad','del2','location','northwest'), grid on, ylim([1.05*min(min(gradient(IT)),min(del2(IT))), 2.5*max(max(gradient(IT)),max(del2(IT)))]);

subplot(223), yyaxis left, plot(FRor), hold on, plot(FR), ylim([-0.66*max(FR) 1.05*max(FR)]);
    yyaxis right, plot(gradient(FR)), hold on, plot(del2(FR)), legend('france','5dayav','grad','del2','location','northwest'), grid on, ylim([1.05*min(min(gradient(FR)),min(del2(FR))), 2.5*max(max(gradient(FR)),max(del2(FR)))]);


subplot(224), yyaxis left, plot(UKor), hold on, plot(UK), ylim([-0.66*max(UK) 1.05*max(UK)]);
    yyaxis right, plot(gradient(UK)), hold on, plot(del2(UK)), legend('uk','5dayav','grad','del2','location','northwest'), grid on, ylim([1.05*min(min(gradient(UK)),min(del2(UK))), 2.5*max(max(gradient(UK)),max(del2(UK)))]);
