///@desc This function just does a square root but retains the sign (negatives stay negative and don't crash! arg!)
function abssqrt(num) {
	var _sign = sign(num);
	
	return _sign * sqrt(abs(num));
}