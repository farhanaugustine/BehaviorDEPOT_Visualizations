%% BehaviorDEPOT Bout and Pose-Estimation Visualization.

% Code Written By: Farhan Augustine
% This Script is designed to be used with BehaviorDEPOT V_1.51
% This script has two parts; part 1 allows you to visualize smoothed data
% from Tracking.mat. Part 2, allows you to visualize smoothed data of
% bodyparts and visalize behavior bouts. Feel free to change this script as
% you like. 

% The script assumes that your Matlab script is executing from
% your working director containing Tracking.mat and Behavior.mat 



%% Part 1: Video output with Body part pose-estimation Tracking layerd on-top for visualization

% Read the video
videoFile = 'demo1_video.avi';
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
        
        % Overlay left hand coordinates
        frame = insertShape(frame, 'FilledCircle', [NoseX(frameIdx), NoseY(frameIdx), 5], 'Color', 'blue', 'Opacity', 1);
        
        % Overlay right hand coordinates
        frame = insertShape(frame, 'FilledCircle', [TailBaseX(frameIdx), TailBaseY(frameIdx), 5], 'Color', 'green', 'Opacity', 1);
    end

    % Write the frame to the output video
    writeVideo(outputVideo, frame);
    frameIdx = frameIdx + 1;
end
close(outputVideo);




%% Part 2: Video output with behavior output layered on-top


% Read the video
videoFile = 'demo1_video.avi';
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
