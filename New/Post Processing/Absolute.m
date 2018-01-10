clear all 
clc

color_blue = '[.11,.40,1]';
color_red = '[.86,.07,.23]';
color_brown = '[.8,.46,.13]';
color_purple = '[.60,0,.82]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    1       2        3          4    
% k_value epsilon mean_stash max_stash
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file_name = 'path_20_5';
file_path = mfilename('fullpath');
[file_path, ~, ~] = fileparts(file_path);

data = importdata(file_name);
data = sortrows(data);



%% Another plot

logN = 20;
Z = 5;
epsilon = [0];   
i_range = 1:(logN-1);
size_epsilon = size(epsilon, 2);
size_i = size(i_range,2);
[varI, eps] = meshgrid(i_range, epsilon);

mean_stash = zeros(size_epsilon, size_i);
max_stash = zeros(size_epsilon, size_i);

for i = 1:(logN-1)
    mean_stash(:,i) = data((i-1)*size_epsilon+1:(i-1)*size_epsilon ...
        +size_epsilon,3);
    max_stash(:,i) = data((i-1)*size_epsilon+1:(i-1)*size_epsilon ...
        +size_epsilon,4);
end

stash_improvement = zeros(size_epsilon, size_i);
outsourcing_ratio = 2^logN ./ mean_stash;

for i = 1:size_i
    for j = 1:size_epsilon
        stash_improvement(j,i) = mean_stash(1,i)/mean_stash(j,i);
    end
end



%% Absolute Stash Values Graph

% line_width = 2;
% plot_line_width = 5;
% plot_size = 40;
% marker_size = 20;
% epsilon_index = 1;
% 
% figure()
% plot_handle_1 = plot(2*Z*(logN - varI(1:epsilon_index, :)), ...
%                     mean_stash(1:epsilon_index, :),...
%                     '-o', 'Color', color_blue,...
%                     'LineWidth',plot_line_width,...
%                     'MarkerSize',marker_size,...
%                     'MarkerEdgeColor',color_blue,...
%                     'MarkerFaceColor',color_blue);
%                                 
% set(groot, 'defaultAxesTickLabelInterpreter','LaTex'); 
% set(groot, 'defaultLegendInterpreter','LaTex');
%                 
% title(['Mean Stash Usage vs Bandwidth'],...
%         'FontSize',plot_size,'Interpreter','Latex');
% xlabel({'Bandwidth (KB)'},'FontSize',plot_size,'Interpreter','LaTex');
% ylabel({'Stash Usage (logscale)'},'FontSize',plot_size,'Interpreter','LaTex');
% grid on
% grid minor
% set(gca,'Fontsize',plot_size)
% set(gca,'TitleFontWeight','bold')
% set(gca,'LineWidth',line_width)
% set(gca,'FontName','Verdana')
% set(gca,'XMinorTick','on','YMinorTick','on')
% set(gca,'YScale','log');
% 
% bandwidth_use = (0:30:150);
% set(gca,'XTick',bandwidth_use)
% bandwidth_labels = {'0';'30';'60';'90';'120';'150'};
% set(gca,'XTickLabel',bandwidth_labels)
% 
% stash_use = 10.^(-2:1:4);
% set(gca,'YTick',stash_use)
% stash_labels = {'10B';'100B';'1KB';'10KB';'100KB';'1MB';'10MB'};
% set(gca,'YTickLabel',stash_labels)
% 
% 
% temp = strcat('Root ORAM ($\epsilon =\ $', num2str(eps(epsilon_index,1)));
% temp = strcat(temp, ', 1KB Block Size)');
% legend_handle = legend(temp);
% set(legend_handle, 'Interpreter', 'latex', 'FontSize', plot_size, ...
%     'Location', 'best');
%                        
% 
% set(gcf, 'PaperUnits', 'inches');
% x_width = 20;
% y_width = 16;
% set(gcf, 'PaperPosition', [0 0 x_width y_width]); 
% saveas(gcf,[file_path '/Results/fig22.png']);


%% Absolute mean and max stash values

line_width = 2;
plot_line_width = 5;
plot_size = 40;
marker_size = 20;
epsilon_index = 1;
failure_probability = 2^(-80);

R = ceil(log(14/failure_probability)/log(1.6666));

figure()
plot_handle_1 = plot(2*Z*(logN - varI(1:epsilon_index, :)), ...
                    mean_stash(1:epsilon_index, :),...
                    '-o', 'Color', color_blue,...
                    'LineWidth',plot_line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_blue,...
                    'MarkerFaceColor',color_blue);
hold on          
plot_handle_2 = plot(2*Z*(logN - varI(1:epsilon_index, :)), ...
                    max_stash(1:epsilon_index, :),...
                    '-^', 'Color', color_red,...
                    'LineWidth',plot_line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_red,...
                    'MarkerFaceColor',color_red);
                                
plot_handle_3 = plot(2*Z*(logN - varI(1:epsilon_index, :)), ...
                    R + Z.*2.^varI(1:epsilon_index, :),...
                    '--', 'Color', color_brown,...
                    'LineWidth',plot_line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_brown,...
                    'MarkerFaceColor',color_brown);
                
set(groot, 'defaultAxesTickLabelInterpreter','LaTex'); 
set(groot, 'defaultLegendInterpreter','LaTex');
                
title([{'$\ $Stash Usage vs Bandwidth','($\epsilon = 0$, 1KB Blocks, L = 20)'}],...
        'FontSize',plot_size,'Interpreter','Latex');
xlabel({'Bandwidth (KB)'},'FontSize',plot_size,'Interpreter','LaTex');
ylabel({'Stash Usage (logscale)'},'FontSize',plot_size,'Interpreter','LaTex');
grid on
grid minor
set(gca,'Fontsize',plot_size)
set(gca,'TitleFontWeight','bold')
set(gca,'LineWidth',line_width)
set(gca,'FontName','Verdana')
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'YScale','log');

axis([0 180 .001 1000000]);

bandwidth_use = (0:40:160);
set(gca,'XTick',bandwidth_use)
bandwidth_labels = {'0';'40';'80';'120';'160'};
set(gca,'XTickLabel',bandwidth_labels)

stash_use = 10.^(-3:1:6);
set(gca,'YTick',stash_use)
stash_labels = {'1B';'10B';'100B';'1KB';'10KB';'100KB';'1MB';'10MB';'100MB';'1GB'};
set(gca,'YTickLabel',stash_labels)

legend_handle = legend('Mean Stash Usage', 'Max Stash Usage', 'Theoretical Bound');
set(legend_handle, 'Interpreter', 'latex', 'FontSize', plot_size, ...
    'Location', 'best');
                       

set(gcf, 'PaperUnits', 'inches');
x_width = 20;
y_width = 16;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); 
saveas(gcf,[file_path '/Results/absolute.png']);
