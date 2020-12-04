Path="/home/julian/Documents/GitHub/Proyecto_Intermedio_Robotica_2020_2/Scripts Matlab";
%% Capturar Imágenes Para Calibración
captICal(Path);
%% Calibrar cámara
[params,estimationErrors,R,t] = calibrar (Path);
%% Capturar Imagen de Piezas Para Clasificación
Ipiezas=captPiezas();
imwrite(Ipiezas,'Ipiezas.jpg')
%% Cargar Imagen
Ipiezas=imread('Ipiezas.jpg');
%% Clasifucar  piezas
[xyTuercas, xyTornillos,Ic,centrTuercas,centrTornillos]=clasificar(Ipiezas,params,R,t);
xyTornillos =  xyTornillos/1000;
xyTuercas = xyTuercas/1000;
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


