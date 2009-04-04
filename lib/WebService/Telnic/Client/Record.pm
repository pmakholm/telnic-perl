package WebService::Telnic::Client::Record;

use warnings;
use strict;
our $VERSION = '0.1';

use Scalar::Util qw(blessed);
use XML::Simple;
use WebService::Telnic::Client::RR;

sub listRecords {
    my $self   = shift;
    my $domain = shift;

    my $method = join "#", $self->{namespaces}->{record}, "listRecordsRequest";
    my $body   = qq(<record:listRecordsRequest domainName="$domain" />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $forcearray = [ map { qq({http://xmlns.telnic.org/ws/nsp/client/record/types-1.0}$_) } qw( naptr txt loc ) ];
    my $xml = XMLin( $res->content, NSExpand => 1, KeyAttr => [], ForceArray => $forcearray, SuppressEmpty =>'' );
    my $records = $xml->{'{http://www.w3.org/2003/05/soap-envelope}Body'}
                      ->{'{http://xmlns.telnic.org/ws/nsp/client/record/types-1.0}listRecordsResponse'};

    my @result;
    for my $key ( keys %$records ) {
	next unless $key =~ m!^\Q{http://xmlns.telnic.org/ws/nsp/client/record/types-1.0}\E(.*)!;
	my $type = $1;

	for my $record ( @{ $records->{$key} } ) {
		push @result, WebService::Telnic::Client::RR->from_xmlsimple($domain, $type, $record);
        }
    }

    return \@result;
}

sub storeRecord {
    my $self    = shift;
    my $domain  = shift;
    my @records = @_;

    my $method  = join "#", $self->{namespaces}->{record}, "storeRecordRequest";
    my $body    = qq(<record:storeRecordRequest domainName="$domain">);

    for my $record (@records) {
        WebService::Telnic::Client::RR->upgrade($record);

	next unless $record->isa('Net::DNS::RR');
	next unless $record->isa('WebService::Telnic::Client::RR');
        next unless $record->name eq $domain;

	$body .= $record->as_xml;
    } 

    $body .= qq(</record:storeRecordRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml = XMLin( $res->content, NSExpand => 1, KeyAttr => [], ForceArray => [qw(naptr)], SuppressEmpty =>'' );
    my $id  = $xml->{'{http://www.w3.org/2003/05/soap-envelope}Body'}
                  ->{'{http://xmlns.telnic.org/ws/nsp/client/record/types-1.0}storeRecordResponse'}
                  ->{'{http://xmlns.telnic.org/ws/nsp/client/record/types-1.0}id'};

    return $id;
}

sub deleteRecord {
    my $self   = shift;
    my $domain = shift;
    my $id     = shift;

    my $method = join "#", $self->{namespaces}->{record}, "listRecordsRequest";
    my $body   = qq(<record:deleteRecordRequest domainName="$domain"><record:id>$id</record:id></record:deleteRecordRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub updateRecord {
    my $self    = shift;
    my $domain  = shift;
    my @updates = @_;

    my $method  = join "#", $self->{namespaces}->{record}, "updateRecordRequest";
    my $body    = qq(<record:updateRecordRequest domainName="$domain">);

    for my $update (@updates) {
	$body .= qq(<record:deleteAll/>) if $update eq 'deleteAll';
	$body .= qq(<record:delete>$update->{delete}</record:delete>) if ref $update eq 'HASH';
        $body .= _groupUpdates($update) if ref $update eq 'ARRAY';
	
	if (blessed $update && $update->isa('Net::DNS::RR')) {
            WebService::Telnic::Client::RR->upgrade($update);
	    next unless $update->name eq $domain;

	    $body .= $update->as_xml;
        }
    }

    $body .= qq(</record:updateRecordRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}    

sub _groupUpdates {
    my $records = shift;
    my $group   = shift @{ $records } if ref $records->[0] eq 'HASH';

    my $xml = join " ", qq(<record:group), map { qq($_="$group->{$_}") } keys %$group;
    $xml   .= qq(>);

    for my $record (@{ $records }) {
        $xml .= _groupUpdates($record) if ref $record eq 'ARRAY';
	
	if (blessed $record && $record->isa('Net::DNS::RR')) {
            WebService::Telnic::Client::RR->upgrade($record);

	    $xml .= $record->as_xml;
        }
    }

    $xml .= qq(</record:group>);

    return $xml;
}
          

=head1 NAME

WebService::Telnic::Client - The great new WebService::Telnic::Client!

=head1 VERSION

Version 0.1

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

This software is released under the MIT license cited in L<WebService::Telnic>.

=cut

1; # End of WebService::Telnic::Client
