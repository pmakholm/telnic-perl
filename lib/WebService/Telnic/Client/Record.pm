package WebService::Telnic::Client::Record;

use warnings;
use strict;
our $VERSION = '0.2';

use Scalar::Util qw(blessed);
use XML::Simple;
use WebService::Telnic::Client::RR;

sub listRecords {
    my $self   = shift;
    my $domain = $self->{domain};

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
    my @records = @_;
    my $domain  = $self->{domain};

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
    my $id     = shift;
    my $domain = $self->{domain};

    my $method = join "#", $self->{namespaces}->{record}, "listRecordsRequest";
    my $body   = qq(<record:deleteRecordRequest domainName="$domain"><record:id>$id</record:id></record:deleteRecordRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub updateRecord {
    my $self    = shift;
    my $domain  = $self->{domain};
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

1; # End of WebService::Telnic::Client
