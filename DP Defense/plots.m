clear all 
clc

color_blue = '[.11,.40,1]';
color_red = '[.86,.07,.23]';
color_brown = '[.8,.46,.13]';
color_purple = '[.60,0,.82]';

file_name = 'plots.m';
file_path = mfilename('fullpath');
[file_path, ~, ~] = fileparts(file_path);

line_width = 3;
plot_line_width = 5;
plot_size = 45;
marker_size = 30;
x_limit = 12;


%% First Plot
L = 20;
k = 2;
% p = 0:0.1:1;
% answers = -((2^L - 2^(L - k)).*((1 - p)./2^L).*log2(((1 - p)./2^L)) + ...
%     2^(L - k).*((1 + (2^k - 1).*p)./2^L).*log2(((1 + (2^k - 1).*p)./2^L)));
% epsilon = 2*log2(1 + (2^k.*p./(1-p)));
epsilon = 0:1:x_limit;
p = (exp(epsilon/2) - 1)./((exp(epsilon/2) + 2.^k - 1));
answers = -((2^L - 2^(L - k)).*((1 - p)./2^L).*log2(((1 - p)./2^L)) + ...
    2^(L - k).*((1 + (2^k - 1).*p)./2^L).*log2(((1 + (2^k - 1).*p)./2^L)));

data_points = answers;

figure()
hold on
plot_handle_1 = plot(epsilon, answers,...
                     '-*', 'Color', color_blue,...
                    'LineWidth',plot_line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_blue,...
                    'MarkerFaceColor',color_blue);

set(groot, 'defaultAxesTickLabelInterpreter','LaTex'); 
set(groot, 'defaultLegendInterpreter','LaTex');
                 
title([{'Worst case entropy rate of observed sequence'}, ...
    {'$\qquad \qquad$ vs Security parameter $\epsilon$'}] ,...
        'FontSize',plot_size - 4,'Interpreter','Latex');
xlabel({'Security parameter $\epsilon$'},'FontSize',plot_size,'Interpreter','LaTex');
ylabel({'Entropy rate of Observed Sequence'},'FontSize',plot_size,'Interpreter','LaTex');
grid on
%grid minor
axis([0 x_limit 0 L+5]); 
set(gca,'Fontsize',plot_size)
set(gca,'TitleFontWeight','bold')
set(gca,'LineWidth',line_width)
set(gca,'FontName','Verdana')
set(gca,'XMinorTick','on','YMinorTick','on')
%set(gca,'YScale','log');


%% Min-entropy plot

pmax = (1+ (2.^k - 1).*p)/2^L;
min_entropy = - log2(pmax);
marker_size = 20;

plot_handle_2 = plot(epsilon, min_entropy,...
                     '-o', 'Color', color_red,...
                    'LineWidth',plot_line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_red,...
                    'MarkerFaceColor',color_red);
marker_size = 30;


%% Reference Line

xaxis = 1:1:x_limit;
yaxis = L*ones(size(xaxis));
 
plot_handle_3 = plot(xaxis, yaxis,...
                     '--', 'Color', color_brown,...
                    'LineWidth',plot_line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_brown,...
                    'MarkerFaceColor',color_brown);
                
                
%% L = 15

L = 15;
marker_size = marker_size - 5;
p = (exp(epsilon/2) - 1)./((exp(epsilon/2) + 2.^k - 1));
answers = -((2^L - 2^(L - k)).*((1 - p)./2^L).*log2(((1 - p)./2^L)) + ...
    2^(L - k).*((1 + (2^k - 1).*p)./2^L).*log2(((1 + (2^k - 1).*p)./2^L))); 

plot_handle_4 = plot(epsilon, answers,...
                     '-^', 'Color', color_blue,...
                    'LineWidth',plot_line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_blue,...
                    'MarkerFaceColor',color_blue);


%% Min entropy L = 15

pmax = (1+ (2.^k - 1).*p)/2^L;
min_entropy = - log2(pmax);

plot_handle_2 = plot(epsilon, min_entropy,...
                     '-v', 'Color', color_red,...
                    'LineWidth',plot_line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_red,...
                    'MarkerFaceColor',color_red);


                
%% Reference Line 2

xaxis = 1:1:x_limit;
yaxis = L*ones(size(xaxis));
 
plot_handle_4 = plot(xaxis, yaxis,...
                     '--', 'Color', color_purple,...
                    'LineWidth',plot_line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_purple,...
                    'MarkerFaceColor',color_purple);
                
                
% %% Second Plot
% 
% k = 6;
% marker_size = 20;
% p = (exp(epsilon/2) - 1)./((exp(epsilon/2) + 2.^k - 1));
% answers = -((2^L - 2^(L - k)).*((1 - p)./2^L).*log2(((1 - p)./2^L)) + ...
%     2^(L - k).*((1 + (2^k - 1).*p)./2^L).*log2(((1 + (2^k - 1).*p)./2^L))); 
% 
% plot_handle_2 = plot(epsilon, answers,...
%                      '-o', 'Color', color_red,...
%                     'LineWidth',plot_line_width,...
%                     'MarkerSize',marker_size,...
%                     'MarkerEdgeColor',color_red,...
%                     'MarkerFaceColor',color_red);
% 
%                 
% %% Reference Line
% 
% xaxis = 1:1:x_limit;
% yaxis = L*ones(size(xaxis));
%  
% plot_handle_2 = plot(xaxis, yaxis,...
%                      '--', 'Color', color_brown,...
%                     'LineWidth',plot_line_width,...
%                     'MarkerSize',marker_size,...
%                     'MarkerEdgeColor',color_brown,...
%                     'MarkerFaceColor',color_brown);

%% Legend Creation and Saving


legend1 = 'Entropy: $\hspace{12mm}$ k = 1, L = 20';
legend2 = 'Min-Entropy: $\hspace{4.8mm}$ k = 1, L = 20';
legend3 = 'Baseline security: $\hspace{9.8mm}$ L = 20';
legend4 = 'Entropy: $\hspace{12mm}$ k = 1, L = 15';
legend5 = 'Min-Entropy: $\hspace{4.8mm}$ k = 1, L = 15';
legend6 = 'Baseline security: $\hspace{9.8mm}$ L = 15';
legend_handle = legend(legend1, legend2, legend3, legend4, legend5, legend6);
set(legend_handle, 'Interpreter', 'latex', 'FontSize', plot_size, ...
    'Location', 'best');
 
 
set(gcf, 'PaperUnits', 'inches');
x_width = 20;
y_width = 16;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); 
saveas(gcf,[file_path '/DPdefense.png']);                
                

