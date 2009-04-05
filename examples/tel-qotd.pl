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
   
   my @texts = $record->char_str_list();
   next unless $texts[2] eq "quoteOfTheDay";

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
    ".tkw", "1",
    'quoteOfTheDay',
    shift @quotes,
];

$client->storeRecord($qotd);

__DATA__
"Frankly, my dear, I don't give a damn." -- Rhett Butler
"I'm going to make him an offer he can't refuse." -- Vito Corleone
"Toto, I've got a feeling we're not in Kansas anymore." -- Dorothy
"Here's looking at you, kid." -- Rick Blaine
"Go ahead, make my day." -- Harry Callahan
"All right, Mr. DeMille, I'm ready for my close-up." -- Norma Desmond
"May the Force be with you." -- Han Solo
"Fasten your seatbelts. It's going to be a bumpy night." -- Margo Channing
"You talkin' to me?" -- Travis Bickle
"What we've got here is failure to communicate." -- Captain
"I love the smell of napalm in the morning!" -- Lt. Col. Bill Kilgore
"Love means never having to say you're sorry." -- Jennifer Cavilleri Barrett
"The stuff that dreams are made of." -- Sam Spade
"E.T. phone home. -- E.T.
"They call me Mister Tibbs!" -- Virgil Tibbs
"Rosebud." -- Charles Foster Kane
"Made it, Ma! Top of the world!" -- Arthur "Cody" Jarrett
"I'm as mad as hell, and I'm not going to take this anymore!" -- Howard Beale
"Louis, I think this is the beginning of a beautiful friendship." -- Rick Blaine
"A census taker once tried to test me. I ate his liver with some fava beans and a nice Chianti." -- Hannibal Lecter
