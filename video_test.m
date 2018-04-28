%% This Demo intends to show that GRASTA can efficiently seperate the video into foreground / 
% background in realtime.
%
% Author: Jun He
% Email: hejun.zz@gmail.com
% 
% Papers used this demo code:
%[1] Jun He, Laura Balzano, and John C.S. Lui. Online robust subspace tracking from partial information. 
%    Preprint available at http://arxiv.org/pdf/1109.3827v2., 2011.
%
%[2] Jun He, Laura Balzano, and Arthur Szlam. Incremental gradient on the grassmannian for online foreground 
%    and background separation in subsampled video. In IEEE Conference on Computer Vision and Pattern Recognition 
%   (CVPR), June 2012
%

clear all; clc; close all;
grasta_path; % Add search path

%% Video parameters
% The following datasets can be download from 
% http://perception.i2r.a-star.edu.sg/bk_model/bk_index.html
%

% Set your video path and groundtruth path like these
video_path    = './video';

VIDEOPATH = [video_path filesep 'test_compress2/'];

% load the groundtruth frames
frames_vec = 1:499;
video_frame_name = cell(1,length(frames_vec));
for i=1:length(frames_vec)
    video_frame_name{i} = ['test' num2str(frames_vec(i)) '.bmp'];
end


%% Make video -- ReProCS(mod)
batch_size                  = 400; % training size for the initial clean background ReProCSmod by IALM
FPS_ONLY                    = 0;    % if you want to measure the FPS performance, please let FPS_ONLY=1
IALM_MAXITER                = 10;
MAX_FRAME                   = -1;
thresh                      = 0.2;
RESIZE                      = 1; % w = WIDTH/RESIZE, h=HEIGHT/RESIZE as ReProCSmod can not deal with large resolution video.
                                 % Cost too much memory! I have to resize
                                 % the video to low resolution...

fprintf('Seperating the whole video sequence by ReProCS(mod)...\n');
[video_reprocs_fg_R,video_reprocs_bg_R] = bgfg_seperation_ReProCSmod(VIDEOPATH,batch_size, IALM_MAXITER , thresh,FPS_ONLY , video_frame_name,MAX_FRAME,RESIZE, 'R');
%[video_reprocs_fg_G,video_reprocs_bg_G] = bgfg_seperation_ReProCSmod(VIDEOPATH,batch_size, IALM_MAXITER , thresh,FPS_ONLY , video_frame_name,MAX_FRAME,RESIZE, 'G');
%[video_reprocs_fg_B,video_reprocs_bg_B] = bgfg_seperation_ReProCSmod(VIDEOPATH,batch_size, IALM_MAXITER , thresh,FPS_ONLY , video_frame_name,MAX_FRAME,RESIZE, 'B');

fg_color = zeros(225, 225, 3);
fg_color(:,:,1) = reshape(video_reprocs_fg_R(:,90), 225, 225);
fg_color(:,:,2) = reshape(video_reprocs_fg_G(:,90), 225, 225);
fg_color(:,:,3) = reshape(video_reprocs_fg_B(:,90), 225, 225);
bg_color = zeros(225, 225, 3);
bg_color(:,:,1) = reshape(video_reprocs_bg_R(:,90), 225, 225);
bg_color(:,:,2) = reshape(video_reprocs_bg_G(:,90), 225, 225);
bg_color(:,:,3) = reshape(video_reprocs_bg_B(:,90), 225, 225);

figure;
h_fg = subplot(1,2,1);title('Foreground');
h_bg = subplot(1,2,2);title('Background');

axes(h_fg);imshow(uint8(fg_color));
axes(h_bg);imshow(uint8(bg_color));