planta('Grama').

usado_para_tratar('Grama','curar_golpes_internos').
usado_para_tratar('Grama','infeccion_en_los_riñones').
usado_para_tratar('Grama','mal_de_orin').
usado_para_tratar('Grama','inflamaciones_en_general').
usado_para_tratar('Granado','lombrices').

regla(Planta,Enfermedades):-
    findall(Enfermedad,usado_para_tratar(Planta,Enfermedad),Enfermedades).
