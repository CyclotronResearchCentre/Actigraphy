function [] = method1(option)

ASLEEP = 0;
AWAKE = 1000;

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
            
            [fileName ACTI ACTI2 resolution sleepToWake wakeToSleep t] = getData(datafile, ifile);
            
            SW = zeros(length(ACTI2), 1);
            state = AWAKE;
            threshold = [10, 2 * sleepToWake / 3];
            activity = 0;
            
            %On initialise activity et SW (on considère que le sujet est
            %éveillé au début de l'étude)
            for i = 1:wakeToSleep
                activity = activity + ACTI2(i);
                SW(i) = AWAKE;
            end;
            
            for i = wakeToSleep+1:length(ACTI2)
                %Lorsque le sujet est considéré éveillé
                if state == AWAKE
                    %On supprime la "première" entrée et on ajoute
                    %l'activité actuelle
                    if i - wakeToSleep > 1
                        activity = activity - ACTI2(i - wakeToSleep) + ACTI2(i);
                    else
                        activity = activity + ACTI2(i);
                    end;
                    
                    %Si on a trop peu d'activité sur la fenêtre -> le sujet
                    %dort
                    if activity < threshold(1)
                        for j = i - wakeToSleep:i
                            SW(j) = ASLEEP;
                        end;
                        state = ASLEEP;
                    end;
                
                %Lorsque le sujet est considéré endormi
                elseif state == ASLEEP
                    if i - sleepToWake > 1
                        activity = activity - ACTI2(i - sleepToWake) + ACTI2(i);
                    else
                        activity = activity + ACTI2(i);
                    end;
                    
                    %Si on a trop d'activité sur la fenêtre -> le sujet est
                    %éveillé
                    if activity > threshold(2)
                        for j = i - sleepToWake:i
                            SW(j) = AWAKE;
                        end;
                        state = AWAKE;
                    end;
                end;
            end;
            
            i = 1:length(ACTI2);
            figure;
            set(gcf,'Position', [30 50 1200 650]);
            clf;
            hold on;
            plot(i, ACTI, 'm');
            plot(i, ACTI2, 'g');
            plot(i, SW, 'b');
            title(fileName, 'interpreter', 'none');
            
            
        end;
    
end;


end