function colornames_cube(palette,space)
% Plot COLORNAMES palettes in a color cube (RGB/Lab/LCh/HSV/XYZ). With DataCursor labels.
%
% (c) 2017 Stephen Cobeldick
%
%%% Syntax:
%  colornames(palette,space)
%
% Plot the COLORNAMES palettes in an RGB/Lab/LCh/HSV/XYZ cube. Color names
% can be viewed by clicking on the plotted points using the data cursor.
%
% Two vertical colorbars are displayed on the figure's right hand side,
% showing the colormap in sequence, both in color and converted to grayscale.
%
% See also COLORNAMES CUBEHELIX BREWERMAP RGBPLOT COLORMAP DATACURSORMODE
%
% Note: Requires the function COLORNAMES and its associated MAT file (FEX 48155).
%
%% Input Arguments %%
%
%%% Inputs (all inputs are optional):
%  palette = String, the name of a palette supported by COLORNAMES.
%  space   = String, the color space to plot the palette in, e.g. 'RGB'.
%
% colornames_cube(palette,space)

%% Figure Parameters %%
%
persistent fgh axh lnh axc axg imc img txt pah sph
%
%% Get COLORNAMES Palettes %%
%
[fnm,fun] = colornames();
%
if nargin<1
	idp = 1+rem(round(now*1e7),numel(fnm));
else
	assert(ischar(palette)&&isrow(palette),'First input <palette> must be a 1xN char.')
	idz = strcmpi(palette,fnm);
	assert(any(idz),'Palette ''%s'' is not supported. Call COLORNAMES() to list all palettes.',palette)
	idp = find(idz);
end
%
%% Color Space List %%
%
clm = {... % axes limits
	{[0,1],[0,1],[0,1]},... RGB
	{[0,100],[-150,150],[-150,150]},... Lab
	{[0,100],[0,150],[0,360]},... LCh
	{[0,360],[0,1],[0,1]},... HSV
	{[0,1],[0,1],[0,1]}}; % XYZ
lbl = {... % axes labels
	{'Red','Green','Blue'},... RGB
	{'Lightness','a','b'},...  Lab
	{'Lightness','Chroma','Hue'},... LCh
	{'Hue','Saturation','Value'},... HSV
	{'X','Y','Z'}}; % XYZ
cps = {'RGB','Lab','LCh','HSV','XYZ'}; % colorspace
ord = {'GBR','abL','ChL','SVH','XYZ'}; % plot order
[~,xyz] = cellfun(@ismember,ord,cps,'UniformOutput',false);
%
if nargin<2
	ids = 1+rem(round(now*1e7),numel(cps));
else
	assert(ischar(space)&&isrow(space),'Second input <sort> must be a 1xN char.')
	tmp = strcmpi(space,cps);
	assert(any(tmp),'Second input must be one of:%s\b',sprintf(' %s,',cps{:}))
	ids = find(tmp);
end
%
%% Create a New Figure %%
%
if isempty(fgh) || ~ishghandle(fgh)
	% Create figure and main axes:
	fgh = figure('HandleVisibility','callback', 'IntegerHandle','off',...
		'NumberTitle','off', 'Name',mfilename, 'Color','white', 'Toolbar','figure');
	axh = axes('Parent',fgh, 'NextPlot','replacechildren', 'View',[55,32]);
	grid(axh,'on')
	% Create colorbars:
	axc = axes('Parent',fgh, 'Units','normalized', 'Position',[0.96,0,0.02,1],...
		'Visible','off', 'YLim',[0,1], 'HitTest','off');
	axg = axes('Parent',fgh, 'Units','normalized', 'Position',[0.98,0,0.02,1],...
		'Visible','off', 'YLim',[0,1], 'HitTest','off');
	imc = image('CData',[0.25;0.5;0.75], 'Parent',axc);
	img = image('CData',[0.75;0.5;0.25], 'Parent',axg);
	txt = uicontrol(fgh, 'Units','Pixels', 'Position',[0,0,30,15], 'Style','text');
	uicontrol(fgh, 'Units','Normalized', 'Position',[0.88,0.96,0.08,0.04],...
		 'Style','togglebutton', 'Callback',@cncDemoClBk, 'String','Demo');
	% Create RGB/Lab button and palette menu:
	pah = uicontrol(fgh, 'Units','normalized', 'Position',[0,0.95,0.15,0.05],...
		'Style','popupmenu', 'Callback',@cncScmClBk, 'String',fnm);
	sph = uicontrol(fgh, 'Units','normalized', 'Position',[0,0.90,0.10,0.05],...
		'Style','popupmenu', 'Callback',@cncSpcClBk, 'String',cps);
	% Add DataCursor labels:
	dcm = datacursormode(fgh);
	set(dcm,'UpdateFcn',@(o,e)get(get(e,'Target'),'UserData'));
	datacursormode(fgh,'on')
end
set(pah,'Value',idp);
set(sph,'Value',ids);
%
%% Callback Functions %%
%
	function cncScmClBk(h,~) % Palette Callback
		% Select a new palette.
		idp = get(h,'Value');
		cncMapPlot()
		cncClrSpace()
	end
%
	function cncSpcClBk(h,~) % Color Space Callback
		ids = get(h,'Value');
		cncClrSpace()
	end
%
%% Re/Draw Points in 3D Plot %%
%
	function cncMapPlot()
		% Delete any existing colors:
		delete(lnh(ishghandle(lnh)))
		% Get new colors:
		[clr,rgb] = colornames(fnm{idp});
		N = numel(clr);
		% Update main axes:
		set(axh, 'ColorOrder',rgb, 'NextPlot','replacechildren');
		% Update colorbars:
		set(axc, 'YLim',[0,N]+0.5)
		set(axg, 'YLim',[0,N]+0.5)
		set(imc, 'CData',permute(rgb,[1,3,2]))
		set(img, 'CData',permute(rgb2gray(rgb),[1,3,2]))
		set(txt, 'String',num2str(N))
		% Plot each node:
		idx = xyz{ids};
		map = rgb;
		map(:,:,2) = NaN;
		map = permute(map,[3,1,2]);
		lnh = plot3(map(:,:,idx(1)),map(:,:,idx(2)),map(:,:,idx(3)),...
			'.','MarkerSize',36, 'Parent',axh);
		% Add DataCursor labels:
		arrayfun(@(h,n)set(h,'UserData',n{1}), lnh, clr(:));
	end
%
	function cncClrSpace()
		% Plot the data in the requested color space.
		switch cps{ids}
			case 'RGB'
				map = rgb;
			case 'HSV'
				map = fun.rgb2hsv(rgb);
			case 'XYZ'
				map = fun.rgb2xyz(rgb);
			case 'Lab'
				map = fun.xyz2lab(fun.rgb2xyz(rgb));
			case 'LCh'
				map = fun.lab2lch(fun.xyz2lab(fun.rgb2xyz(rgb)));
			otherwise
				error('Sorry, the colorspace "%s" is not recognized.',cps{ids})
		end
		set(lnh,{'XData','YData','ZData'},num2cell(map(:,xyz{ids})))
		%
		idx = xyz{ids};
		lab = lbl{ids};
		lim = clm{ids};
		xlabel(axh,lab(idx(1)));
		ylabel(axh,lab(idx(2)));
		zlabel(axh,lab(idx(3)));
		set(axh,'XLim',lim{idx(1)},'YLim',lim{idx(2)},'ZLim',lim{idx(3)})
		%
		drawnow()
	end
%
%% Demonstration Function %%
%
	function cncDemoClBk(h,~)
		% Slowly rotate the axes while the toggle button is depressed.
		stp = 2;
		itr = 0;
		while ishghandle(h) && get(h,'Value')
			if itr<=0
				itr = randi([45,360])/stp;
				ang = 360*rand(1);
				dth = stp*sind(ang);
				dph = stp*cosd(ang);
			end
			cncOrbit(axh,dth,dph,'camera')
			itr = itr-1;
 			% Wait a smidgen:
 			pause(0.07)
		end
	end
%
%% Initialize the Figure %%
%
rgb = [];
clr = {};
cncMapPlot()
cncClrSpace()
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%colornames_cube
function cncOrbit(axh,dth,dph,~)
% Rotate camera around the center of the axes. Avoids bug in CAMROTATE.
%
C = get(axh, {'CameraPosition','CameraTarget','CameraUpVector','DataAspectRatio'});
%
vec = (C{2}-C{1})./C{4};
vax = cross(vec, C{3}./C{4});
hax = cross(vax, vec);
%
vec = vec/norm(vec);
vax = vax/norm(vax);
hax = hax/norm(hax);
%
cosa = cosd(dth);
sina = sind(dth);
vera = 1 - cosa;
rotH = [...
	cosa+hax(1)^2*vera,hax(1)*hax(2)*vera-hax(3)*sina,hax(1)*hax(3)*vera+hax(2)*sina;...
	hax(1)*hax(2)*vera+hax(3)*sina,cosa+hax(2)^2*vera,hax(2)*hax(3)*vera-hax(1)*sina;...
	hax(1)*hax(3)*vera-hax(2)*sina,hax(2)*hax(3)*vera+hax(1)*sina,cosa+hax(3)^2*vera]';
%
cosa = cosd(-dph);
sina = sind(-dph);
vera = 1 - cosa;
rotV = [...
	cosa+vax(1)^2*vera,vax(1)*vax(2)*vera-vax(3)*sina,vax(1)*vax(3)*vera+vax(2)*sina;...
	vax(1)*vax(2)*vera+vax(3)*sina,cosa+vax(2)^2*vera,vax(2)*vax(3)*vera-vax(1)*sina;...
	vax(1)*vax(3)*vera-vax(2)*sina,vax(2)*vax(3)*vera+vax(1)*sina,cosa+vax(3)^2*vera]';
%
rotM = rotV*rotH;
%
pos = (-vec*rotM).*C{4} + C{2};
upv = (+hax*rotM).*C{4};
%
set(axh,'CameraPosition',pos, 'CameraUpVector',upv)
%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cncOrbit