Path="G:\Mi unidad\Sincronizado2020\Sincronizado 2020\Unal\2020-2\Robotica\Proyectos\Intermedio";
[params,estimationErrors,R,t] = calibrar (Path);
Ipiezas=imread('Ipiezas.jpg');
%%
[xyTuercas, xyTornillos,Ic,centrTuercas,centrTornillos]=clasificar(Ipiezas,params,R,t);