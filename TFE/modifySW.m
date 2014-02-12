function [SW] = modifySW(SW)

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

end