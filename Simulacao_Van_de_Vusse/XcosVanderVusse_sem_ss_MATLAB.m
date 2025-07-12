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
MCA = 0; % amplitude degrau em CAf
MF = 0;  % amplitude degrau em F

% Nome do modelo
modelName = 'VanderVusse_Step';
new_system(modelName)
open_system(modelName)
set_param(modelName, 'StopTime', num2str(tempo))

%% Blocos principais

% Constantes
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/F'], 'Value', 'F')
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/CAf'], 'Value', 'CAf')
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/MF'], 'Value', 'MF')
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/MCA'], 'Value', 'MCA')

% Somadores
add_block('simulink/Math Operations/Sum', [modelName '/Sum_F'], 'Inputs', '++')
add_block('simulink/Math Operations/Sum', [modelName '/Sum_CAf'], 'Inputs', '++')

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

% Esperar um pouco para o Simulink registrar os blocos
pause(1)

chart_CA = mymodel.find('-isa','Stateflow.EMChart','Name','f_CA');
chart_CA.Script = sprintf([...
    'function y = f_CA(F, CAf, CA)\n',...
    'k1 = %f; k3 = %f; V = %f;\n',...
    'y = (F/V)*(CAf - CA) - k1*CA - k3*CA^2;\n'], k1, k3, V);

chart_CB = mymodel.find('-isa','Stateflow.EMChart','Name','f_CB');
chart_CB.Script = sprintf([...
    'function y = f_CB(F, CA, CB)\n',...
    'k1 = %f; k2 = %f; V = %f;\n',...
    'y = - (F/V)*CB + k1*CA - k2*CB;\n'], k1, k2, V);

% Scope 2 entradas
scopePath = [modelName '/Scope'];
add_block('simulink/Sinks/Scope', scopePath)
set_param(scopePath, 'NumInputPorts', '2')

% To Workspace
add_block('simulink/Sinks/To Workspace', [modelName '/CA_out'], 'VariableName', 'CA_out')
add_block('simulink/Sinks/To Workspace', [modelName '/CB_out'], 'VariableName', 'CB_out')

%% Conexões

% Somar F + MF
add_line(modelName, 'F/1', 'Sum_F/1')
add_line(modelName, 'MF/1', 'Sum_F/2')

% Somar CAf + MCA
add_line(modelName, 'CAf/1', 'Sum_CAf/1')
add_line(modelName, 'MCA/1', 'Sum_CAf/2')

% f_CA: entradas F, CAf, CA
add_line(modelName, 'Sum_F/1', 'f_CA/1')
add_line(modelName, 'Sum_CAf/1', 'f_CA/2')
add_line(modelName, 'Int_CA/1', 'f_CA/3')

% f_CA -> Integrador CA
add_line(modelName, 'f_CA/1', 'Int_CA/1')

% f_CB: entradas F, CA, CB
add_line(modelName, 'Sum_F/1', 'f_CB/1')
add_line(modelName, 'Int_CA/1', 'f_CB/2')
add_line(modelName, 'Int_CB/1', 'f_CB/3')

% f_CB -> Integrador CB
add_line(modelName, 'f_CB/1', 'Int_CB/1')

% Saídas para Scope (2 entradas)
add_line(modelName, 'Int_CA/1', 'Scope/1')
add_line(modelName, 'Int_CB/1', 'Scope/2')

% Saídas para Workspace
add_line(modelName, 'Int_CA/1', 'CA_out/1')
add_line(modelName, 'Int_CB/1', 'CB_out/1')

%% Layout
set_param([modelName '/F'], 'Position', [30 50 60 70])
set_param([modelName '/MF'], 'Position', [30 100 60 120])
set_param([modelName '/CAf'], 'Position', [30 200 60 220])
set_param([modelName '/MCA'], 'Position', [30 250 60 270])

set_param([modelName '/Sum_F'], 'Position', [100 50 150 120])
set_param([modelName '/Sum_CAf'], 'Position', [100 200 150 270])

set_param(f_CA_path, 'Position', [200 100 300 200])
set_param(f_CB_path, 'Position', [200 250 300 350])

set_param([modelName '/Int_CA'], 'Position', [350 120 380 150])
set_param([modelName '/Int_CB'], 'Position', [350 280 380 310])

set_param(scopePath, 'Position', [450 200 480 260])
set_param([modelName '/CA_out'], 'Position', [450 150 480 170])
set_param([modelName '/CB_out'], 'Position', [450 310 480 330])

%% Salvar e abrir
save_system(modelName)
open_system(modelName)
