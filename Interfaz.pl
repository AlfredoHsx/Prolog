:- use_module(library(pce)).

%MetodoParaMostrarImagen
mostrarImagen(V,D,M):- new(I, image(V)),
        new(B, bitmap(I)),
        new(F2, figure),
        send(F2, display, B),
        %DondeSeVeraLaImagen
        new(D1, device),
        send(D1, display, F2),
        send(D, display, D1,point(20,20)),
        send(D1,below(M)).

:- pce_global(@name_prompter, make_name_prompter).

        %CreaElDilogoParaIngresarElNombreYBuscarLaInformacion
        make_name_prompter(P) :-
                new(P, dialog),
                send(P, kind, transient),
                send(P, append, label(prompt)),
                send(P, append,
                        new(TI, text_item(name, '',
                                 message(P?ok_member, execute)))),
                send(P, append, button(ok, message(P, return, TI?selection))),
                %%send(P, append, button(ok, message(@prolog,pp))),
                send(P, append, button(cancel, message(P, return, @nil))).

        %MuestraElDialogoIngresarElNombreYBuscarLaInformacion__EnNameEstaElNombre
        ask_name(Prompt, Label, Name) :-
                send(@name_prompter?prompt_member, selection, Prompt),
                send(@name_prompter?name_member, label, Label),
                send(@name_prompter?name_member, clear),
                get(@name_prompter, confirm_centered, RawName),
                send(@name_prompter, show, @off),
                RawName \== @nil,
                Name = RawName.
        %MostrarInfromacionDeLosPlantas
        ask_name_obtiene:-
                  ask_name('Ingresa el nombre de la planta','Nombre de la planta:', Planta),
                  pp_produce_medicamento(Planta).

        ask_name_enfermedades_curadas_por:-
                  ask_name('Enfermedades cuaradas por (Planta)','Planta:', Planta),
                  pp_enfermedades_curadas_por(Planta).
        
        ask_name_Termino_a_buscar:-
                  ask_name('Buscador de terminos: ','Termino a buscar:', Termino),
                  pp_significado_De_Terminos(Termino).
        ask_name_Buscar_Planta:-
                  ask_name('Buscador de plantas: ','Nombre de la planta a buscar:', Nombre),
                  pp_Buscador_plantas(Nombre).

        
start :-
        %IniciaElProgramaComoTal
        new(D,dialog('El yerberito ilustrado -Alfredo')),
        send(D,size,size(400,800)),
        send(D,colour,colour(red)),
        send(D, append, new(Menu, menu_bar)),        
        send(Menu,append,new(Iniciar1,popup('Menu: '))),
                %Mostrar_medicamento_que_produce_la_planta
                send_list(Iniciar1,append,
                      [menu_item('Medicamento producido por planta',message(@prolog,ask_name_obtiene))
                      ]),
                %Mostar_enfermedades_que_cura_x_plnata
                send_list(Iniciar1,append,
                      [menu_item('Enfermedades cuaradas por (Planta)',message(@prolog,ask_name_enfermedades_curadas_por))
                      ]),
                %Buscar_significado_de_los_terminos
                send_list(Iniciar1,append,
                      [menu_item('Significado de terminos',message(@prolog,ask_name_Termino_a_buscar))
                      ]),
                %Buscar_planta_por_su_nombre_y_obtener_imagen
                send_list(Iniciar1,append,
                      [menu_item('Buscar planta',message(@prolog,ask_name_Buscar_Planta))
                      ]),
                %mostrar_lista_de_plantas_medicinales               
                send_list(Iniciar1, append,
                      [menu_item('Listar plantas medicinales', message(@prolog, pp_listar_plantas))
                      ]),
        mostrarImagen('C:/Proyecto/yerberito/Yerberito.jpg',D,Menu),
        send(D,open,point(0,0)),
         consult('C:/Proyecto/Data.pl'),
           nl.


%MedicamentoObtenidoDeLaPlanta       
pp_produce_medicamento(Planta):-
    new(D, dialog(Planta)),
    %PrimeroEsLoAnchoDespuesElLargo
    send(D, size, size(500,200)),
    send(D, colour, colour(black)),
    send(D, append, new(Menu, menu_bar)),
    send(D, display, text('Plantas que producen medicamentos', center, normal), point(200, 5)),
    planta_obtiene(Planta, Obtiene),
    send(D, open, point(300, 200)),
    %EtiquetasDePlantaYNombre
    send(D, display, text('Planta: ', center, normal), point(200,35)),
        send(D, display, text(Planta, center, normal), point(270,35)),
    %EtiquetaDePlantaYLoQueSeObtiene
     send(D, display, text('*Se obtiene este medicamento*', center, normal), point(200,55)),
     nl,
     send(D, display, text(Obtiene, center, normal), point(250,70)),
    %MostrarLaImagenDeLaPlanta
    unirPlantaImagen(Planta, Foto),
    mostrarImagen(Foto, D, Menu),
    nl.

%EnfermedadesCuradasPorLasPlantasBeneficios
pp_enfermedades_curadas_por(Planta):-
    %AsignacionDelNombreParaVentanaEmergente
     atom_concat('Enfermedades curadas por ', Planta, Titulo),
    new(D, dialog(Titulo)),
    send(D, size, size(400,500)),
    send(D, colour, colour(black)),
    %EstoSeUsaParaMostrarLaImagenDespues
    send(D, append, new(Menu, menu_bar)),
    %BuscarTodasLasVecesQueLaPlantaEstaLigadaConUnMalestar
    findall(Malestar, usado_para_tratar(Planta, Malestar), Enfermedades),
    send(D, open, point(300, 200)),
    %MostrarPlantaSeguidoDelNombre
    send(D, display, text('Planta: ', center, normal), point(200,35)),
    send(D, display, text(Planta, center, normal), point(270,35)),
    %MostrarEtiquetaDeMalestaresParaTratar
    send(D, display, text('---Ayuda a tratar/beneficiar---', center, normal), point(200,60)),
    nl,
    %ConvertirListaDeEnfermedadesAStringConInterlineado
    atomic_list_concat(Enfermedades, '\n', EnfermedadesStr),
    %MostrarLosResultadosDeLaListaEnLaVentana
    send(D, display, text(EnfermedadesStr, center, normal), point(200,80)),
    %MostrarLaImagenDeLaPlanta
    unirPlantaImagen(Planta, Foto),
    mostrarImagen(Foto, D, Menu),
    nl.

%SignificadosDeLosTerminos
pp_significado_De_Terminos(Termino):-
    %DefineLaInstanciaDelNuevoFormulario
    new(D, dialog(Termino)),
    send(D, size, size(200,200)),
    send(D, colour, colour(black)),
    send(D, display, text('Significado del termino', center, normal), point(20, 5)),
    %ObtenerElSignificadoDeLaPalabra
    significa(Termino, Significado),
    send(D, open, point(300, 200)),
    %EtiquetasParaPresentacionDeDatos
    send(D, display, text('Termino: ', center, normal), point(20,35)),
    send(D, display, text(Termino, center, normal), point(70,35)),
    send(D, display, text('Significado: ', center, normal), point(20,55)),
    nl,
    send(D, display, text(Significado, center, normal), point(20,70)),
    nl.

%ListarPlantasMedicinales
pp_listar_plantas :-
    % AsignacionDelNombreParaVentanaEmergente
    new(D, dialog('Lista de plantas medicinales')),
    send(D, size, size(400, 500)),
    send(D, colour, colour(black)),
    %Buscar todas las veces que la planta está ligada con un malestar
    findall(Planta, planta(Planta), Plantas),
    %Crear una ventana con scroll
    new(W, window('Plantas', size(380, 400))),
    send(W, scrollbars, vertical),  % Agregar barra de scroll vertical
    %Convertir la lista de plantas a string con interlineado
    atomic_list_concat(Plantas, '\n', PlantasStr),
    %Mostrar los resultados de la lista en la ventana con scroll
    send(W, display, text(PlantasStr, left, normal), point(10, 10)),
    %Agregar la ventana con scroll al diálogo
    send(D, append, W),
    %Abrir el diálogo
    send(D, open, point(300, 200)),
    %Mostrar etiqueta de malestares para tratar
    send(D, display, text('---Lista de plantas medicinales---', center, normal), point(200, 20)).


