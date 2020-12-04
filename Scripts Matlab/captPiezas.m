function [piezas] = captPiezas(Path) 
  %Conexión cámara
    url = 'http://192.168.0.5:8080/shot.jpg'; 
    while(1)
      piezas  = imread(url);
      Ipiezas=image(piezas);
      set(Ipiezas,'CData',piezas);
      drawnow; 
      pause(2)
      return;
    end
end

