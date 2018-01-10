
clear all 
clc

color_blue = '[.11,.40,1]';
color_red = '[.86,.07,.23]';
color_brown = '[.8,.46,.13]';
color_purple = '[.60,0,.82]';

file_name = 'time_taken.txt';
file_path = mfilename('fullpath');
[file_path, ~, ~] = fileparts(file_path);

plot_text = 40;
marker_size = 20;
line_width = 6;
figure('DefaultAxesFontSize',plot_text)
hold on


%% Actual plot data
averaging = 10;

data = importdata(file_name);
data = 10.*data;
average_bandwidth = sum(data,2)/size(data,2);
plot_handle_1 = plot([10,30,100,300,1000],average_bandwidth(16:20), '-o',...
                    'Color', color_brown,...
                    'LineWidth',line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_brown,...
                    'MarkerFaceColor',color_brown);
hold on

plot_handle_2 = plot([10,30,100,300,1000],average_bandwidth(11:15), ...
                    '-^', 'Color', color_red,...
                    'LineWidth',line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_red,...
                    'MarkerFaceColor',color_red);

plot_handle_3 = plot([10,30,100,300,1000],average_bandwidth(6:10),...
                    '-*', 'Color', color_blue,...
                    'LineWidth',line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_blue,...
                    'MarkerFaceColor',color_blue);

plot_handle_4 = plot([10,30,100,300,1000],average_bandwidth(1:5),...
                    '-v', 'Color', color_purple,...
                    'LineWidth',line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_purple,...
                    'MarkerFaceColor',color_purple);


set(groot, 'defaultAxesTickLabelInterpreter','LaTex'); 
set(groot, 'defaultLegendInterpreter','LaTex');
xlabel('Application Bandwidth (in KB/s)','FontSize',plot_text,'Interpreter','LaTex')
ylabel('Latency (in ms)','FontSize',plot_text,'Interpreter','LaTex')
title('Latency vs Application Bandwidth','FontSize',plot_text,'Interpreter','Latex')
set(gca,'xscale','log');
set(gca,'yscale','linear');

grid on
grid minor

% label_1 = '$\ \epsilon = 0$';
% text(bandwidth_usage(1,4),mean_stash(1,4),label_1,...
%     'Interpreter', 'latex', 'FontSize', plot_size);
% 
% label_2 = strcat('$\ \epsilon =\ $ ', num2str(epsilon(epsilon_index)));
% text(bandwidth_usage(epsilon_index,4),mean_stash(epsilon_index,4), ...
%     label_2, 'Interpreter', 'latex', 'FontSize', plot_size);                        
                       

%% Legend %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

legend_handle = legend('$k = 1$', '$k = 5$', ...
                       '$k = 10$', '$k = 20$', 'Location', 'best');
       
set(legend_handle, 'Interpreter', 'latex', 'FontSize', plot_text);
M = findobj(legend_handle,'type','line');
set(M,'linewidth',3) 

               
%% Save graph to file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
set(gcf, 'PaperUnits', 'inches');
x_width = 16;
y_width = 12;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); 
saveas(gcf,[file_path '/EC2Constraint.png']);




%% No idea what is this!
% data4 = importdata('time_taken4.txt');
% average_bandwidth4 = sum(data4,2)/size(data4,2);
% plot(begin:finish,1000.*average_bandwidth4,'-o')
% 
% data16 = importdata('time_taken16.txt');
% average_bandwidth16 = sum(data16,2)/size(data16,2);
% plot(begin:finish,1000.*average_bandwidth16,'-o')