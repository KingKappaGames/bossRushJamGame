///@desc This function is specifically for checking even/odd polygon collisions and does not check two lines but instead always uses one horizontal line
function script_checkLineIntersectsFlatline(firstX, firstY, secondX, secondY, thirdX, thirdY) {	
	if(thirdY < max(firstY, secondY) && thirdY > min(firstY, secondY)) { // this bit checks whether the point is vertically in range before checking the horizontal areas (since vertical is the simple part)
		var _slope = (secondX - firstX) / (secondY - firstY);
			
		if(thirdX < firstX + (thirdY - firstY) * _slope) { // this is the range of y over y range turned into x values that would be behind the line to the left 
			return true;
		}
	}
	
	return false; // if no success then default failure
}