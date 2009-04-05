package WebService::Telnic::Client;

use warnings;
use strict;

use XML::Simple;
use Net::DNS::RR;

use base qw(WebService::Telnic::Base WebService::Telnic::Client::Record WebService::Telnic::Client::Profile WebService::Telnic::Client::SearchData);

our $VERSION = '0.2';

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);

    $self->{namespaces} = {
	%{ $self->{namespaces} },
	domain     => 'http://xmlns.telnic.org/ws/nsp/client/domain/types-1.0',
	record     => 'http://xmlns.telnic.org/ws/nsp/client/record/types-1.0',
	reader     => 'http://xmlns.telnic.org/ws/nsp/client/reader/types-1.0',
	profile    => 'http://xmlns.telnic.org/ws/nsp/client/profile/types-1.0',
	searchdata => 'http://xmlns.telnic.org/ws/nsp/client/searchdata/types-1.0',
	exchange   => 'http://xmlns.telnic.org/ws/nsp/client/exchange/types-1.0',
    };

    return $self;
}

=head1 NAME

WebService::Telnic::Client - Interface to the Telnic Client API

=head1 VERSION

Version 0.1

=head1 SYNOPSIS

    use WebService::Telnic::Client;

    my $client = WebService::Telnic::Client->new(
        domain   => 'example.tel',
        user     => 'exampletel',
        pass     => 'XXXXXXXX,
    )

    my $records  = $client->listRecords();
    my $profiles = $client->listProfilesExt();

At the moment only handling of resource records and profiles is implemented.
All methods takes the domain name as first argument.

=head1 Record

=head2 listRecords

=head2 storeRecord

=head2 updateRecords

=head2 deleteRecord

=head1 Profile

=head2 createProfile

=head2 deleteProfile

=head2 updateProfile

=head2 listProfiles

=head2 listProfilesExt

=head2 getProfile

=head2 switchToProfile

=head2 getActiveProfile

=head1 SearchData

=head2 setSearchData

=head2 getSearchData

=head1 AUTHOR

Peter Makholm, C<< <peter at makholm.net> >>

=head1 SEE ALSO

L<http://dev.telnic.org/api/client-soap/index.html>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-telnic-client at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-Telnic>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can look for information at:

=over 4

=item * github: Public version control system

L<http://github.com/pmakholm/telnic-perl/tree>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-Telnic>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-Telnic>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-Telnic>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-Telnic>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Peter Makholm, all rights reserved.

This software is released under the MIT license cited in L<WebService::Telnic>.

=cut

1; # End of WebService::Telnic::Client
