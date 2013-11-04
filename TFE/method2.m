function [] = method1(option)

ASLEEP = 0;
AWAKE = 1;

if ~nargin
    option = spm_input('Action : ',1,'m','Individual|Group',[1,2],0); %Individual : option = 1, Group : option = 2
end;

close all;

origdir = '/home/miguel/Cours/TFE/';
%datadir = fullfile(origdir, 'data');
datadir = fullfile(origdir, 'Actigraphy_TMS');
strline = '--------------------------';
nbSecPerDays = 86400;

switch(option)
    case 1
        datafile = spm_select(Inf, '.+\.AWD$', 'Select files ...', [], datadir, '.AWD'); %Show all .AWD files in the directory datadir
        if(isempty(datafile))
            nbFiles = 0;
        else
            nbFiles = size(datafile, 1);
        end;
        
        
        for ifile = 1:nbFiles
            
            [fileName ACTI ACTI2 nbDays resolution startTime sleepToWake wakeToSleep t] = getData(datafile, ifile);
            
            nbDataPerDays = nbSecPerDays / resolution;
            SW = zeros(length(ACTI), 1);
            state = AWAKE;
            threshold = mean(ACTI) / 3
            activity = 0;
            nbNights = 0;
            
            %On initialise activity et SW (on considère que le sujet est
            %éveillé au début de l'étude)
            for i = 1:wakeToSleep
                activity = activity + ACTI(i);
                SW(i) = AWAKE;
            end;
                                    
            for i = wakeToSleep+1:length(ACTI)
                %Lorsque le sujet est considéré éveillé
                if state == AWAKE
                    %On supprime la "première" entrée et on ajoute
                    %l'activité actuelle
                    if i - wakeToSleep > 1
                        activity = activity - ACTI(i - wakeToSleep) + ACTI(i);
                    else
                        activity = activity + ACTI(i);
                    end;
                    
                    meanActivity = activity / wakeToSleep;
                    
                    %Si on a trop peu d'activité sur la fenêtre -> le sujet
                    %dort
                    if meanActivity < threshold
                        for j = i - wakeToSleep:i
                            SW(j) = ASLEEP;
                        end;
                        state = ASLEEP;
                        nbNights = nbNights + 1;
                    else
                        SW(i) = state;
                    end;
                    
                
                %Lorsque le sujet est considéré endormi
                elseif state == ASLEEP
                    if i - sleepToWake > 1
                        activity = activity - ACTI(i - sleepToWake) + ACTI(i);
                    else
                        activity = activity + ACTI(i);
                    end;
                    
                    meanActivity = activity / wakeToSleep;
                    
                    %Si on a trop d'activité sur la fenêtre -> le sujet est
                    %éveillé
                    if meanActivity > threshold
                        for j = i - sleepToWake:i
                            SW(j) = AWAKE;
                        end;
                        state = AWAKE;
                    else
                        SW(i) = state;
                    end;
                end;
            end;
            
            % ! AFFICHAGE GRAPHIQUE DONNEES BRUTES ET SW !
            i = 1:length(ACTI);
            figure;
            set(gcf,'Position', [30 50 1200 650]);
            clf;
            hold on;
            plot(i, ACTI, 'm');
            plot(i, linspace(threshold, threshold, length(ACTI)), 'g');
            plot(i, 1000 * SW, 'b');
            title(fileName, 'interpreter', 'none');
            
            
            % ! AFFICHAGE SUR CERCLE !
            
            radius = 1;
            colors = ['b', 'r']; %Bleu = sommeil, Rouge = éveil
            ang = getStartAngle(startTime);
            angStep = 2 * pi / nbDataPerDays; %delta theta entre deux points consécutifs sur le cercle
            origin = [0, 0]; %Centre du cercle
            
            figure;
            hold on;
            plot(linspace(0, 0, 2001), -10:0.01:10, 'k');
            plot(-10:0.01:10, linspace(0, 0, 2001), 'k');
            for i = 1:length(SW)
                if ang <= - 3 * pi / 2
                    radius = radius + 0.5;
                    ang = pi / 2;
                end;
                
                circle(origin(1), origin(2), radius, ang, colors(SW(i) + 1));
                ang = ang - angStep;
            end;
            
            %saveas(gcf, '~/sleep', 'png');
            
        end;
    
end;


end