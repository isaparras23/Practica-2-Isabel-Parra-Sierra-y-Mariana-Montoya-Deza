% sistema_vehiculos.pl
% -----------------------
% Catálogo
% vehicle(Brand, Reference, Type, Price, Year).
vehicle(toyota, rav4, suv, 28000, 2022).
vehicle(toyota, corolla, sedan, 22000, 2021).
vehicle(toyota, camry, sedan, 26000, 2023).
vehicle(ford, mustang, sport, 45000, 2023).
vehicle(ford, explorer, suv, 32000, 2022).
vehicle(ford, ranger, pickup, 35000, 2021).
vehicle(bmw, x5, suv, 60000, 2021).
vehicle(bmw, m3, sport, 70000, 2022).
vehicle(chevrolet, silverado, pickup, 40000, 2023).
vehicle(honda, civic, sedan, 24000, 2022).
vehicle(honda, crv, suv, 27000, 2023).
% -----------------------
% Consultas y filtros
% True si el vehículo con referencia Reference tiene precio <= BudgetMax
meet_budget(Reference, BudgetMax) :-
    vehicle(_, Reference, _, Price, _),
    Price =< BudgetMax.
% vehiculos por marca usando findall/3
vehiculos_por_marca(Marca, Referencias) :-
    findall(Ref, vehicle(Marca, Ref, _, _, _), Referencias).

% vehiculos por tipo usando findall/3
vehiculos_por_tipo(Tipo, Referencias) :-
    findall(Ref, vehicle(_, Ref, Tipo, _, _), Referencias).

% -----------------------
% Generación de reportes
% generate_report(Brand, Type, Budget, reporte(VehiculosFinales, ValorTotal))
% - Brand: marca a filtrar
% - Type: tipo a filtrar
% - Budget: tope por vehículo (solo incluir vehículos cuyo precio <= Budget)
% - Resultado: reporte(ListaVehiculos, ValorTotal)

generate_report(Brand, Type, Budget, reporte(VehiculosFinales, ValorTotal)) :-
    findall(
        vehicle(Brand, Ref, Type, Price, Year),
        ( vehicle(Brand, Ref, Type, Price, Year), Price =< Budget ),
        Vehiculos
    ),
    ordenar_por_precio(Vehiculos, Ordenados),
    limitar_valor_total(Ordenados, 1000000, VehiculosFinales),
    sumar_precios(VehiculosFinales, ValorTotal).

% Variante que permite pasar MaxTotal
generate_report_max(Brand, Type, Budget, MaxTotal, reporte(VehiculosFinales, ValorTotal)) :-
    findall(
        vehicle(Brand, Ref, Type, Price, Year),
        ( vehicle(Brand, Ref, Type, Price, Year), Price =< Budget ),
        Vehiculos
    ),
    ordenar_por_precio(Vehiculos, Ordenados),
    limitar_valor_total(Ordenados, MaxTotal, VehiculosFinales),
    sumar_precios(VehiculosFinales, ValorTotal).

% -----------------------
% Ordenar por precio de forma ascendente
ordenar_por_precio(Vehiculos, Ordenados) :-
    setof(Precio-V, 
          (member(V, Vehiculos), V = vehicle(_, _, _, Precio, _)), 
          ParesOrdenados),
    findall(V, member(_-V, ParesOrdenados), Ordenados).

% -----------------------
% limitar valor total, crea una lista con los carros hasta que se alcance el Maximo
% caso en el que pasa una lista vacia
limitar_valor_total([], _, []).
% caso en el que el primer vehículo puede ser incluido
limitar_valor_total([V|Vs], Max, [V|Rest]) :-
    V = vehicle(_, _, _, Price, _),
    NuevoMax is Max - Price,
    NuevoMax >= 0,
    limitar_valor_total(Vs, NuevoMax, Rest).
% caso en el que el primer vehículo no puede ser incluido
limitar_valor_total([V|_], Max, []) :-
    V = vehicle(_, _, _, Price, _),
    NuevoMax is Max - Price,
    NuevoMax < 0.

% -----------------------
% sumar_precios(ListaVehiculos, Total)
sumar_precios([], 0).
sumar_precios([vehicle(_, _, _, Price, _)|Resto], Total) :-
    sumar_precios(Resto, SubTotal),
    Total is SubTotal + Price.

