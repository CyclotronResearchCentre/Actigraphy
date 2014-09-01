function displayResults(errorRates, sensitivities, specificities)

constantes;

fprintf('%s \n', strline);
fprintf('Erreur moyenne : %f \n', 1 - mean(errorRates));
fprintf('Erreur max : %f \n', 1 - max(errorRates));
fprintf('Erreur min : %f \n', 1 - min(errorRates));
fprintf('%s \n \n', strline);

fprintf('%s \n', strline);
fprintf('Sensitivité moyenne : %f \n', mean(sensitivities));
fprintf('Sensitivité max : %f \n', max(sensitivities));
fprintf('Sensitivité min : %f \n', min(sensitivities));
fprintf('%s \n \n', strline);

fprintf('%s \n', strline);
fprintf('Spécificité moyenne : %f \n', mean(specificities));
fprintf('Spécificité max : %f \n', max(specificities));
fprintf('Spécificité min : %f \n', min(specificities));
fprintf('%s \n \n', strline);

end