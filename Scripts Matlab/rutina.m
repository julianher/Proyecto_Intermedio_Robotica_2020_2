
function rutina(xyTornillos,xyTuercas)
if length(xyTornillos) >= length(xyTuercas)
 numax = length(xyTornillos);
else
    numax = length(xyTuercas);
end


for i = 1:numax
    
   if i<=length(xyTornillos)
     rutina_robot1(xyTornillos(i,1),xyTornillos(i,2))
   end
   
   if i<=length(xyTuercas)
     rutina_robot2(xyTuercas(i,1),xyTuercas(i,2))
   end
end
end

function rutina_robot1(entrada_x,entrada_y)

% Definición del robot
L1(1) = Link('revolute','alpha',0,'a',0,'d',0.137,'offset',0,'modified');
L1(2) = Link('revolute','alpha',-pi/2,'a',0,'d',0,'offset',-pi/2,'modified');
L1(3) = Link('revolute','alpha',0,'a',0.105,'d',0,'offset',0,'modified');
L1(4) = Link('revolute','alpha',0,'a',0.105,'d',0,'offset',0,'modified');

R_tool = [0  0  1;
         -1  0  0;
          0 -1  0];
P_tool = [0.11 0 0]';
T_4_tool = rt2tr(R_tool,P_tool);
R1 = SerialLink(L1,'name','phantom1');
R1.tool = T_4_tool;


% Posiciones fijas
qi(1,:) = [0   -1.0000    2.4000    0.5000         0         0];
qi(6,:) = [-0.6476    1.1058    0.2157    1.8202    0.0160    0.0160];
qi(7,:) = [-0.6476    1.1833    0.7443    1.2140    0.0160    0.0160];
qi(8,:) = [-0.6476    1.1833    0.7443    1.2140         0         0];
qi(9,:) = [-0.6476    1.1057    0.2157    1.8201         0         0];
qi(10,:) = qi(1,:);


% Marco de referencia de la camara a sistema absoluto
x = 0.053 + entrada_x;
y = 0.040 + entrada_y;

% MTH del tool
R_tool = [  1  0  0;
            0 -1  0;
            0  0 -1];

% Punto de aproximación
P = [x,y,0.1]';

% Rotación respecto a z para orientación del efector
Rot = rotz(atan2(P(2),P(1)))*R_tool;
MTH = rt2tr(Rot, P);
qi(2,:) = [R1.ikunc(MTH,qi(1,1:4)) 0 0]; % Llamamos la función del toolbox

% Punto de recogida
P = [x,y,0.03]';

% Rotación respecto a z para orientación del efector
Rot = rotz(atan2(P(2),P(1)))*R_tool;
MTH = rt2tr(Rot, P);
qi(3,:) = [R1.ikunc(MTH,qi(2,1:4)) 0 0]; % Llamamos la función del toolbox

% Cierre del griper
qi(4,:) = [qi(3,1:4) 0.016 0.016];

% Punto de elevación
P = [x,y,0.15]';

% Rotación respecto a z para orientación del efector
Rot = rotz(atan2(P(2),P(1)))*R_tool;
MTH = rt2tr(Rot, P);
qi(5,:) = [R1.ikunc(MTH,qi(4,1:4)) 0.016 0.016];
mover_gazebo(qi,'1')
end

function rutina_robot2(entrada_x,entrada_y)

d = 0.42; % Distancia entre robots

% Definición del robot
L2(1) = Link('revolute','alpha',0,'a',d,'d',0.137,'offset',pi,'modified');
L2(2) = Link('revolute','alpha',-pi/2,'a',0,'d',0,'offset',-pi/2,'qlim',[-pi/2 30*pi/180] ,'modified');
L2(3) = Link('revolute','alpha',0,'a',0.105,'d',0,'offset',0,'modified');
L2(4) = Link('revolute','alpha',0,'a',0.105,'d',0,'offset',0,'modified');

R_tool = [0  0  1;
         -1  0  0;
          0 -1  0];
P_tool = [0.11 0 0]';
T_4_tool = rt2tr(R_tool,P_tool);
R2 = SerialLink(L2,'name','phantom2');
R2.tool = T_4_tool;

% Posiciones fijas
qi(1,:) = [0   -1.0000    2.4000    0.5000         0         0];
qi(6,:) = [0.7056    0.9746    0.0000    2.1607    0.0160    0.0160];
qi(7,:) = [0.7056    0.8976    0.9875    1.2565    0.0160    0.0160];
qi(8,:) = [0.7056    0.8976    0.9875    1.2565         0         0];
qi(9,:) = [0.7056    0.9746    0.0000    2.1607         0         0];
qi(10,:) = qi(1,:);

% Marco de referencia de la camara a sistema absoluto
x = 0.225 + entrada_x;
y = 0.040 + entrada_y;

% MTH del tool
R_tool = [ -1  0  0;
            0  1  0;
            0  0 -1];

% Punto de aproximación
P = [x,y,0.1]';

% Rotación respecto a z para orientación del efector
Rot = rotz(-atan2(P(2),d-P(1)))*R_tool;
MTH = rt2tr(Rot, P);
qi(2,:) = [R2.ikunc(MTH,qi(1,1:4)) 0 0]; % Llamamos la función del toolbox del toolbox

% Punto de recogida
P = [x,y,0.03]';

% Rotación respecto a z para orientación del efector
Rot = rotz(-atan2(P(2),d-P(1)))*R_tool;
MTH = rt2tr(Rot, P);
qi(3,:) = [R2.ikunc(MTH,qi(2,1:4)) 0 0]; %Llamamos la función del toolbox

% Cierre del griper
qi(4,:) = [qi(3,1:4) 0.016 0.016];

% Punto de elevación
P = [x,y,0.15]';

% Rotación respecto a z para orientación del efector
Rot = rotz(-atan2(P(2),d-P(1)))*R_tool;
MTH = rt2tr(Rot, P);
qi(5,:) = [R2.ikunc(MTH,qi(4,1:4)) 0.016 0.016];
mover_gazebo(qi,'2')
end

function mover_gazebo(qi,num)
rosinit
phantompos = rospublisher("/robot_"+num+"/phantom_position_controller/command");
message = rosmessage(phantompos);
positionreal = rossubscriber("/robot_"+num+"/joint_states");
pause(1);

for i = 1:length(qi)
    message.Data = qi(i,:);
    send(phantompos,message);
    states = receive(positionreal,2).Position;
    states = round([states(3:6)' states(1:2)'],2);
    while  ~isequal( states, round(qi(i,:),2) )
        states = receive(positionreal,1).Position;
        states = round([states(3:6)' states(1:2)'],2);
    end
end

rosshutdown
end