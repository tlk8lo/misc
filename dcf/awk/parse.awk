BEGIN {
	chunk = ""
} 

{
	timestamp = $1
	duration = $3
	state = $4
	
	low_err = 0;
	hi_err = 0;
	bit = 0;
	
	if ( state == 1 ) # L duration
	{
		if ( duration >= 1100 || duration <= 700 ) low_err = 1;
		else low_err = 0;
	}
	
	if ( state == 0 ) # H duration
	{
		if ( duration >= 40 && duration <= 130 ) bit = 0;
		else if ( duration >= 140 && duration <= 250 ) bit = 1;
		else hi_err = 1;
	}
	
	if ( hi_err || low_err )
	{
		if ( length( chunk ) >= 50 ) printf( "%d %s %s\n", length( chunk ) , timestamp, chunk );
		chunk = "";
	}
	else if ( state == 0 ) # Only append if last state was H
	{
		chunk = sprintf( "%s%d", chunk, bit );
	}

}
