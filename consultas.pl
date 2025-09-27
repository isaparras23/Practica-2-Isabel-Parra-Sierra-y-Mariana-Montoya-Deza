% consultas.pl
% Caso 1:
generate_report(toyota, suv, 30000, R).

% Caso 2:
bagof(vehicle(ford, Ref, Tipo, Price, Year), vehicle(ford, Ref, Tipo, Price, Year), Lista).

% Caso 3:
generate_report_max(_, sedan, 1000000, 500000, R).