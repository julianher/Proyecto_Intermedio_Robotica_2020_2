Path="C:\Users\Alejandra\Documents\GitHub\Proyecto_Intermedio_Robotica_2020_2\Scripts Matlab";
[params,estimationErrors,R,t] = calibrar (Path);
Ipiezas=imread('Ipiezas.jpg');
%%
[xyTuercas, xyTornillos,Ic,centrTuercas,centrTornillos]=clasificar(Ipiezas,params,R,t);