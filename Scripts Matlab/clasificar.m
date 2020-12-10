function [xyTuercas, xyTornillos,Icolor,Itrim,centrTuercas,centrTornillos]=clasificar(Ipiezas,params,RCal,TCal,worldMax)
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
    %Identificación y etiquetado de regiones
    [L , ~]=bwlabel(Ic);
    %Propiedades de interés
    props=regionprops(L,'Centroid','Circularity','Orientation','BoundingBox');
    rgbLabel=label2rgb(L,'parula','c','shuffle');
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
    %Dimensiones del tablero
    worldCorners=[0 0 0;0 worldMax(2) 0;worldMax(1) 0 0;worldMax(1) worldMax(2) 0];
    imageCorners = worldToImage(params,RCal,TCal,worldCorners);
    %Esquinas del espacio de trabajo en coordenadas de la imagen
    Xmin=round(min(imageCorners(:,1)));
    Xmax=round(max(imageCorners(:,1)));
    Ymin=round(min(imageCorners(:,2)));
    Ymax=round(max(imageCorners(:,2)));
    %Recortar Imagenes
    Icolor=rgbLabel(Ymin:Ymax,Xmin:Xmax,:);
    Itrim=Ipiezas(Ymin:Ymax,Xmin:Xmax);  
    centrTuercas=round(centrTuercas-[Xmin Ymin]);
    centrTornillos=round(centrTornillos-[Xmin Ymin]);
end
