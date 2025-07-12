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
V = 2.0;
rho = 900;
mo = 1000;
Cp = 1000;

tau = (rho*V)/mo;
KT0 = 1;
KQ = 1/(mo*Cp);

T0rp = 100;
Qrp = 3e7;
Trp = 130;

MT0_B = 0;
MQ_B = (1.3*Qrp) - Qrp;

MT0_C = 120 - T0rp;
MQ_C = 0;

MT0_D = 130 - T0rp;
MQ_D = (1.1*Qrp) - Qrp;

tempo = 15;
amostragem = 0.01;
numerodepontos = tempo/amostragem;
tstep = 0;

%% Nome do modelo
modelName = 'Problema3_BCD';
new_system(modelName)
open_system(modelName)
set_param(modelName, 'StopTime', num2str(tempo))

%% Criar malhas B, C, D
create_loop('B', MT0_B, MQ_B, KT0, KQ, tau, Trp, modelName, 50)
create_loop('C', MT0_C, MQ_C, KT0, KQ, tau, Trp, modelName, 200)
create_loop('D', MT0_D, MQ_D, KT0, KQ, tau, Trp, modelName, 350)

%% MUX final para tudo junto
add_block('simulink/Signal Routing/Mux', [modelName '/MUX_Final'], 'Inputs', '3')
add_block('simulink/Sinks/Scope', [modelName '/Scope_Final'], 'NumInputPorts', '1')

% Conectar saídas das malhas ao MUX
add_line(modelName, 'SumQ_B/1', 'MUX_Final/1')
add_line(modelName, 'SumQ_C/1', 'MUX_Final/2')
add_line(modelName, 'SumQ_D/1', 'MUX_Final/3')

% MUX -> Scope Final
add_line(modelName, 'MUX_Final/1', 'Scope_Final/1')

% Posicionar
set_param([modelName '/MUX_Final'], 'Position', [500 200 530 250])
set_param([modelName '/Scope_Final'], 'Position', [600 200 630 250])

%% Salvar e abrir
save_system(modelName)
open_system(modelName)

%% Função auxiliar (NO FIM!)
function create_loop(loop_name, MT0, MQ, KT0, KQ, tau, Trp, modelName, posY)

    % Degraus
    add_block('simulink/Sources/Step', [modelName '/XT0_' loop_name], 'Time', 'tstep', 'Before', 'T0rp', 'After', ['T0rp + ' num2str(MT0)])
    add_block('simulink/Sources/Step', [modelName '/XQ_' loop_name], 'Time', 'tstep', 'Before', 'Qrp', 'After', ['Qrp + ' num2str(MQ)])
    
    % Transfer Functions
    add_block('simulink/Continuous/Transfer Fcn', [modelName '/TF_T0_' loop_name], 'Numerator', 'KT0', 'Denominator', '[tau 1]')
    add_block('simulink/Continuous/Transfer Fcn', [modelName '/TF_Q_' loop_name], 'Numerator', 'KQ', 'Denominator', '[tau 1]')
    
    % Somadores
    add_block('simulink/Math Operations/Sum', [modelName '/SumT0_' loop_name], 'Inputs', '++')
    add_block('simulink/Math Operations/Sum', [modelName '/SumQ_' loop_name], 'Inputs', '++')
    
    % Constante Trp
    add_block('simulink/Commonly Used Blocks/Constant', [modelName '/Trp_' loop_name], 'Value', 'Trp')
    
    % Scope individual
    add_block('simulink/Sinks/Scope', [modelName '/Scope_' loop_name])
    set_param([modelName '/Scope_' loop_name], 'NumInputPorts', '1')
    
    % To Workspace
    add_block('simulink/Sinks/To Workspace', [modelName '/ToWS_' loop_name], 'VariableName', ['T_' loop_name])
    
    % Ligações T0
    add_line(modelName, ['XT0_' loop_name '/1'], ['TF_T0_' loop_name '/1'])
    add_line(modelName, ['TF_T0_' loop_name '/1'], ['SumT0_' loop_name '/1'])
    add_line(modelName, ['Trp_' loop_name '/1'], ['SumT0_' loop_name '/2'])
    
    % Ligações Q
    add_line(modelName, ['XQ_' loop_name '/1'], ['TF_Q_' loop_name '/1'])
    add_line(modelName, ['TF_Q_' loop_name '/1'], ['SumQ_' loop_name '/1'])
    add_line(modelName, ['SumT0_' loop_name '/1'], ['SumQ_' loop_name '/2'])
    
    % Saída final
    add_line(modelName, ['SumQ_' loop_name '/1'], ['Scope_' loop_name '/1'])
    add_line(modelName, ['SumQ_' loop_name '/1'], ['ToWS_' loop_name '/1'])
    
    % Posição automática básica (ajuste visual manual depois se quiser)
    xShift = 100;
    yShift = posY;
    set_param([modelName '/XT0_' loop_name], 'Position', [30 yShift 60 yShift+20])
    set_param([modelName '/XQ_' loop_name], 'Position', [30 yShift+60 60 yShift+80])
    set_param([modelName '/TF_T0_' loop_name], 'Position', [100 yShift 150 yShift+20])
    set_param([modelName '/TF_Q_' loop_name], 'Position', [100 yShift+60 150 yShift+80])
    set_param([modelName '/SumT0_' loop_name], 'Position', [200 yShift 230 yShift+20])
    set_param([modelName '/SumQ_' loop_name], 'Position', [250 yShift+30 280 yShift+50])
    set_param([modelName '/Trp_' loop_name], 'Position', [100 yShift+30 130 yShift+50])
    set_param([modelName '/Scope_' loop_name], 'Position', [350 yShift+20 380 yShift+50])
    set_param([modelName '/ToWS_' loop_name], 'Position', [350 yShift+60 380 yShift+80])
end
