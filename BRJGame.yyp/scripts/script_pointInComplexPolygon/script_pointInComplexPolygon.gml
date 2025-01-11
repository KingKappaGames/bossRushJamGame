function script_pointInComplexPolygon(checkX, checkY, polygonVertexArray){
	var _polygonPoints = array_length(polygonVertexArray);
	
	var _intersections = 0; // if this ends up odd then you're inside because you had to clear a wall to escape, if it's even, then your out, could mean 0 or you could go through the shape and then again meaning entering and leaving an area which would still mean outside for the origin point.
	
	for(var _i = 0; _i < _polygonPoints - 1; _i++) { // fence post loop?? Repeats all pairs up to end then does the last looping check back to 0 below.
		if(script_checkLineIntersectsFlatline(polygonVertexArray[_i][0], polygonVertexArray[_i][1], polygonVertexArray[_i + 1][0], polygonVertexArray[_i + 1][1], checkX, checkY)) {
			_intersections++;
		}
	}
	
	if(script_checkLineIntersectsFlatline(polygonVertexArray[_polygonPoints - 1][0], polygonVertexArray[_polygonPoints - 1][1], polygonVertexArray[0][0], polygonVertexArray[0][1], checkX, checkY)) {
		_intersections++;
	}
	
	if(_intersections % 2 == 0) {
		return false;
	} else {
		return true;
	}
}