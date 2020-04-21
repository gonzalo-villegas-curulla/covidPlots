% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% 0. Introduction
%
% covidplotupdate.m
% Script plotting evolution diagrams of covid-19 epidemiology
%
% Gonzalo Villegas Curulla
%
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


clear all
close all

delete time_series_covid19_confirmed_global.csv

if (exist([pwd '\images\figure_confirmed.png'])) ~= 0
    delete([pwd '\images\figure_confirmed.png']);
end

if (exist([pwd '\images\figure_deaths.png'])) ~= 0
    delete([pwd '\images\figure_deaths.png']);
end


url = {'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv',...
       'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv'};

filename = {'time_series_covid19_confirmed_global.csv',...
            'time_series_covid19_deaths_global.csv'};

legend_tag = {'New cases','Deaths'};
% figure_name = {'Confirmed new cases',...
%                'Deaths'};
options = weboptions('TimeOut',Inf);

% Chart for graphs
grid_plots = [0,   0.5,  0.5, 0.4;
              0.5, 0.5,  0.5, 0.4;
              0,   0,    0.5, 0.4;
              0.5, 0,    0.5, 0.4];

grid_rul = [0, (grid_plots(1,2)+grid_plots(1,4)), 0.5, (1-grid_plots(1,2)+grid_plots(1,4));
            ;
            ;
            ];

for idx = 1:2 % Run once for New cases, and twice for Deaths plots



    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %   1. Acquire data
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~



    websave(char(filename(idx)), char(url(idx)), options);

    data = readtable(char(filename(idx)));

    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %   2. Prepare series
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Convert data
    LL = size(data); LL = LL(2);  % Shorthand for vector length


    temp = data(139,5:LL);
    for n = 1:LL-4, italy(n) = temp.(n); end

    temp = data(203,5:LL);
    for n = 1:LL-4, spain(n) = temp.(n); end

    temp = data(118,5:LL);
    for n = 1:LL-4, france (n) = temp.(n); end

    temp = data(225,5:LL);
    for n = 1:LL-4, uk(n) = temp.(n); end


    spain = cellfun(@str2num,spain); spain = spain'; % {Otherwise spain(n) = str2num(char(temp.(n))) above}
    france  = cellfun(@str2num,france); france = france';
    italy = cellfun(@str2num,italy); italy = italy';
    uk = cellfun(@str2num,uk); uk = uk';


    % Create time series
    range  = [2:LL-5];
    range2 = [5:LL-5];

    ESP = [spain(2:end)-spain(1:end-1)]; % Daily new occurrences
    ESPor = ESP;
    ESP(range2) = 0.2*ESP(range2) +0.2*ESP(range2-1) +0.2*ESP(range2-2) +0.2*ESP(range2-3) +0.2*ESP(range2-4);

    IT  = [italy(2:end)-italy(1:end-1)];
    ITor = IT;
    IT(range2) = 0.2*IT(range2) +0.2*IT(range2-1) +0.2*IT(range2-2) +0.2*IT(range2-3) +0.2*IT(range2-4);

    FR  = [france(2:end)-france(1:end-1)];
    FRor = FR;
    FR(range2) = 0.2*FR(range2) +0.2*FR(range2-1) +0.2*FR(range2-2) +0.2*FR(range2-3) +0.2*FR(range2-4);

    UK  = [uk(2:end)-uk(1:end-1)];
    UKor = UK;
    UK(range2) = 0.2*UK(range2) +0.2*UK(range2-1) +0.2*UK(range2-2) +0.2*UK(range2-3) +0.2*UK(range2-4);


    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %   3. Plot (i) new cases, (ii) deaths
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





    if idx == 1
        fig1 = figure('Name','Confirmed new cases','Units','Normalized', 'OuterPosition',[0 0 1 1]);
    elseif idx == 2
        fig3 = figure('Name','Deaths','Units','Normalized', 'OuterPosition',[0 0 1 1]);
    end

    % Spain
    ESPh = subplot(221);
        yyaxis left, plot(ESPor), hold on, plot(ESP); xlabel('Days');
        ESPbelowlim = -0.66*max(ESPor);
        ESPabovelim = 1.05*max(ESPor);
        ylim([ESPbelowlim ESPabovelim ]);
        yyaxis right, plot(gradient(ESP)), hold on, plot(del2(ESP));
        grid on, ylim([1.05*min(min(gradient(ESP)),min(del2(ESP))), 2.5*max(max(gradient(ESP)),max(del2(ESP)))]);
        lgnd1 = legend(char(legend_tag(idx)),'5-day-av','grad','del2','location','northwest');
        title(lgnd1,'Spain');


    % Italy
    ITh = subplot(222); yyaxis left, plot(ITor), hold on, plot(IT); xlabel('Days');
        ylim([-0.66*max(ITor) 1.05*max(ITor)]);
        yyaxis right, plot(gradient(IT)), hold on, plot(del2(IT));
        grid on, ylim([1.05*min(min(gradient(IT)),min(del2(IT))), 2.5*max(max(gradient(IT)),max(del2(IT)))]);
        lgnd2 = legend(char(legend_tag(idx)),'5-day-av.','grad','del2','location','northwest');
        title(lgnd2,'Italy');

    % France
    FRh = subplot(223); yyaxis left, plot(FRor), hold on, plot(FR); xlabel('Days');
        ylim([-0.66*max(FRor) 1.05*max(FRor)]);
        yyaxis right, plot(gradient(FR)), hold on, plot(del2(FR));
        grid on, ylim([1.05*min(min(gradient(FR)),min(del2(FR))), 2.5*max(max(gradient(FR)),max(del2(FR)))]);
        lgnd3 = legend(char(legend_tag(idx)),'5-day-av','grad','del2','location','northwest');
        title(lgnd3,'France');

    % United Kingdom
    UKh = subplot(224); yyaxis left, plot(UKor), hold on, plot(UK); xlabel('Days');
        ylim([-0.66*max(UKor) 1.05*max(UKor)]);
        yyaxis right, plot(gradient(UK)), hold on, plot(del2(UK));
        grid on, ylim([1.05*min(min(gradient(UK)),min(del2(UK))), 2.5*max(max(gradient(UK)),max(del2(UK)))]);
        lgnd4 = legend(char(legend_tag(idx)),'5-day-av','grad','del2','location','northwest');
        title(lgnd4, 'United Kingdom');

    % Add offset lines
    ESPidx = find(spain~=0,1,'first');
    subplot(221), line([ESPidx ESPidx], [ESPh.YAxis(1).Limits],'LineStyle','-.');
    ESPh.Legend.String = ESPh.Legend.String([1 2 3 4]);
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

    if idx == 1

        % Allow space for growth rate above each subplot
        % ESPh.Position = grid_plots(1,:);
        % ITh.OuterPosition  = grid_plots(2,:);
        % FRh.OuterPosition  = grid_plots(3,:);
        % UKh.Position  = grid_plots(4,:);

        % ESPh2 = axes('Parent',fig1, 'Units', 'Normalized', 'OuterPosition', grid_rul(1,:));

        fig2 = figure;
        h1 = subplot(411);
              plot(ESPor(range)./ESPor(range-1)); hold on; plot(ESP(range)./ESP(range-1));
              ylim([0 2.1]); legend('RAW','5dAverage','Location','NorthWest'); grid on;
              ylabel('ESP'); title('Growth rate of confirmed cases');
              h1.YAxisLocation = 'right';
        h2 = subplot(412);
              plot(ITor(range)./ITor(range-1)); hold on; plot(IT(range)./IT(range-1));
              ylim([0 2.1]); grid on;
              ylabel('IT');
              h2.YAxisLocation = 'right';
        h3 = subplot(413);
              plot(FRor(range)./FRor(range-1)); hold on; plot(FR(range)./FR(range-1));
              ylim([0 2.1]); grid on;
              ylabel('FR');
              h3.YAxisLocation = 'right';
        h4 = subplot(414);
              plot(UKor(range)./UKor(range-1)); hold on; plot(UK(range)./UK(range-1));
              ylim([0 2.1]); grid on;
              ylabel('UK');
              h4.YAxisLocation = 'right';

    end

    clear spain ESP ESPh %ESPor
    clear italy IT ITh %ITor
    clear france FR FRh %FRor
    clear uk UK UKh %UKor
    clear data



end


% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%   4. Save plots
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

saveas(fig1, [pwd '\images\figure_confirmed.png']);
saveas(fig3, [pwd '\images\figure_deaths.png']);
