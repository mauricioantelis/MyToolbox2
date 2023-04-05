%% CONSTRUIR LAYOUT PARA LOS 3 ELECTRODOS

%% 1) Cear el archivo MyLayout.lay
% Usar alguno de los archivos *.lay dentro de la carpeta template de
% fieldtrip

%% 2) Construir la estructura de Matlab con el layout
cfg                 = [];
cfg.layout          = 'MyLayout.lay';
MyLayout            = ft_prepare_layout(cfg);

%% 3) ELiminar electrodos no necearios
Ind2Eli = [1:9 13:21];
MyLayout.pos(Ind2Eli    ,:)  = [];
MyLayout.width(Ind2Eli  ,:)  = [];
MyLayout.height(Ind2Eli ,:)  = [];
MyLayout.label(Ind2Eli  ,:)  = [];

%% 4) Cambiar las dimenciones si lo cree necesario
% MyLayout.width        = MyLayout.width*1.3;
% MyLayout.height       = MyLayout.height*1.3;

%% 5) Plot layout
cfg                 = [];
cfg.layout          = MyLayout;
ft_layoutplot(cfg)

% IMPORTANTE: 
% En principio, su layout debe contener unicamente los electrodos usandos
% en su experimento. 

%% 6) Gaurdar la estructura de Matlab con el layout en un archivo .mat
save('MyLayout','MyLayout')