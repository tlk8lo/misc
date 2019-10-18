function getbit( n )
{
	return substr( $3, n + 1, 1 );
}

function check_parity( k, n )
{
	p = 0;
	for ( i = k; i < n + 1; i++ )
		p += getbit( i );
	p %= 2;
	#printf( "parity %d\n", p );
	return p;
}


{
	len = $1;
	timestamp = $2;
	frame = $3;
	
	if ( len == 59 )
	{
		year = \
			getbit( 50 ) * 1 +\
			getbit( 51 ) * 2 +\
			getbit( 52 ) * 4 +\
			getbit( 53 ) * 8 +\
			getbit( 54 ) * 10 +\
			getbit( 55 ) * 20 +\
			getbit( 56 ) * 40 +\
			getbit( 57 ) * 80;
			
		month = \
			getbit( 45 ) * 1 +\
			getbit( 46 ) * 2 +\
			getbit( 47 ) * 4 +\
			getbit( 48 ) * 8 +\
			getbit( 49 ) * 10;
			
		day = \
			getbit( 36 ) * 1 +\
			getbit( 37 ) * 2 +\
			getbit( 38 ) * 4 +\
			getbit( 39 ) * 8 +\
			getbit( 40 ) * 10 +\
			getbit( 41 ) * 20;
		
		dayow = \
			getbit( 42 ) * 1 +\
			getbit( 43 ) * 2 +\
			getbit( 44 ) * 4;
			
		hour = \
			getbit( 29 ) * 1 +\
			getbit( 30 ) * 2 +\
			getbit( 31 ) * 4 +\
			getbit( 32 ) * 8 +\
			getbit( 33 ) * 10 +\
			getbit( 34 ) * 20;
	
		minute = \
			getbit( 21 ) * 1 +\
			getbit( 22 ) * 2 +\
			getbit( 23 ) * 4 +\
			getbit( 24 ) * 8 +\
			getbit( 25 ) * 10 +\
			getbit( 26 ) * 20 +\
			getbit( 27 ) * 40;
			
		wintertime = getbit( 18 );
		summertime = getbit( 17 );
		
		minute_parity = check_parity( 21, 28 );
		hour_parity = check_parity( 29, 35 );
		date_parity = check_parity( 36, 58 );
		
		ok = getbit( 0 ) == 0 && !minute_parity && !hour_parity && !date_parity && summertime != wintertime && getbit( 20 ) == 1;
		
		if ( ok ) printf( "%s %s 20%d-%d-%d %02d:%02d SUMMER=%d (%s)\n", $0, ok ? "==>" : "=ERR=>", year, month, day, hour, minute, summertime, strftime( "%Y-%m-%d %H:%M", timestamp ) );
	}
}
