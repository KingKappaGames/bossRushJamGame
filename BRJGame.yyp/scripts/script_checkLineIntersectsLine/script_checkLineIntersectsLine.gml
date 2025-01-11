function script_checkLineIntersectsLine(x1, y1, x2, y2, x3, y3, x4, y4, segment){
	var ua, ub, ud, ux, uy, vx, vy, wx, wy;
	ua = 0;
	ux = x2 - x1;
	uy = y2 - y1;
	vx = x4 - x3;
	vy = y4 - y3;
	wx = x1 - x3;
	wy = y1 - y3;
	ud = vy * ux - vx * uy;
	if (ud != 0) 
	{
		ua = (vx * wy - vy * wx) / ud;
		if (segment) 
		{
		    ub = (ux * wy - uy * wx) / ud;
		    if (ua < 0 || ua > 1 || ub < 0 || ub > 1) ua = 0;
		}
	}
	return ua;
}