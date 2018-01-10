
clear all 
clc

color_blue = '[.11,.40,1]';
color_red = '[.86,.07,.23]';
color_brown = '[.8,.46,.13]';
color_purple = '[.60,0,.82]';

file_name = 'time_taken1.txt';
file_path = mfilename('fullpath');
[file_path, ~, ~] = fileparts(file_path);

plot_text = 35;
marker_size = 20;
line_width = 5;
figure('DefaultAxesFontSize',plot_text)
begin = 1;
finish = 20;
averaging = 10;


%% Actual plot data
hold on

data1 = importdata(file_name);
average_bandwidth1 = sum(data1,2)/size(data1,2);
errorbars1 = 1000.*average_bandwidth1(begin:finish)/10;
plot_handle_1 = plot(10.*(begin+1:finish+1),1000.*average_bandwidth1(begin:finish),...
                    '-o', 'Color', color_brown,...
                    'LineWidth',line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_brown,...
                    'MarkerFaceColor',color_brown);
errorbar_handle_1 = errorbar(10.*(begin+1:finish+1),1000.*average_bandwidth1(begin:finish),...
                    errorbars1, '-o', 'Color', color_brown,...
                    'LineWidth',line_width - 2,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_brown,...
                    'MarkerFaceColor',color_brown);


file_name = 'time_taken4.txt';
data4 = importdata(file_name);
average_bandwidth4 = sum(data4,2)/size(data4,2);
errorbars4 = 1000.*average_bandwidth4(begin:finish)/10;
plot_handle_2 = plot(10.*(begin+1:finish+1),1000.*average_bandwidth4(begin:finish), ...
                    '-^', 'Color', color_red,...
                    'LineWidth',line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_red,...
                    'MarkerFaceColor',color_red);
errorbar_handle_2 = errorbar(10.*(begin+1:finish+1),1000.*average_bandwidth4(begin:finish), ...
                    errorbars4, '-^', 'Color', color_red,...
                    'LineWidth',line_width - 2,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_red,...
                    'MarkerFaceColor',color_red);

                

file_name = 'time_taken16.txt';
data16 = importdata(file_name);
average_bandwidth16 = sum(data16,2)/size(data16,2);
errorbars16 = 1000.*average_bandwidth16(begin:finish)/10;
plot_handle_3 = plot(10.*(begin+1:finish+1),1000.*average_bandwidth16(begin:finish), ...
                    '-*', 'Color', color_blue,...
                    'LineWidth',line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_blue,...
                    'MarkerFaceColor',color_blue);
errorbar_handle_3 = errorbar(10.*(begin+1:finish+1),1000.*average_bandwidth16(begin:finish), ...
                    errorbars16, '-*', 'Color', color_blue,...
                    'LineWidth',line_width - 2,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_blue,...
                    'MarkerFaceColor',color_blue);


plot(210,9.9142,'s', 'Color', color_purple, 'MarkerSize', marker_size + 5, ...
                'MarkerFaceColor', color_purple)
plot(210,32.1436,'d', 'Color', color_purple, 'MarkerSize', marker_size + 5, ...
                'MarkerFaceColor', color_purple)
plot(210,106.142,'h', 'Color', color_purple, 'MarkerSize', marker_size + 5, ...
                'MarkerFaceColor', color_purple)

axis([0 250 0 120])
set(groot, 'defaultAxesTickLabelInterpreter','LaTex'); 
set(groot, 'defaultLegendInterpreter','LaTex');
xlabel('Bandwidth (Blocks)','FontSize',plot_text,'Interpreter','LaTex')
ylabel('Latency (in ms)','FontSize',plot_text,'Interpreter','LaTex')
title('Latency vs Bandwidth (in Blocks, $Z=5$)','FontSize',...
    plot_text,'Interpreter','Latex')


grid on
grid minor
                       

%% Legend %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hasbehavior(errorbar_handle_1,'legend',false);
hasbehavior(errorbar_handle_2,'legend',false);
hasbehavior(errorbar_handle_3,'legend',false);

legend_handle = legend('$B = 1KB$', '$B = 4KB$', '$B = 16KB$', ...
                       'Path ORAM $(B = 1KB)$', 'Path ORAM $(B = 4KB)$', ...
                       'Path ORAM $(B = 16KB)$', 'Location', 'best');
       
set(legend_handle, 'Interpreter', 'latex', 'FontSize', plot_text);

               
%% Save graph to file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
set(gcf, 'PaperUnits', 'inches');
x_width = 16;
y_width = 12;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); 
saveas(gcf,[file_path '/EC2highbandwidth.png']);

