package WebService::Telnic::Client;

use warnings;
use strict;

use XML::Simple;
use Net::DNS::RR;

use base qw(WebService::Telnic::Base WebService::Telnic::Client::Record WebService::Telnic::Client::Profile);

our $VERSION = '0.1';

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

WebService::Telnic::Client - The great new WebService::Telnic::Client!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use WebService::Telnic::Client;

    my $foo = WebService::Telnic::Client->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Peter Makholm, C<< <peter at makholm.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-telnic-client at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-Telnic>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::Telnic


You can also look for information at:

=over 4

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

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of WebService::Telnic::Client
