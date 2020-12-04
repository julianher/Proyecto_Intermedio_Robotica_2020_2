function [xyTuercas, xyTornillos,Ic,centrTuercas,centrTornillos]=clasificar(Ipiezas,params,RCal,TCal)
    %Escala de grises
    rgb = Ipiezas;
    Ibw = rgb2gray(rgb); 
    % Ajuste contraste
    Ibw =imadjust(Ibw,[0.2 0.9],[]);
    [Ipiezas1, newOrigin] = undistortImage(Ipiezas, params, 'OutputView', 'full');
    %Contornos
    neighborhood = ones(15);
    If = stdfilt(Ibw, neighborhood);
    %Filtro de contornos
    Imask = If>20;
    %Llenado de contornos
    Imask = imfill(Imask,'holes');
    %Filtro de mediana
    Ic = medfilt2(Imask,[40 40]);
    imshow(Ic);
    %Identificación y etiquetado de regiones
    [L Ne]=bwlabel(Ic);
    %Propiedades de interés
    props=regionprops(L,'Centroid','Circularity','Orientation','BoundingBox');
    rgbLabel=label2rgb(L,'spring','c','shuffle');
    %Clasificación
    circul=vertcat(props.Circularity);
    piezas=circul>0.95;
    %Centroides
    centr=vertcat(props.Centroid);
    centrTuercas=centr(piezas==1,:);
    centrTornillos=centr(piezas==0,:);
    esc=150/220;
    xyTuercas=pointsToWorld(params, RCal, TCal, centrTuercas)*esc;
    xyTornillos=pointsToWorld(params, RCal, TCal, centrTornillos)*esc;
    xyTornillos =  xyTornillos/1000;
    xyTuercas = xyTuercas/1000;
end
