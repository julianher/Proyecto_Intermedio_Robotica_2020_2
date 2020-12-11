function [piezas] = captPiezas(Path) 
  %Conexión cámara
    url = 'http://192.168.0.4:8080/shot.jpg'; 
    while(1)
      piezas  = imread(url);
      Ipiezas=image(piezas);
      set(Ipiezas,'CData',piezas);
      pause(2)
      imwrite(piezas,strcat(Path,'/Ipiezas.jpg'));
      return;
    end
    
end


