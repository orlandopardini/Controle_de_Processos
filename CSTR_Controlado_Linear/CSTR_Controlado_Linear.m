%% ============================================================
%  Autor: Orlando Pardini Gardezani
%  Contato: orlando.pardini@outlook.com
%  Descrição:
%     Este script/modelo foi desenvolvido por Orlando Pardini Gardezani
%     com finalidade acadêmica e profissional para análise e simulação
%     de sistemas dinâmicos em MATLAB e Simulink.
%     Uso restrito ao autor e colaboradores autorizados.
%
%  Direitos Autorais:
%     © Orlando Pardini Gardezani. Todos os direitos reservados.
%     Reprodução total ou parcial somente com autorização expressa.
%% ============================================================

clc
close all
bdclose all

%% Parâmetros
tempo = 101;
amostragem = 1;
numerodepontos = tempo/amostragem;
t_step = 0;

CA0rp = 0.925;
Frp = 0.085;
CArp = 0.236;
k = 0.5;
V = 2.1;

tau = V / (Frp + 2*k*V*CArp);
K1 = (CA0rp - CArp) / (Frp + 2*k*V*CArp);
K2 = Frp / (Frp + 2*k*V*CArp);

MCA0_s = 0; % sem controle
MF_s = 0;   % sem controle
MSET = 4;   % Servo
MCA0 = 3;   % Regulatório

% Válvula
Kv = 3.67; tauv = 0.1;

% Transmissor
Kt = 50; taut = 0.5;

% PID Controlador
Kc = 1; tauI = 1; tauD = 0.1;
P = Kc; I = Kc/tauI; D = Kc*tauD;

%% Modelo
modelName = 'CSTR_Controlado_Linear';
new_system(modelName)
open_system(modelName)
set_param(modelName, 'StopTime', num2str(tempo))

%% === 1) Linear sem controle ===
% Degraus
add_block('simulink/Sources/Step', [modelName '/F_step'], 'Time', 't_step', 'Before', '0', 'After', num2str(MF_s))
add_block('simulink/Sources/Step', [modelName '/CA0_step'], 'Time', 't_step', 'Before', '0', 'After', num2str(MCA0_s))

% TFs
add_block('simulink/Continuous/Transfer Fcn', [modelName '/TF1'], 'Numerator', 'K1', 'Denominator', '[tau 1]')
add_block('simulink/Continuous/Transfer Fcn', [modelName '/TF2'], 'Numerator', 'K2', 'Denominator', '[tau 1]')

% Somadores
add_block('simulink/Math Operations/Sum', [modelName '/Sum1'], 'Inputs', '++')
add_block('simulink/Math Operations/Sum', [modelName '/Sum2'], 'Inputs', '++')

% CArp
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/CArp'], 'Value', 'CArp')

% Scope e Workspace
add_block('simulink/Sinks/Scope', [modelName '/Scope_CAL'])
add_block('simulink/Sinks/To Workspace', [modelName '/CAL_WS'], 'VariableName', 'CAL')

% Conexões sem controle
add_line(modelName, 'F_step/1', 'TF1/1')
add_line(modelName, 'CA0_step/1', 'TF2/1')
add_line(modelName, 'TF1/1', 'Sum1/1')
add_line(modelName, 'TF2/1', 'Sum1/2')
add_line(modelName, 'Sum1/1', 'Sum2/1')
add_line(modelName, 'CArp/1', 'Sum2/2')
add_line(modelName, 'Sum2/1', 'Scope_CAL/1')
add_line(modelName, 'Sum2/1', 'CAL_WS/1')

% Layout Sem Controle
set_param([modelName '/F_step'], 'Position', [30 30 60 50])
set_param([modelName '/CA0_step'], 'Position', [30 80 60 100])
set_param([modelName '/TF1'], 'Position', [100 30 150 50])
set_param([modelName '/TF2'], 'Position', [100 80 150 100])
set_param([modelName '/Sum1'], 'Position', [200 50 230 70])
set_param([modelName '/CArp'], 'Position', [200 90 230 110])
set_param([modelName '/Sum2'], 'Position', [270 70 300 90])
set_param([modelName '/Scope_CAL'], 'Position', [350 50 380 70])
set_param([modelName '/CAL_WS'], 'Position', [350 90 380 110])

%% === 2) Linear com controle ===
% Servo degrau
add_block('simulink/Sources/Step', [modelName '/Setpoint_step'], 'Time', 't_step', 'Before', '0', 'After', num2str(MSET))

% TFs: Válvula, Processo, Transmissor
add_block('simulink/Continuous/Transfer Fcn', [modelName '/Valve'], 'Numerator', 'Kv', 'Denominator', ['[' num2str(tauv) ' 1]'])
add_block('simulink/Continuous/Transfer Fcn', [modelName '/Process'], 'Numerator', 'K1', 'Denominator', '[tau 1]')
add_block('simulink/Continuous/Transfer Fcn', [modelName '/Transmitter'], 'Numerator', 'Kt', 'Denominator', ['[' num2str(taut) ' 1]'])

% PID Controller
add_block('simulink/Continuous/PID Controller', [modelName '/PID'], 'P', num2str(P), 'I', num2str(I), 'D', num2str(D))

% Somadores
add_block('simulink/Math Operations/Sum', [modelName '/Sum_Err'], 'Inputs', '+-')
add_block('simulink/Math Operations/Sum', [modelName '/Sum_CA'], 'Inputs', '++')

% CArp
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/CArp2'], 'Value', 'CArp')

% Scope e Workspace
add_block('simulink/Sinks/Scope', [modelName '/Scope_CA'])
add_block('simulink/Sinks/To Workspace', [modelName '/CA_WS'], 'VariableName', 'CA')

% Conexões com controle
add_line(modelName, 'Setpoint_step/1', 'Sum_Err/1')
add_line(modelName, 'Transmitter/1', 'Sum_Err/2')
add_line(modelName, 'Sum_Err/1', 'PID/1')
add_line(modelName, 'PID/1', 'Valve/1')
add_line(modelName, 'Valve/1', 'Process/1')
add_line(modelName, 'Process/1', 'Transmitter/1')
add_line(modelName, 'Process/1', 'Sum_CA/1')
add_line(modelName, 'CArp2/1', 'Sum_CA/2')
add_line(modelName, 'Sum_CA/1', 'Scope_CA/1')
add_line(modelName, 'Sum_CA/1', 'CA_WS/1')

% Layout Com Controle
set_param([modelName '/Setpoint_step'], 'Position', [30 200 60 220])
set_param([modelName '/Transmitter'], 'Position', [200 300 250 320])
set_param([modelName '/Sum_Err'], 'Position', [100 200 130 220])
set_param([modelName '/PID'], 'Position', [170 200 200 220])
set_param([modelName '/Valve'], 'Position', [240 200 270 220])
set_param([modelName '/Process'], 'Position', [310 200 340 220])
set_param([modelName '/Sum_CA'], 'Position', [370 200 400 220])
set_param([modelName '/CArp2'], 'Position', [370 250 400 270])
set_param([modelName '/Scope_CA'], 'Position', [450 200 480 220])
set_param([modelName '/CA_WS'], 'Position', [450 250 480 270])

%% --- Final ---
save_system(modelName)
open_system(modelName)
