%% BehaviorDEPOT Pose-Estimation Animation and HeatMap

% Code Written By: Farhan Augustine
% This Script is designed to be used with BehaviorDEPOT V_1.51
% This script has two parts; part 1 allows you to visualize smoothed data
% from Tracking.mat (single body part). Part 2, allows you to visualize smoothed data of
% multiple bodyparts. Part 3, allows you to visualize tracking data using Heatmap. 
% Feel free to change this script as you like. 

% The script assumes that your Matlab script is executing from
% your working director containing Tracking.mat and Behavior.mat 


%% Part 1: Animating Mouse's Body Part Movements (Single Body Part)
load('C:\Users\Farhan\Documents\BehaviorDEPOT (Part 2)\demo1_video.avi_analyzed\Tracking.mat'); % Replace with your Tracking File Path
MidBack_tracking = Tracking.Smooth.Head; % Replace 'your_variable' with the actual variable name

% Extract x and y from the nose_tracking data
x = MidBack_tracking(1, :);
y = MidBack_tracking(2, :);

% Create a time vector based on the frame number
frame_number = 1:length(x);

% Create a figure for the animation
figure;
h = plot(x(1), y(1), 'bo-', 'MarkerSize', 4, 'MarkerFaceColor', 'b');
xlabel('X Variable');
ylabel('Y Variable');
title('Animation of X and Y Variables with Trail');
grid on;
xlim([min(x)-10, max(x)+10]);
ylim([min(y)-10, max(y)+10]);

% Animate the data with trail
for k = 1:length(frame_number)
    set(h, 'XData', x(1:k), 'YData', y(1:k));
    drawnow;
    pause(0.1); % Adjust the pause duration for animation speed
end


%% Part 2: Tracking and Animating Tracking Data for Multiple Body Parts.
load('C:\Users\Farhan\Documents\BehaviorDEPOT (Part 2)\demo1_video.avi_analyzed\Tracking.mat'); % Replace with your Tracking File Path
MidBack_tracking = Tracking.Smooth.Nose; % Replace 'your_variable' with the actual variable name
head_tracking = Tracking.Smooth.Head; % Replace 'your_variable' with the actual variable name
midback_tracking = Tracking.Smooth.MidBack; % Replace 'your_variable' with the actual variable name

% Extract x and y from the nose_tracking data
x1 = MidBack_tracking(1, :);
y1 = MidBack_tracking(2, :);

% Extract x and y from the variable2 data
x2 = head_tracking(1, :);
y2 = head_tracking(2, :);

% Extract x and y from the variable3 data
x3 = midback_tracking(1, :);
y3 = midback_tracking(2, :);

% Create a time vector based on the frame number
frame_number = 1:length(x1);

% Create a figure for the animation
figure;
h1 = plot(x1(1), y1(1), 'bo-', 'MarkerSize', 4, 'MarkerFaceColor', 'b'); hold on;
h2 = plot(x2(1), y2(1), 'ro-', 'MarkerSize', 4, 'MarkerFaceColor', 'r');
h3 = plot(x3(1), y3(1), 'go-', 'MarkerSize', 4, 'MarkerFaceColor', 'g');
xlabel('X Variable');
ylabel('Y Variable');
title('Animation of Multiple Variables with Different Colors');
grid on;
xlim([min([x1, x2, x3])-10, max([x1, x2, x3])+10]);
ylim([min([y1, y2, y3])-10, max([y1, y2, y3])+10]);

% Animate the data with trail
for k = 1:length(frame_number)
    set(h1, 'XData', x1(1:k), 'YData', y1(1:k));
    set(h2, 'XData', x2(1:k), 'YData', y2(1:k));
    set(h3, 'XData', x3(1:k), 'YData', y3(1:k));
    drawnow;
    pause(0.01); % Adjust the pause duration for animation speed
end

%% Part 3: Heat Map
load('C:\Users\Farhan\Documents\BehaviorDEPOT (Part 2)\demo1_video.avi_analyzed\Tracking.mat'); % Replace with your Tracking File Path
MidBack_tracking = Tracking.Smooth.MidBack; % Replace with the actual variable name

% Extract x and y from the nose_tracking data
x = MidBack_tracking(1, :);
y = MidBack_tracking(2, :);

% Create a 2D histogram (heatmap) of the tracking data
num_bins = 50; % Number of bins for the histogram
heatmap_data = hist3([x', y'], [num_bins, num_bins]);

% Display the heatmap
figure;
imagesc(heatmap_data);
colorbar;
xlabel('X Bins');
ylabel('Y Bins');
title('Heatmap of Nose');
axis xy; % Ensure the y-axis is oriented correctly
