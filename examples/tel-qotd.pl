#!/usr/bin/perl

use strict;
use warnings;

use WebService::Telnic::Client;
use Net::DNS::RR;
use List::Util qw(shuffle);
use Getopt::Long;

my @quotes = shuffle <DATA>; 
chomp @quotes;

my ($endpoint, $domain, $user, $pass);
GetOptions(
    'endpoint=s' => \$endpoint,
    'domain=s'   => \$domain,
    'user=s'     => \$user,
    'pass=s'     => \$pass,
);

die 'domain, user, and pass is all needed' unless
    $domain && $user && $pass;

my $client = WebService::Telnic::Client->new(
    endpoint => $endpoint,
    domain   => $domain,
    user     => $user,
    pass     => $pass,
);

my $qotd;
for my $record (@{ $client->listRecords() }) {
   next unless $record->isa('Net::DNS::RR::TXT');
   
   my ($type) = $record->char_str_list();
   next unless $type eq "Quote of the day";

   $qotd = $record;
   last;
}

unless (defined $qotd) {
    $qotd = Net::DNS::RR->new(
        type => 'TXT',
        name => $domain,
    );
}

# Net::DNS::RR::TXT doesn't have a nice accessor?
$qotd->{'char_str_list'} = [ 
    'Quote of the day',
    shift @quotes,
];

$client->storeRecord($qotd);

__DATA__
alpha
beta
gamma
delta

