#!perl -T

use Test::More tests => 3;

BEGIN {
	use_ok( 'WebService::Telnic' );
	use_ok( 'WebService::Telnic::Base' );
	use_ok( 'WebService::Telnic::Client' );
}

diag( "Testing WebService::Telnic $WebService::Telnic::VERSION, Perl $], $^X" );
