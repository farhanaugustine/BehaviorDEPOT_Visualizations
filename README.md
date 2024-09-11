# BehaviorDEPOT_Visualizations
This Repo contains Matlab scripts to aid in visualizing data output from BehaviorDEPOT.

BehaviorDEPOT Bout and Pose-Estimation Visualization
Overview
This script is designed to be used with BehaviorDEPOT V_1.51. It has two main parts:

Visualization of smoothed data from Tracking.mat.
Visualization of smoothed data of body parts and behavior bouts.
Feel free to modify this script as needed. The script assumes that your MATLAB script is executing from your working directory containing Tracking.mat and Behavior.mat.

# Visualizing Body Parts with the Behaviors in a single video: 
## Part 1: Video Output with Body Part Pose-Estimation Tracking Layered On-Top for Visualization 
### Description.
This part of the script reads a video file and overlays pose estimation data (head, nose, and tail base coordinates) on each frame. The output is saved as a new video file (*.avi).

Code:
```
% Read the video
videoFile = 'demo1_video.avi'; # Path to your own video
videoReader = VideoReader(videoFile);

% Load the pose data
load('Tracking.mat'); % Assuming the structure is saved in Tracking.mat
headX = Tracking.Smooth.Head(1, :);
headY = Tracking.Smooth.Head(2, :);
NoseX = Tracking.Smooth.Nose(1, :);
NoseY = Tracking.Smooth.Nose(2, :);
TailBaseX = Tracking.Smooth.Tailbase(1, :);
TailBaseY = Tracking.Smooth.Tailbase(2, :);

% Create a video writer object to save the output video
outputVideo = VideoWriter('output_video.avi');
open(outputVideo);

frameIdx = 1;
while hasFrame(videoReader)
    frame = readFrame(videoReader);

    % Overlay pose estimates on the frame
    if frameIdx <= length(headX)
        % Overlay head coordinates
        frame = insertShape(frame, 'FilledCircle', [headX(frameIdx), headY(frameIdx), 5], 'Color', 'red', 'Opacity', 1);
        
        % Overlay nose coordinates
        frame = insertShape(frame, 'FilledCircle', [NoseX(frameIdx), NoseY(frameIdx), 5], 'Color', 'blue', 'Opacity', 1);
        
        % Overlay tail base coordinates
        frame = insertShape(frame, 'FilledCircle', [TailBaseX(frameIdx), TailBaseY(frameIdx), 5], 'Color', 'green', 'Opacity', 1);
    end

    % Write the frame to the output video
    writeVideo(outputVideo, frame);
    frameIdx = frameIdx + 1;
end
close(outputVideo);
```
### Figure 1: Example Frame with Smoothed Trackers for the Nose, Head, and Tailbase.
![Figure 1](https://github.com/user-attachments/assets/35137cfa-51dc-4f20-bc7d-4bbb767b172b)

# Part 2: Video Output with Behavior Output Layered On-Top
### Description
This part of the script reads a video file and overlays both pose estimation data and behavior bouts (e.g., freezing behavior) on each frame. The output is saved as a new video file.

Code:
```
% Read the video
videoFile = 'demo1_video.avi'; # Path to your own video
videoReader = VideoReader(videoFile);

% Load the pose data
load('Tracking.mat'); % Assuming the structure is saved in Tracking.mat within your working directory. If not, please add the folder containing your Tracking.mat file to path.
headX = Tracking.Smooth.Head(1, :);
headY = Tracking.Smooth.Head(2, :);
leftHandX = Tracking.Smooth.Nose(1, :);
leftHandY = Tracking.Smooth.Nose(2, :);
rightHandX = Tracking.Smooth.Tailbase(1, :);
rightHandY = Tracking.Smooth.Tailbase(2, :);

% Load the freezing bouts data
load('Behavior.mat'); % Assuming the structure is saved in Behavior.mat
freezingBouts = Behavior.Freezing.Bouts;

% Create a video writer object to save the output video
outputVideo = VideoWriter('output_video.avi');
open(outputVideo);

frameIdx = 1;
while hasFrame(videoReader)
    frame = readFrame(videoReader);

    % Overlay pose estimates on the frame
    if frameIdx <= length(headX)
        % Overlay head coordinates
        frame = insertShape(frame, 'FilledCircle', [headX(frameIdx), headY(frameIdx), 5], 'Color', 'red', 'Opacity', 1);
        
        % Overlay left hand coordinates
        frame = insertShape(frame, 'FilledCircle', [leftHandX(frameIdx), leftHandY(frameIdx), 5], 'Color', 'blue', 'Opacity', 1);
        
        % Overlay right hand coordinates
        frame = insertShape(frame, 'FilledCircle', [rightHandX(frameIdx), rightHandY(frameIdx), 5], 'Color', 'green', 'Opacity', 1);
    end

    % Check if the current frame is within any freezing bout
    for i = 1:size(freezingBouts, 1)
        if frameIdx >= freezingBouts(i, 1) && frameIdx <= freezingBouts(i, 2)
            % Overlay text indicating freezing behavior
            frame = insertText(frame, [10, 10], 'Freezing', 'FontSize', 18, 'BoxColor', 'yellow', 'BoxOpacity', 0.7, 'TextColor', 'black');
            break;
        end
    end

    % Write the frame to the output video
    writeVideo(outputVideo, frame);
    frameIdx = frameIdx + 1;
end
close(outputVideo);
```
### Figure 2: Smoothed Tracking Data with Behavior Bout in Yellow Text.
|A.|B.|
|---|---|
|![Figure 2](https://github.com/user-attachments/assets/f9797591-c868-401a-b8cd-19629d83ec92)| ![Figure 3](https://github.com/user-attachments/assets/c51a4868-e8b8-48dd-97d8-53e2c407fb71)|


# Visulaizing Body Part Data as an animation
## BehaviorDEPOT Pose-Estimation Animation and HeatMap
### Overview
This script is designed to be used with BehaviorDEPOT V_1.51. It has three main parts:

Visualization of smoothed data from Tracking.mat (single body part).
Visualization of smoothed data of multiple body parts.
Visualization of tracking data using a heatmap.
Please feel free to change this script as you need to. The script assumes that your MATLAB script is executing from your working directory containing Tracking.mat and Behavior.mat.

# Part 1: Animating Mouse’s Body Part Movements (Single Body Part)
Description
This part of the script animates the movements of a single body part (e.g., head) over time.

Code:
```
load('C:\Users\...\Tracking.mat'); % Replace with your Tracking File Path
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
```
### Figure 3: Animation of Single Body Part using Smoothed Data from Tracking.mat
|A.|B.|
|---|---|
|![Figure 4](https://github.com/user-attachments/assets/8f32f2ce-a28e-4f96-ad7e-e667c82fb756)|![Figure 5](https://github.com/user-attachments/assets/477a8fc3-fdab-4503-a969-5ded542e97c4)|


# Part 2: Tracking and Animating Tracking Data for Multiple Body Parts
### Description
This part of the script animates the movements of multiple body parts (e.g., head, nose, midback) over time.

Code:
```
load('C:\Users\...\Tracking.mat'); % Replace with your Tracking File Path
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
```
### Figure 4: Multiple Body Part Tracking from Tracking.mat
|A.|B.|
|---|---|
|![Figure 6](https://github.com/user-attachments/assets/624f950a-4a70-4f9d-aeb5-38124c1aa1c4)|![Figure 7](https://github.com/user-attachments/assets/4cdb8e27-70bd-4589-9351-3b00d871ab41)|


# Part 3: Heat Map
Description
This part of the script creates a heatmap of the tracking data for a specific body part (e.g., midback).

Code:
```
load('C:\Users\...\Tracking.mat'); % Replace with your Tracking File Path
MidBack_tracking = Tracking.Smooth.MidBack; % Replace with the actual variable name

% Extract x and y from the nose_tracking data
x = MidBack_tracking(1, :);
y = MidBack_tracking(2, :);

% Create a 2D histogram (heatmap) of the tracking data
num_bins = 20; % Number of bins for the histogram
heatmap_data = hist3([x', y'], [num_bins, num_bins]);

% Display the heatmap
figure;
imagesc(heatmap_data);
colorbar;
xlabel('X Bins');
ylabel('Y Bins');
title('Heatmap of Nose');
axis xy; % Ensure the y-axis is oriented correctly
```
|Bin Size 10|Bin Size 20| Bin Size 50|
|---|---|---|
|![Figure 8_Bin10](https://github.com/user-attachments/assets/b06c028e-c6fe-4782-8838-33d987326052)|![Figure 8_Bin20](https://github.com/user-attachments/assets/eac566ad-2af2-441b-9af3-47c546b88947)|![Figure 8_Bin50](https://github.com/user-attachments/assets/b44a3dc1-c1fa-4fe4-8042-c209ddf00512)|


# Summary 
This script provides a comprehensive set of tools for visualizing and analyzing animal behavior using pose-estimation and behavior bout data. 
It includes:
Overlaying pose-estimated coordinates on video frames.
Annotating behavior bouts on video frames.
Animating body part movements.
Creating heatmaps of tracking data.
Feel free to modify and extend this script to suit your specific research needs.
