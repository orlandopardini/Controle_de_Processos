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

% Parâmetros
CA0rp = 0.925;
k = 0.5;
V = 2.1;
F = 0.085;
CArp = 0.236;

tau = V / (F + 2*k*V*CArp);
Kp = F / (F + 2*k*V*CArp);

MCA0 = 0.1;

tempo = 101;
amostragem = 1;
numeropontos = tempo / amostragem;
t_step = 0;

%% Nome do modelo
modelName = 'CSTR_Linear_NaoLinear';
new_system(modelName)
open_system(modelName)
set_param(modelName, 'StopTime', num2str(tempo))

%% --- NÃO LINEAR ---

% Degrau CA0
add_block('simulink/Sources/Step', [modelName '/CA0_step'], ...
    'Time', 't_step', 'Before', 'CA0rp', 'After', ['CA0rp + ' num2str(MCA0)])

% MATLAB Function: Não Linear ODE
NL_path = [modelName '/NaoLinear'];
add_block('simulink/User-Defined Functions/MATLAB Function', NL_path)

% Esperar o Stateflow registrar
pause(1)

% Inserir código:
rt = sfroot;
mymodel = rt.find('-isa','Simulink.BlockDiagram','Name',modelName);
chart_NL = mymodel.find('-isa','Stateflow.EMChart','Name','NaoLinear');
chart_NL.Script = sprintf([...
    'function y = NaoLinear(F,V,k,CA0,CA)\n',...
    'y = (F/V)*(CA0 - CA) - k*CA^2;\n']);

% Constantes F, V, k
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/F'], 'Value', 'F')
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/V'], 'Value', 'V')
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/k'], 'Value', 'k')

% Integrador
add_block('simulink/Continuous/Integrator', [modelName '/Int_NL'])

% Scope
add_block('simulink/Sinks/Scope', [modelName '/Scope_NL'])
add_block('simulink/Sinks/To Workspace', [modelName '/ToWS_NL'], 'VariableName', 'CANL')

% Conexões Não Linear
add_line(modelName, 'F/1', 'NaoLinear/1')
add_line(modelName, 'V/1', 'NaoLinear/2')
add_line(modelName, 'k/1', 'NaoLinear/3')
add_line(modelName, 'CA0_step/1', 'NaoLinear/4')
add_line(modelName, 'Int_NL/1', 'NaoLinear/5')

add_line(modelName, 'NaoLinear/1', 'Int_NL/1')

add_line(modelName, 'Int_NL/1', 'Scope_NL/1')
add_line(modelName, 'Int_NL/1', 'ToWS_NL/1')

%% --- LINEAR ---

% Degrau CA0
add_block('simulink/Sources/Step', [modelName '/CA0_step_L'], ...
    'Time', 't_step', 'Before', '0', 'After', 'MCA0')

% Transfer Function
add_block('simulink/Continuous/Transfer Fcn', [modelName '/TF_L'], ...
    'Numerator', 'Kp', 'Denominator', '[tau 1]')

% Constante CArp
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/CArp'], 'Value', 'CArp')

% Somador
add_block('simulink/Math Operations/Sum', [modelName '/Sum_L'], 'Inputs', '++')

% Scope e To Workspace
add_block('simulink/Sinks/Scope', [modelName '/Scope_L'])
add_block('simulink/Sinks/To Workspace', [modelName '/ToWS_L'], 'VariableName', 'CAL')

% Conexões Linear
add_line(modelName, 'CA0_step_L/1', 'TF_L/1')
add_line(modelName, 'TF_L/1', 'Sum_L/1')
add_line(modelName, 'CArp/1', 'Sum_L/2')

add_line(modelName, 'Sum_L/1', 'Scope_L/1')
add_line(modelName, 'Sum_L/1', 'ToWS_L/1')

%% --- Layout (básico) ---
set_param([modelName '/CA0_step'], 'Position', [30 50 60 70])
set_param([modelName '/F'], 'Position', [30 100 60 120])
set_param([modelName '/V'], 'Position', [30 150 60 170])
set_param([modelName '/k'], 'Position', [30 200 60 220])
set_param(NL_path, 'Position', [150 100 250 200])
set_param([modelName '/Int_NL'], 'Position', [300 130 330 160])
set_param([modelName '/Scope_NL'], 'Position', [400 100 430 130])
set_param([modelName '/ToWS_NL'], 'Position', [400 150 430 170])

set_param([modelName '/CA0_step_L'], 'Position', [30 300 60 320])
set_param([modelName '/TF_L'], 'Position', [100 300 150 320])
set_param([modelName '/CArp'], 'Position', [100 350 150 370])
set_param([modelName '/Sum_L'], 'Position', [200 300 230 320])
set_param([modelName '/Scope_L'], 'Position', [300 300 330 320])
set_param([modelName '/ToWS_L'], 'Position', [300 350 330 370])

%% --- Salvar e abrir ---
save_system(modelName)
open_system(modelName)
