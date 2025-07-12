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

%% Limpeza e contexto
clc
close all
bdclose all

tempo = 20;
amostragem = 0.01;

% Parâmetros
k1 = 5/6;
k2 = 5/3;
k3 = 1/6;
V = 7;
F = 4;
CAf = 10;
CA0 = 0;
CB0 = 0;

% Nome do modelo
modelName = 'VanderVusse_FinalScope';
new_system(modelName)
open_system(modelName)
set_param(modelName, 'StopTime', num2str(tempo))

%% Blocos principais

% Constantes
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/F'], 'Value', 'F')
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/CAf'], 'Value', 'CAf')

% Integradores
add_block('simulink/Continuous/Integrator', [modelName '/Int_CA'], 'InitialCondition', 'CA0')
add_block('simulink/Continuous/Integrator', [modelName '/Int_CB'], 'InitialCondition', 'CB0')

% MATLAB Function para f_CA
f_CA_path = [modelName '/f_CA'];
add_block('simulink/User-Defined Functions/MATLAB Function', f_CA_path)

% MATLAB Function para f_CB
f_CB_path = [modelName '/f_CB'];
add_block('simulink/User-Defined Functions/MATLAB Function', f_CB_path)

% Inserir o código usando Stateflow API:
rt = sfroot;
mymodel = rt.find('-isa','Simulink.BlockDiagram','Name',modelName);

chart_CA = mymodel.find('-isa','Stateflow.EMChart','Name','f_CA');
chart_CA.Script = sprintf([...
    'function y = f_CA(F, CAf, CA)\n',...
    '%% Dinâmica de CA\n',...
    'k1 = %f; k3 = %f; V = %f;\n',...
    'y = (F/V)*(CAf - CA) - k1*CA - k3*CA^2;\n'], k1, k3, V);

chart_CB = mymodel.find('-isa','Stateflow.EMChart','Name','f_CB');
chart_CB.Script = sprintf([...
    'function y = f_CB(F, CA, CB)\n',...
    '%% Dinâmica de CB\n',...
    'k1 = %f; k2 = %f; V = %f;\n',...
    'y = - (F/V)*CB + k1*CA - k2*CB;\n'], k1, k2, V);

% Scope com 2 entradas
scopePath = [modelName '/Scope'];
add_block('simulink/Sinks/Scope', scopePath)
set_param(scopePath, 'NumInputPorts', '2') % agora tem 2 portas

% To Workspace
add_block('simulink/Sinks/To Workspace', [modelName '/CA_out'], 'VariableName', 'CA_out')
add_block('simulink/Sinks/To Workspace', [modelName '/CB_out'], 'VariableName', 'CB_out')

%% Conexões

% f_CA: entradas F, CAf, CA
add_line(modelName, 'F/1', 'f_CA/1')
add_line(modelName, 'CAf/1', 'f_CA/2')
add_line(modelName, 'Int_CA/1', 'f_CA/3')

% f_CA -> Integrador CA
add_line(modelName, 'f_CA/1', 'Int_CA/1')

% f_CB: entradas F, CA, CB
add_line(modelName, 'F/1', 'f_CB/1')
add_line(modelName, 'Int_CA/1', 'f_CB/2')
add_line(modelName, 'Int_CB/1', 'f_CB/3')

% f_CB -> Integrador CB
add_line(modelName, 'f_CB/1', 'Int_CB/1')

% Saídas para Scope (agora com 2 entradas)
add_line(modelName, 'Int_CA/1', 'Scope/1')
add_line(modelName, 'Int_CB/1', 'Scope/2')

% Saídas para Workspace
add_line(modelName, 'Int_CA/1', 'CA_out/1')
add_line(modelName, 'Int_CB/1', 'CB_out/1')

%% Layout (opcional para ficar organizado)
set_param([modelName '/F'], 'Position', [30 50 60 70])
set_param([modelName '/CAf'], 'Position', [30 120 60 140])

set_param(f_CA_path, 'Position', [150 50 250 150])
set_param(f_CB_path, 'Position', [150 180 250 280])

set_param([modelName '/Int_CA'], 'Position', [300 80 330 110])
set_param([modelName '/Int_CB'], 'Position', [300 210 330 240])

set_param(scopePath, 'Position', [420 100 450 220])
set_param([modelName '/CA_out'], 'Position', [420 60 450 80])
set_param([modelName '/CB_out'], 'Position', [420 250 450 270])

%% Salvar e abrir
save_system(modelName)
open_system(modelName)
