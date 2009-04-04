#!/usr/bin/perl

use strict;
use warnings;

use WebService::Telnic::Client;
use Getopt::Long;

my ($endpoint, $domain, $user, $pass, $list, $set);
GetOptions(
    'endpoint=s' => \$endpoint,
    'domain=s'   => \$domain,
    'user=s'     => \$user,
    'pass=s'     => \$pass,
    'list'       => \$list,
    'set=s'      => \$set,
);

die 'endpoint, domain, user, and pass is all needed' unless
    $endpoint && $domain && $user && $pass;

die 'One and only one of --list or --set' if ($list && $set) || (!$list && !$set);

my $client = WebService::Telnic::Client->new(
    endpoint => $endpoint,
    user     => $user,
    pass     => $pass,
);

if ($list) {
    my $profiles = $client->listProfilesExt($domain);

    for my $profile (@{ $profiles->{profile} }) {
        print ($profile->{id} == $profiles->{active} ? '*' : ' ');
        print $profile->{id}, "\t", $profile->{name}, "\n";
    }
} else {
    my $res = $client->switchToProfile($domain, id => $set);
    print $res ? "Succedded\n" : "failed\n";
}



