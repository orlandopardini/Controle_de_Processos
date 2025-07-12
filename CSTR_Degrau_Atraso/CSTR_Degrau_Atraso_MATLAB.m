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
amostragem = 0.01;
numeropontos = tempo/amostragem;
t_step = 5;

CA0rp = 0.925;
Frp = 0.085;
CArp = 0.236;
k = 0.5;
V = 2.1;

tau = V / (Frp + 2*k*V*CArp);
K1 = (CA0rp - CArp) / (Frp + 2*k*V*CArp);
K2 = Frp / (Frp + 2*k*V*CArp);

MCA0 = 0.1;
MF = 0;

%% Nome do modelo
modelName = 'CSTR_Degrau_Atraso';
new_system(modelName)
open_system(modelName)
set_param(modelName, 'StopTime', num2str(tempo))

%% === Blocos ===

% Degraus
add_block('simulink/Sources/Step', [modelName '/F_step'], ...
    'Time', 't_step', 'Before', '0', 'After', num2str(MF))
add_block('simulink/Sources/Step', [modelName '/CA0_step'], ...
    'Time', 't_step', 'Before', '0', 'After', num2str(MCA0))

% Transfer Functions
add_block('simulink/Continuous/Transfer Fcn', [modelName '/G1'], ...
    'Numerator', 'K1', 'Denominator', '[tau 1]')
add_block('simulink/Continuous/Transfer Fcn', [modelName '/G2'], ...
    'Numerator', 'K2', 'Denominator', '[tau 1]')

% Somadores
add_block('simulink/Math Operations/Sum', [modelName '/SumG'], 'Inputs', '++')
add_block('simulink/Math Operations/Sum', [modelName '/Sum_CA'], 'Inputs', '++')
add_block('simulink/Math Operations/Sum', [modelName '/Sum_CA0'], 'Inputs', '++')

% Constantes
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/CArp'], 'Value', 'CArp')
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/CA0rp'], 'Value', 'CA0rp')

% Scopes e To Workspace
add_block('simulink/Sinks/Scope', [modelName '/Scope_CA'])
add_block('simulink/Sinks/To Workspace', [modelName '/WS_CA'], 'VariableName', 'CA')

add_block('simulink/Sinks/Scope', [modelName '/Scope_CA0'])
add_block('simulink/Sinks/To Workspace', [modelName '/WS_CA0'], 'VariableName', 'CA0')

%% === Conexões ===

% F -> G1 -> SumG
add_line(modelName, 'F_step/1', 'G1/1')
add_line(modelName, 'G1/1', 'SumG/1')

% CA0 -> G2 -> SumG
add_line(modelName, 'CA0_step/1', 'G2/1')
add_line(modelName, 'G2/1', 'SumG/2')

% SumG -> Sum_CA + CArp
add_line(modelName, 'SumG/1', 'Sum_CA/1')
add_line(modelName, 'CArp/1', 'Sum_CA/2')

% Sum_CA -> Scope + WS
add_line(modelName, 'Sum_CA/1', 'Scope_CA/1')
add_line(modelName, 'Sum_CA/1', 'WS_CA/1')

% CA0_step + CA0rp
add_line(modelName, 'CA0_step/1', 'Sum_CA0/1')
add_line(modelName, 'CA0rp/1', 'Sum_CA0/2')

% Sum_CA0 -> Scope + WS
add_line(modelName, 'Sum_CA0/1', 'Scope_CA0/1')
add_line(modelName, 'Sum_CA0/1', 'WS_CA0/1')

%% === Layout ===

set_param([modelName '/F_step'], 'Position', [30 30 60 50])
set_param([modelName '/CA0_step'], 'Position', [30 100 60 120])

set_param([modelName '/G1'], 'Position', [100 30 150 50])
set_param([modelName '/G2'], 'Position', [100 100 150 120])

set_param([modelName '/SumG'], 'Position', [200 60 230 80])
set_param([modelName '/Sum_CA'], 'Position', [300 60 330 80])
set_param([modelName '/Sum_CA0'], 'Position', [200 130 230 150])

set_param([modelName '/CArp'], 'Position', [250 90 280 110])
set_param([modelName '/CA0rp'], 'Position', [150 150 180 170])

set_param([modelName '/Scope_CA'], 'Position', [400 60 430 80])
set_param([modelName '/WS_CA'], 'Position', [400 90 430 110])

set_param([modelName '/Scope_CA0'], 'Position', [300 160 330 180])
set_param([modelName '/WS_CA0'], 'Position', [300 190 330 210])

%% === Salvar e abrir ===

save_system(modelName)
open_system(modelName)
