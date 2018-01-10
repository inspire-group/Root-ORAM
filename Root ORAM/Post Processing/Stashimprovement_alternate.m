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
i_range = 1:(logN-1);
size_epsilon = size(epsilon, 2);
size_i = size(i_range,2);
[eps, varI] = meshgrid(epsilon, i_range);

mean_stash = zeros(size_i, size_epsilon);
max_stash = zeros(size_i, size_epsilon);

for i = 1:(logN-1)
    mean_stash(i,:) = data((i-1)*size_epsilon+1:(i-1)*size_epsilon ...
        +size_epsilon,3);
    max_stash(i,:) = data((i-1)*size_epsilon+1:(i-1)*size_epsilon ...
        +size_epsilon,4);
end

stash_improvement = zeros(size_i, size_epsilon);

for i = 1:size_i
    for j = 1:size_epsilon
        stash_improvement(i,j) = mean_stash(i,1)/mean_stash(i,j);
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

line_width = 4;
plot_size = 30;

plot_truncation_eps = 13;

figure()
surf(eps(:, 1:plot_truncation_eps), 2*Z*(logN + 1 - varI(:, 1:plot_truncation_eps)),...
    stash_improvement(:, 1:plot_truncation_eps), 'linewidth', 5)

set(groot, 'defaultAxesTickLabelInterpreter','LaTex'); 
set(groot, 'defaultLegendInterpreter','LaTex');

title(['Stash improvement vs Bandwidth, Security parameters ($k$, $\epsilon$)'],...
    'FontSize',20,'Interpreter','Latex')
ylabel({'Bandwidth (Blocks)'},'FontSize',plot_size,...
    'Interpreter','LaTex', 'Rotation', -20, 'Units', 'normalized', ...
    'Position', [0.28, -0.03]);
xlabel({'Security Parameter $(\epsilon)$'},'FontSize',plot_size,...
    'Interpreter','LaTex', 'Rotation', 14, 'Units', 'normalized', ...
    'Position', [.8, -.005]);
zlabel({'Stash improvement (logscale)'},'FontSize',plot_size,'Interpreter','LaTex')
% set(gca, 'ZTickFormat','%gx')

set(gca,'Fontsize',plot_size+10)
set(gca,'TitleFontWeight','bold')
%set(gca,'FontWeight','bold')
set(gca,'LineWidth',line_width)
set(gca,'FontName','Verdana')
set(gca,'ZScale','log');
axis([0 14 0 130 1 100]);
% set(gca, 'XTick', 0:2:12)
set(gca, 'XTick', 0:2:14)
% set(gca, 'ZTick', [1 10 100])
% axis_handle.ZAxis.Exponent = 2;
view(-40, 20); 
cb_handle = colorbar;
set(cb_handle,'position',[.91 .3 .03 .5]) % [x_pos, y_pos, x_width, y_width]
set(cb_handle, 'FontWeight', 'normal');
set(cb_handle, 'TickLabelInterpreter', 'latex');
set(cb_handle,'LineWidth',line_width)
cb_handle.Label.String = 'Color Bar';
cb_handle.Label.Interpreter = 'latex';
% shading interp

set(gcf, 'PaperUnits', 'inches');
x_width = 20;
y_width = 16;
set(gcf, 'PaperPosition', [0 0 x_width y_width]); 
saveas(gcf,[file_path '/Results/stashimprovement_alternate.png']);



