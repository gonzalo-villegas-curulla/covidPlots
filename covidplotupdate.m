
clear all
close all
delete time_series_covid19_confirmed_global.csv
if (exist([pwd '\images\figure1.png'])) ~= 0
    delete([pwd '\images\figure1.png']);
end

% url = ['https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'];

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Acquire data
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~


url = ['https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'];

filename = 'time_series_covid19_confirmed_global.csv';
options = weboptions('TimeOut',Inf);
% outputfilename = websave(filename, url, options);
websave(filename, url, options);

data = readtable('time_series_covid19_confirmed_global.csv');

% For deprecated older files only
% country = [18 20 161 408]; % [It, Esp, Fr, UK]

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Prepare series
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Convert data
LL = size(data); LL = LL(2);  % Shorthand for vector length

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


% Create time series

ESP = [0; spain(2:end)-spain(1:end-1)];
ESPor = ESP; % -or termination for new cases series without 5-day moving average
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

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Plot new cases
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~


fig1 = figure('Name','Confirmed new cases','Units','Normalized', 'OuterPosition',[0 0 1 1]);

% Spain
ESPh = subplot(221); yyaxis left, plot(ESPor), hold on, plot(ESP);
    ESPbelowlim = -0.66*max(ESPor);
    ESPabovelim = 1.05*max(ESPor);
    ylim([ESPbelowlim ESPabovelim ]);
    yyaxis right, plot(gradient(ESP)), hold on, plot(del2(ESP));
    grid on, ylim([1.05*min(min(gradient(ESP)),min(del2(ESP))), 2.5*max(max(gradient(ESP)),max(del2(ESP)))]);
    lgnd1 = legend('New cases','5-day-av','grad','del2','location','northwest');
    title(lgnd1,'Spain');


% Italy
ITh = subplot(222); yyaxis left, plot(ITor), hold on, plot(IT);
    ylim([-0.66*max(ITor) 1.05*max(ITor)]);
    yyaxis right, plot(gradient(IT)), hold on, plot(del2(IT));
    grid on, ylim([1.05*min(min(gradient(IT)),min(del2(IT))), 2.5*max(max(gradient(IT)),max(del2(IT)))]);
    lgnd2 = legend('New cases','5-day-av.','grad','del2','location','northwest');
    title(lgnd2,'Italy');

% France
FRh = subplot(223); yyaxis left, plot(FRor), hold on, plot(FR);
    ylim([-0.66*max(FRor) 1.05*max(FRor)]);
    yyaxis right, plot(gradient(FR)), hold on, plot(del2(FR));
    grid on, ylim([1.05*min(min(gradient(FR)),min(del2(FR))), 2.5*max(max(gradient(FR)),max(del2(FR)))]);
    lgnd3 = legend('New cases','5-day-av','grad','del2','location','northwest');
    title(lgnd3,'France');

% United Kingdom
UKh = subplot(224); yyaxis left, plot(UKor), hold on, plot(UK);
    ylim([-0.66*max(UKor) 1.05*max(UKor)]);
    yyaxis right, plot(gradient(UK)), hold on, plot(del2(UK));
    grid on, ylim([1.05*min(min(gradient(UK)),min(del2(UK))), 2.5*max(max(gradient(UK)),max(del2(UK)))]);
    lgnd4 = legend('Nex cases','5-day-av','grad','del2','location','northwest');
    title(lgnd4, 'United Kingdom');

% Add offset lines
ESPidx = find(spain~=0,1,'first');
subplot(221), line([ESPidx ESPidx], [ESPh.YAxis(1).Limits],'LineStyle','-.');
ESPh.Legend.String = ESPh.Legend.String(1:4);
ESPh.Legend.NumColumns = 2;

ITidx = find(italy~=0,1,'first');
subplot(222), line([ITidx ITidx], [ITh.YAxis(1).Limits],'LineStyle','-.');
ITh.Legend.String = ITh.Legend.String(1:4);
ITh.Legend.NumColumns = 2;

FRidx = find(france~=0,1,'first');
subplot(223), line([FRidx FRidx], [FRh.YAxis(1).Limits],'LineStyle','-.');
FRh.Legend.String = FRh.Legend.String(1:4);
FRh.Legend.NumColumns = 2;

UKidx = find(uk~=0,1,'first');
subplot(224), line([UKidx UKidx], [UKh.YAxis(1).Limits],'LineStyle','-.');
UKh.Legend.String = UKh.Legend.String(1:4);
UKh.Legend.NumColumns = 2;



% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   Save plots
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~


saveas(fig1, [pwd '\images\figure1.png']);
