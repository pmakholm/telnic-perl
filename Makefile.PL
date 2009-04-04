use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WebService::Telnic',
    AUTHOR              => 'Peter Makholm <peter@makholm.net>',
    LICENSE             => 'mit',
    VERSION_FROM        => 'lib/WebService/Telnic.pm',
    ABSTRACT_FROM       => 'lib/WebService/Telnic.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'Net::DNS::RR' => 0,
        'LWP::UserAgent' => 0,
        'List::Util' => 0,
        'Scalar::Util' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WebService-Telnic-*' },
);
