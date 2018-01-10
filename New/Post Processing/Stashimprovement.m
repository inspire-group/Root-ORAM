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
file_name = 'path_15_4';
file_path = mfilename('fullpath');
[file_path, ~, ~] = fileparts(file_path);

data = importdata(file_name);
data = sortrows(data);



%% Another plot

logN = 15;
Z = 4;
epsilon = [0,1,2,3,4,5,6,7,8,9,10,12,14,16,18,20];
% epsilon = [0];   % For Absolute Stash values graph
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

% write_data = zeros(size_epsilon*size_i, 6);
% write_data(:,1) = data(:,1);
% write_data(:,2) = data(:,2);
% write_data(:,3) = data(:,3);
% write_data(:,4) = data(:,4);
% write_data(:,5) = reshape(stash_improvement, size_epsilon*size_i, 1);
% write_data(:,6) = reshape(outsourcing_ratio, size_epsilon*size_i, 1);


%% Stash Reduction

% line_width = 4;
% plot_size = 30;
% 
% plot_truncation_eps = 13;
% 
% figure()
% surf(2*Z*(logN - varI(1:plot_truncation_eps, :)), eps(1:plot_truncation_eps, :),...
%     stash_improvement(1:plot_truncation_eps, :), 'linewidth', 5)
% 
% set(groot, 'defaultAxesTickLabelInterpreter','LaTex'); 
% set(groot, 'defaultLegendInterpreter','LaTex');
% 
% title(['Stash improvement vs Bandwidth, Security parameters ($k$, $\epsilon$)'],...
%     'FontSize',20,'Interpreter','Latex')
% xlabel({'Bandwidth (Blocks)'},'FontSize',plot_size,...
%     'Interpreter','LaTex', 'Rotation', 8, 'Units', 'normalized', ...
%     'Position', [.6, -.05]);
% ylabel({'Security Parameter $(\epsilon)$'},'FontSize',plot_size,...
%     'Interpreter','LaTex', 'Rotation', -26, 'Units', 'normalized', ...
%     'Position', [0.11, 0.06 ]);
% zlabel({'Stash improvement (logscale)'},'FontSize',plot_size,'Interpreter','LaTex')
% % set(gca, 'ZTickFormat','%gx')
% 
% set(gca,'Fontsize',plot_size+10)
% set(gca,'TitleFontWeight','bold')
% %set(gca,'FontWeight','bold')
% set(gca,'LineWidth',line_width)
% set(gca,'FontName','Verdana')
% set(gca,'ZScale','log');
% axis([0 120 0 14 1 100]);
% % set(gca, 'XTick', 0:2:12)
% set(gca, 'YTick', 0:2:14)
% % set(gca, 'ZTick', [1 10 100])
% % axis_handle.ZAxis.Exponent = 2;
% view(-30, 20); 
% cb_handle = colorbar;
% set(cb_handle,'position',[.91 .3 .03 .5]) % [x_pos, y_pos, x_width, y_width]
% set(cb_handle, 'FontWeight', 'normal');
% set(cb_handle, 'TickLabelInterpreter', 'latex');
% set(cb_handle,'LineWidth',line_width)
% cb_handle.Label.String = 'Color Bar';
% cb_handle.Label.Interpreter = 'latex';
% % shading interp
% 
% set(gcf, 'PaperUnits', 'inches');
% x_width = 20;
% y_width = 16;
% set(gcf, 'PaperPosition', [0 0 x_width y_width]); 
% saveas(gcf,[file_path '/Results/stashimprovement.png']);


%% Isloate the curve for 2 (explicit trade-off)

line_width = 2;
plot_line_width = 5;
plot_size = 45;
marker_size = 35;
which_data_point = 2;
until_which_point = 10;

figure()
plot_handle_1 = plot(eps(1:until_which_point,which_data_point), ...
                     stash_improvement(1:until_which_point,which_data_point),...
                     '-*', 'Color', color_blue,...
                    'LineWidth',plot_line_width,...
                    'MarkerSize',marker_size,...
                    'MarkerEdgeColor',color_blue,...
                    'MarkerFaceColor',color_blue);
                                
set(groot, 'defaultAxesTickLabelInterpreter','LaTex'); 
set(groot, 'defaultLegendInterpreter','LaTex');
                
title(['Stash improvement vs Security parameter'],...
        'FontSize',plot_size,'Interpreter','Latex');
xlabel({'Security parameter $\epsilon$'},'FontSize',plot_size,'Interpreter','LaTex');
ylabel({'Stash improvement'},'FontSize',plot_size,'Interpreter','LaTex');
grid on
grid minor
set(gca,'Fontsize',plot_size)
set(gca,'TitleFontWeight','bold')
set(gca,'LineWidth',line_width)
set(gca,'FontName','Verdana')
set(gca,'XMinorTick','on','YMinorTick','on')
%set(gca,'YScale','log');

legend1 = 'Root ORAM (L, k, Z) = (15, 1, 4)';
legend_handle = legend(legend1);
set(legend_handle, 'Interpreter', 'latex', 'FontSize', plot_size, ...
    'Location', 'best');


% temp1 = strcat('Root ORAM ($L =\ $', num2str(logN));
% temp2 = strcat(', Bandwidth = ', num2str(2*Z*(logN - which_data_point)));
% temp2 = strcat(temp2, ' Blocks)');
% legend_handle = legend(strcat(temp1, temp2));
% set(legend_handle, 'Interpreter', 'latex', 'FontSize', plot_size, ...
%     'Location', 'best');

plot_size = plot_size - 2;

which_point = 2;
label_1 = '$1.16$x';
text(eps(which_point) - 0.6 ,stash_improvement(which_point, which_data_point) + 0.6,...
    label_1, 'Interpreter', 'latex', 'FontSize', plot_size);

which_point = 3;
label_1 = '$1.4$x';
text(eps(which_point) - 0.4 ,stash_improvement(which_point, which_data_point) + 0.7,...
    label_1, 'Interpreter', 'latex', 'FontSize', plot_size);

which_point = 5;
label_1 = '$2.2$x';
text(eps(which_point) - 0.6 ,stash_improvement(which_point, which_data_point) + 0.7,...
    label_1, 'Interpreter', 'latex', 'FontSize', plot_size);

which_point = 7;
label_2 = '$4.6$x';
text(eps(which_point) - 0.6,stash_improvement(which_point, which_data_point) + 0.7,...
    label_2, 'Interpreter', 'latex', 'FontSize', plot_size);                        

plot_size = plot_size + 2;

set(gcf, 'PaperUnits', 'inches');
x_width = 20;
y_width = 16;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); 
saveas(gcf,[file_path '/Results/tradeoff.png']);


%% Stash Reduction Alternate Angle

% line_width = 4;
% plot_size = 30;
% 
% plot_truncation_eps = 13;
% 
% figure()
% surf(2*Z*(logN - varI(1:plot_truncation_eps, :)), eps(1:plot_truncation_eps, :),...
%     stash_improvement(1:plot_truncation_eps, :), 'linewidth', 5)
% 
% set(groot, 'defaultAxesTickLabelInterpreter','LaTex'); 
% set(groot, 'defaultLegendInterpreter','LaTex');
% 
% title(['Stash improvement vs Bandwidth, Security parameters ($k$, $\epsilon$)'],...
%     'FontSize',20,'Interpreter','Latex')
% xlabel({'Bandwidth (Blocks)'},'FontSize',plot_size,...
%     'Interpreter','LaTex', 'Rotation', 20, 'Units', 'normalized', ...
%     'Position', [.7, -.04]);
% ylabel({'Security Parameter $(\epsilon)$'},'FontSize',plot_size,...
%     'Interpreter','LaTex', 'Rotation', -14, 'Units', 'normalized', ...
%     'Position', [0.2, -0.01]);
% zlabel({'Stash improvement (logscale)'},'FontSize',plot_size,'Interpreter','LaTex')
% % set(gca, 'ZTickFormat','%gx')
% 
% set(gca,'Fontsize',plot_size+10)
% set(gca,'TitleFontWeight','bold')
% %set(gca,'FontWeight','bold')
% set(gca,'LineWidth',line_width)
% set(gca,'FontName','Verdana')
% set(gca,'ZScale','log');
% axis([0 120 0 14 1 100]);
% % set(gca, 'XTick', 0:2:12)
% set(gca, 'YTick', 0:2:14)
% % set(gca, 'ZTick', [1 10 100])
% % axis_handle.ZAxis.Exponent = 2;
% view(-50, 20); 
% cb_handle = colorbar;
% set(cb_handle,'position',[.91 .3 .03 .5]) % [x_pos, y_pos, x_width, y_width]
% set(cb_handle, 'FontWeight', 'normal');
% set(cb_handle, 'TickLabelInterpreter', 'latex');
% set(cb_handle,'LineWidth',line_width)
% cb_handle.Label.String = 'Color Bar';
% cb_handle.Label.Interpreter = 'latex';
% % shading interp
% 
% set(gcf, 'PaperUnits', 'inches');
% x_width = 20;
% y_width = 16;
% set(gcf, 'PaperPosition', [0 0 x_width y_width]); 
% saveas(gcf,[file_path '/Results/stashimprovement_angle.png']);