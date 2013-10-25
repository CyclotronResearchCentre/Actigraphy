function [] = method1(option)

AWAKE = 1;
ASLEEP = 0;

if ~nargin
    option = spm_input('Action : ',1,'m','Individual|Group',[1,2],0); %Individual : option = 1, Group : option = 2
end;

close all;

origdir = '/home/miguel/Cours/TFE/';
datadir = fullfile(origdir, 'data');
strline = '--------------------------';

switch(option)
    case 1
        datafile = spm_select(Inf, '.+\.AWD$', 'Select files ...', [], datadir, '.AWD'); %Show all .AWD files in the directory datadir
        if(isempty(datafile))
            nbFiles = 0;
        else
            nbFiles = size(datafile, 1);
        end;
        
        
        for ifile = 1:nbFiles
            
            [fileName ACTI ACTI2 resolution minStateWake minStateSleep t] = getData(datafile, ifile);
            
            state = AWAKE;
            SW(1:4) = 0;
            threshold = 3;
            activity = 0;
            
            for i = 5:length(ACTI2)-4
                activity = activity + ACTI(i) - ACTI(i - 4);
                if activity > threshold
                    SW(i) = AWAKE;
                else
                    SW(i) = ASLEEP;
                end;
            end;
            
            
            figure;
            set(gcf,'Position', [30 50 1200 650]);
            clf;
            %subplot(3,2,1:2);
            hold on;
            plot(ACTI,'m');
            plot(ACTI2, 'b');
            a=(0:6*3600/resolution:length(t));
            a(1) = 1;
            set(gca,'XTick',a);
            set(gca,'XTickLabel', datestr(t(a),15), 'FontSize', 6);
            title(fileName, 'interpreter', 'none');
            
            
        end;
    
end;


end