% SiStER_update_topography_markers

% advect the marker chain that keeps track of topography 
% in the current flow field
[topo_x,topo_y] = SiStER_advect_markers(x,y,topo_x,topo_y,dx,dy,dt_m,vx,vy);

% locate the interface between sticky layer and left / right edge
if isempty(find(topo_x<0,1))==1
    topoL=topo_y(1);
else
    topoL=interp1(topo_x,topo_y,0);
end

if isempty(find(topo_x>xsize,1))==1
    topoR=topo_y(end);
else
    topoR=interp1(topo_x,topo_y,xsize);
end


% eliminate topography markers that left domain, keep the first one out on both sides
Iin=find(topo_x<xsize & topo_x>0);
topo_x=topo_x(Iin);
topo_y=topo_y(Iin);
topo_x=[0 topo_x xsize];
topo_y=[topoL topo_y topoR];


% if there has been too much stretching, regrid the surface topography
if max(diff(topo_x))>5*topo_marker_spacing
    % surface regridding happens if somewhere 2 topo markers have been
    % stretched apart by more than 5 times the inital mean marker spacing
    topo_xREGRID=linspace(0,xsize,Ntopo);
    topo_yREGRID=interp1(topo_x,topo_y,topo_xREGRID(2:end-1));
    topo_yREGRID=[topoL topo_yREGRID topoR];
    topo_x=topo_xREGRID;
    topo_y=topo_yREGRID;
    disp('**REGRIDDING TOPOGRAPHY MARKERS**')
end
