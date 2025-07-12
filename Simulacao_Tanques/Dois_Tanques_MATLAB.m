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

% Parâmetros do problema 3
Forp = 8;
A = 0.3;
k = 8;
hrp = 1;

tau = (2*A*sqrt(hrp))/k;
Kp = (2*sqrt(hrp))/k;

M = 10 - Forp;

tempo = 6 * tau;
amostragem = 0.01;
numerodepontos = tempo / amostragem;
tstep = 0;

%% Nome do modelo
modelName = 'Problema3_Reservatorio';
new_system(modelName)
open_system(modelName)
set_param(modelName, 'StopTime', num2str(tempo))

%% Blocos

% Degrau XF0
add_block('simulink/Sources/Step', [modelName '/XF0'], 'Time', 'tstep', 'Before', 'Forp', 'After', 'M+Forp')

% Transfer Function Kp/(1+s*tau)
add_block('simulink/Continuous/Transfer Fcn', [modelName '/TF'], ...
    'Numerator', 'Kp', 'Denominator', '[tau 1]')

% Integrator 1/(A*s)
add_block('simulink/Continuous/Integrator', [modelName '/Integrator'])
add_block('simulink/Math Operations/Gain', [modelName '/1_over_A'], 'Gain', ['1/' num2str(A)])

% Somadores
add_block('simulink/Math Operations/Sum', [modelName '/Sum1'], 'Inputs', '++')
add_block('simulink/Math Operations/Sum', [modelName '/Sum2'], 'Inputs', '++')

% Constantes hrp
add_block('simulink/Commonly Used Blocks/Constant', [modelName '/hrp'], 'Value', 'hrp')

% MUX
add_block('simulink/Signal Routing/Mux', [modelName '/MUX'], 'Inputs', '2')

% Scope
add_block('simulink/Sinks/Scope', [modelName '/Scope'])
set_param([modelName '/Scope'], 'NumInputPorts', '2')

% To Workspace
add_block('simulink/Sinks/To Workspace', [modelName '/h_out'], 'VariableName', 'h_out')

%% Conexões

% XF0 -> TF -> Sum1 -> MUX -> Scope
add_line(modelName, 'XF0/1', 'TF/1')
add_line(modelName, 'TF/1', 'Sum1/1')
add_line(modelName, 'hrp/1', 'Sum1/2')

% Sum1 -> MUX input 1
add_line(modelName, 'Sum1/1', 'MUX/1')

% XF0 -> Gain -> Integrator -> Sum2 -> MUX input 2
add_line(modelName, 'XF0/1', '1_over_A/1')
add_line(modelName, '1_over_A/1', 'Integrator/1')
add_line(modelName, 'Integrator/1', 'Sum2/1')
add_line(modelName, 'hrp/1', 'Sum2/2')
add_line(modelName, 'Sum2/1', 'MUX/2')

% MUX -> Scope
add_line(modelName, 'MUX/1', 'Scope/1')

% MUX -> To Workspace
add_line(modelName, 'MUX/1', 'h_out/1')

%% Layout (opcional)
set_param([modelName '/XF0'], 'Position', [30 50 60 70])
set_param([modelName '/TF'], 'Position', [100 50 160 80])
set_param([modelName '/Sum1'], 'Position', [200 50 230 80])
set_param([modelName '/hrp'], 'Position', [100 100 130 120])
set_param([modelName '/MUX'], 'Position', [300 50 330 120])
set_param([modelName '/Scope'], 'Position', [400 60 430 130])
set_param([modelName '/h_out'], 'Position', [400 140 430 160])

set_param([modelName '/1_over_A'], 'Position', [100 200 140 230])
set_param([modelName '/Integrator'], 'Position', [200 200 230 230])
set_param([modelName '/Sum2'], 'Position', [260 200 290 230])

%% Salvar e abrir
save_system(modelName)
open_system(modelName)
