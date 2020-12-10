Path="/home/julian/Documents/GitHub/Proyecto_Intermedio_Robotica_2020_2/Scripts Matlab";
%% Capturar Imágenes Para Calibración
captICal(Path);
%% Calibrar cámara
[params,estimationErrors,R,t,im,w] = calibrar (Path);
%% Capturar Imagen de Piezas Para Clasificación
Ipiezas=captPiezas(Path);
%% Cargar Imagen
a=cargarImagen(Path);
imshow(a);
%% Clasificar  piezas
[xyTuercas, xyTornillos,Ic,Itrim,centrTuercas,centrTornillos]=clasificar(Ipiezas,params,R,t,w);
%%

if length(xyTornillos) >= length(xyTuercas)
 numax = length(xyTornillos);
else
    numax = length(xyTuercas);
end


for i = 1:numax
    
   if i<=length(xyTornillos)
     rutina(xyTornillos(i,1),xyTornillos(i,2),1)
   end
   
   if i<=length(xyTuercas)
     rutina(xyTuercas(i,1),xyTuercas(i,2),2)
   end
end


