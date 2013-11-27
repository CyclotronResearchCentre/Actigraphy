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
            threshold = [mean(ACTI) / 3, 2 * mean(ACTI) / 3];
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
                    if meanActivity < threshold(1)
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
                    if meanActivity > threshold(2)
                        for j = i - sleepToWake:i
                            SW(j) = AWAKE;
                        end;
                        state = AWAKE;
                    else
                        SW(i) = state;
                    end;
                end;
            end;
            
            %On supprime les périodes de sommeil / d'éveil trop courtes
            
            
            OK = 0;
            while OK == 0
                OK = 1;
                transitions = abs(diff(SW));
                state = SW(1);
                transitions = find(transitions == 1);
                
                for i = 1:length(transitions)-1
                    state ~= state;
                    if transitions(i + 1) - transitions(i) < 200 && OK == 1
                        SW(transitions(i):transitions(i+1)) = state;
                        OK = 0;
                    end;
                end;
            end;
            
            [sleepTime wakeTime] = getNights(SW, startTime, nbDataPerDays); %s
            bedTime = getBedTime(ACTI, sleepTime, startTime, nbDataPerDays); %s
            upTime = getUpTime(ACTI, wakeTime, startTime, nbDataPerDays); %s
            assumedSleepTime = upTime - bedTime;
            actualSleepTime = wakeTime - sleepTime;
            actualSleep = actualSleepTime ./ assumedSleepTime;
            actualWakeTime = assumedSleepTime - actualSleepTime;
            actualWake = actualWakeTime ./ assumedSleepTime;
            [sleepDuration meanDuration stdDev] = getDuration(sleepTime, wakeTime, resolution, nbDataPerDays);
            
            saveData(fileName, sleepTime, wakeTime, bedTime, upTime, assumedSleepTime, actualSleepTime, actualSleep, actualWakeTime, actualWake, sleepDuration, meanDuration, stdDev);
            
%             figure;
%             hold on;
%             x = meanDuration-5*stdDev:1:meanDuration+5*stdDev;
%             y = gaussmf(x, [stdDev, meanDuration]);
%             plot(x / 3600, y);

            
            % ! AFFICHAGE GRAPHIQUE DONNEES BRUTES ET SW ET BED/UP TIMES !
            i = 1:length(ACTI);
            figure;
            set(gcf,'Position', [30 50 1200 650]);
            clf;
            hold on;
            plot(i, ACTI, 'm');
            for j = 1:length(bedTime)
                plot(linspace(double((bedTime(j) - startTime) * nbDataPerDays), double((bedTime(j) - startTime) * nbDataPerDays), length(ACTI)), linspace(0, 10000, length(ACTI)), 'k');
            end;
            for j = 1:length(upTime)
                plot(linspace(double((upTime(j) - startTime) * nbDataPerDays), double((upTime(j) - startTime) * nbDataPerDays), length(ACTI)), linspace(0, 10000, length(ACTI)), 'k');
            end;
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
            plot(linspace(0, 0, 20001), -100:0.01:100, 'k');
            plot(-100:0.01:100, linspace(0, 0, 20001), 'k');
            for i = 1:length(SW)
                if ang <= - 3 * pi / 2
                    %radius = radius + 0.5;
                    ang = pi / 2;
                end;
                
                circle(origin(1), origin(2), radius, ang, colors(SW(i) + 1));
                ang = ang - angStep;
                radius = radius + 0.01;
            end;
            
            %saveas(gcf, '~/sleep', 'png');
            
        end;
    
end;


end