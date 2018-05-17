% Create a bag file object with the file name
%bag = rosbag('~/bagfiles/mrc_hw5_data/joy.bag')
bag = rosbag('~/bagfiles/mrc_hw5_data/waypoint_joy.bag')

% Display a list of the topics and message types in the bag file
bag.AvailableTopics
   
% Since the messages on topic /odom are of type Odometry,
% let's see some of the attributes of the Odometry
% This helps determine the syntax for extracting data
msg_odom = rosmessage('nav_msgs/Odometry')
showdetails(msg_odom)
   
% Get just the topic we are interested in
bagselect = select(bag,'Topic','/odom');
   
% Create a time series object based on the fields of the turtlesim/Pose
% message we are interested in
ts = timeseries(bagselect,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Twist.Twist.Linear.X','Twist.Twist.Angular.Z',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');
% The time vector in the timeseries (ts.Time) is "Unix Time"
% which is a bit cumbersome.  Create a time vector that is relative
% to the start of the log file
tt = ts.Time-ts.Time(1);
% Plot the X position vs time
% figure(1);
% clf();
% plot(tt,ts.Data(:,1))
% xlabel('Time [s]')
% ylabel('X [m]')

%% Plots
% Plot the X position vs Y position
figure(1)
plot(ts.data(:,1), ts.data(:,2))
title('Fiveguys Position over Time','fontsize',20)
xlabel('X [m]','fontsize',20)
ylabel('Y [m]','fontsize',20)
%saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/joy_odom_xy.png') 
saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/waypoint_odom_xy.png') 
% 
% Plot of the heading angle (yaw) [deg] vs time
figure(2)
plot(ts.data(:,8),tt)
title('Fiveguys Heading vs Time','fontsize',20)
xlabel('Time [s]','fontsize',20)
ylabel('Yaw [deg]','fontsize',20)
%saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/joy_odom_yaw.png') 
saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/waypoint_odom_yaw.png')
% 
% Plot of the forward velocity of your robot vs time
figure(3)
plot(tt, ts.data(:,3))
title('Fiveguys Heading vs Time','fontsize',20)
xlabel('Time [s]','fontsize',20)
ylabel('Forward Velocity [m/s]','fontsize',20)
%saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/joy_odom_u.png') 
saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/waypoint_odom_u.png') 
%
% Quiver plot showing the location, yaw and speed of the robot
figure(4)
x = ts.data(:,1);
y = ts.data(:,2);
u = ts.data(:,3).*cos(ts.data(:,8));
v = ts.data(:,3).*sin(ts.data(:,8));
ii = 1:10:length(ts.data(:,1));
quiver(x(ii),y(ii),u(ii),v(ii))
title('Fiveguys Pointing Direction','fontsize',20)
xlabel('X [m]','fontsize',20)
ylabel('Y [m]','fontsize',20)
%saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/joy_odom_quiver.png') 
saveas(gcf,'~/catkin_ws/src/mrc_hw5/images/waypoint_odom_quiver.png') 