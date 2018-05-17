%MDL_UR5  Create kinematic model of Universal Robots UR5 robot 
%
% MDL_UR5 is a script that creates the workspace variable R which
% describes the kinematic characteristics of a Universal Robots UR5 robot
% using standard DH conventions.
%
% Also defines the workspace vector:
%   q_up   upwards pointing position.
%
% Notes::
% - SI units of metres are used.
%
% Author::
%  Mikkel Rath Pedersen
%  Aalborg University Copenhagen, Copenhagen, Denmark
%  mikkelrath@gmail.com
%
% See also SerialLink, mdl_UR10, mdl_UR3.

% MODEL: Universal Robots, UR5, 6DOF, standard_DH


%            theta    d       a        alpha  type
clear L
L(1) = Link([0        0.08915 0        pi/2   0  ]);
L(2) = Link([0        0       -0.425   0      0  ]);
L(3) = Link([0        0       -0.39225 0      0  ]);
L(4) = Link([0        0.10915 0        pi/2   0  ]);
L(5) = Link([0        0.09465 0        -pi/2  0  ]);
L(6) = Link([0        0.0823  0        0      0  ]);
% joint limits (+/- 360 deg all joints)
q_lim = [-2*pi 2*pi;-2*pi 2*pi;-2*pi 2*pi;-2*pi 2*pi;-2*pi 2*pi;-2*pi 2*pi];
% pose with the arm pointing straight up
q_up =[0   -pi/2   0   -pi/2   0   0];
ur5=SerialLink(L, 'name', 'UR5','manufacturer','Universal Robots','qlim',q_lim);
clear q_lim L 
%##########################################################