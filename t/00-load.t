#!perl -T

use Test::More tests => 7;

BEGIN {
	use_ok( 'WebService::Telnic' );
	use_ok( 'WebService::Telnic::Base' );
	use_ok( 'WebService::Telnic::Client' );
	use_ok( 'WebService::Telnic::Client::Record' );
	use_ok( 'WebService::Telnic::Client::Profile' );
	use_ok( 'WebService::Telnic::Client::SearchData' );
	use_ok( 'WebService::Telnic::Client::RR' );
}

diag( "Testing WebService::Telnic $WebService::Telnic::VERSION, Perl $], $^X" );
