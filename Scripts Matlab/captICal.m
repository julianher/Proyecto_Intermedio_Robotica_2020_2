function [] = captICal(Path) 
  %Conexión cámara
    url = 'http://192.168.0.5:8080/shot.jpg'; 
    while(1)
      Cal  = imread(url);
      Ical=image(Cal);
      set(Ical,'CData',Cal);
      drawnow;  
      for i=1:16              
         imwrite(Cal, strcat(Path,'/Calibracion/',int2str(i),'.jpg'));
         pause(1)
      end
      return;
    end    
end