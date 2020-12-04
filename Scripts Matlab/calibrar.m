function [params,estimationErrors,R,t,Im1] = calibrar (Path)
    images=imageDatastore(strcat(Path,"/Calibracion"));
    imageFileNames=images.Files;
    % Detectar patrón de calibración
    [imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);
    %Generar coordenadas de las esquinas de los cuadrados en el sistema de
    %referencia real
    squareSize = 27;
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);    
    %Calibrar la cámara
    Ical=readimage(images,1);
    imageSize=[size(Ical,1),size(Ical,2)];
    [params, ~, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, 'ImageSize', imageSize);    
    im=imread(strcat(Path,'/Calibracion/1.jpg'));    
    [Im1, newOrigin] = undistortImage(im, params, 'OutputView', 'full');
    [imagePoints, boardSize] = detectCheckerboardPoints(im);
    imagePoints = imagePoints + newOrigin;
    [R, t] = extrinsics(imagePoints, worldPoints, params);
end
