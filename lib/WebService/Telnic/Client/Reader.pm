package WebService::Telnic::Client::Reader;

use strict;
use warnings;

use WebService::Telnic::Util qw(XMLin);

sub createGroup {
    my $self = shift;
    my %data = @_;

    croak("Need at least a name for the group")
        unless $data{name};

    $data{readers} = join " ", @{ $data{readers} } if ref $data{readers} eq 'ARRAY';
    $data{records} = join " ", @{ $data{records} } if ref $data{records} eq 'ARRAY';

    my $method = join "#", $self->{namespaces}->{reader}, "createGroupRequest";
    my $body   = qq(<reader:createGroupRequest zoneName="$self->{domain}">);
    
    $body .= qq(<reader:name>$data{name}</reader:name>);
    $body .= qq(<reader:readers>$data{readers}</reader:readers>) if defined $data{readers};
    $body .= qq(<reader:records>$data{records}</reader:records>) if defined $data{records};

    $body .= qq(</reader:createGroupRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml = XMLin( $res->content, RemoveNS => 1 );
    return $xml->{Body}
               ->{createGroupResponse}
               ->{id};
}

sub updateGroup {
    my $self = shift;
    my %data = @_;

    croak("Need at least an id for the group")
        unless $data{id};

    $data{readers} = join " ", @{ $data{readers} } if ref $data{readers} eq 'ARRAY';
    $data{records} = join " ", @{ $data{records} } if ref $data{records} eq 'ARRAY';

    my $method = join "#", $self->{namespaces}->{reader}, "updateGroupRequest";
    my $body   = qq(<reader:updateGroupRequest zoneName="$self->{domain}">);
    
    $body .= qq(<reader:id>$data{id}</reader:id>);
    $body .= qq(<reader:name>$data{name}</reader:name>)          if defined $data{name};
    $body .= qq(<reader:readers>$data{readers}</reader:readers>) if defined $data{readers};
    $body .= qq(<reader:records>$data{records}</reader:records>) if defined $data{records};

    $body .= qq(</reader:updateGroupRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub deleteGroup {
    my $self = shift;
    my %data = @_;

    croak("Need at least an id for the group")
        unless $data{id};

    my $method = join "#", $self->{namespaces}->{reader}, "deleteGroupRequest";
    my $body   = qq(<reader:deleteGroupRequest zoneName="$self->{domain}">);
    
    $body .= qq(<reader:id>$data{id}</reader:id>);
    $body .= qq(</reader:deleteGroupRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub getGroup {
    my $self = shift;
    my %data = @_;

    croak("Need at least an id for the group")
        unless $data{id};

    my $method = join "#", $self->{namespaces}->{reader}, "getGroupRequest";
    my $body   = qq(<reader:getGroupRequest zoneName="$self->{domain}">);
    
    $body .= qq(<reader:id>$data{id}</reader:id>);
    $body .= qq(</reader:getGroupRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    
    my $xml  = XMLin( $res->content, RemoveNS => 1 );
    my $data = $xml->{Body}->{getGroupResponse};

    $data{readers} = [ split / /, $data{readers} ] if defined $data{readers};
    $data{records} = [ split / /, $data{records} ] if defined $data{records};

    return $data;
}

sub listGroup {
    my $self = shift;

    my $method = join "#", $self->{namespaces}->{reader}, "listGroupRequest";
    my $body   = qq(<reader:listGroupRequest zoneName="$self->{domain}" />);
    
    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    
    my $xml  = XMLin( $res->content, RemoveNS => 1 );
    return $xml->{Body}->{listGroupResponse};
}

sub createReader {
    my $self = shift;
    my %data = @_;

    croak("Need at least name, readersPseudoDomain, and keyLocation for the reader")
        unless $data{name};

    $data{groups} = join " ", @{ $data{groups} } if ref $data{groups} eq 'ARRAY';

    my $method = join "#", $self->{namespaces}->{reader}, "createReaderRequest";
    my $body   = qq(<reader:createReaderRequest zoneName="$self->{domain}">);
    
    $body .= qq(<reader:name>$data{name}</reader:name>);
    $body .= qq(<reader:readerPseudoDomainName>$data{readerPseudoDomainName}</reader:readerPseudoDomainName>);
    $body .= qq(<reader:keyLocation>$data{keyLocation}</reader:keyLocation>);
    $body .= qq(<reader:reference>$data{reference}</reader:reference>) if defined $data{reference};
    $body .= qq(<reader:groups>$data{groups}</reader:groups>) if defined $data{groups};

    $body .= qq(</reader:createReaderRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml = XMLin( $res->content, RemoveNS => 1 );
    return $xml->{Body}
               ->{createReaderResponse};
}

sub updateReader {
    my $self = shift;
    my %data = @_;

    croak("Need at least an id for the group")
        unless $data{id};

    $data{groups} = join " ", @{ $data{groups} } if ref $data{groups} eq 'ARRAY';

    my $method = join "#", $self->{namespaces}->{reader}, "updateReaderRequest";
    my $body   = qq(<reader:updateReaderRequest zoneName="$self->{domain}">);
    
    $body .= qq(<reader:id>$data{id}</reader:id>);
    $body .= qq(<reader:name>$data{name}</reader:name>) if defined $data{name};
    $body .= qq(<reader:readerPseudoDomainName>$data{readerPseudoDomainName}</reader:readerPseudoDomainName>) if defined $data{readerPseudoDomainName};
    $body .= qq(<reader:keyLocation>$data{keyLocation}</reader:keyLocation>) if defined $data{keyLocation};
    $body .= qq(<reader:reference>$data{reference}</reader:reference>) if defined $data{reference};
    $body .= qq(<reader:groups>$data{groups}</reader:groups>) if defined $data{groups};

    $body .= qq(</reader:updateReaderRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml = XMLin( $res->content, RemoveNS => 1 );
    return $xml->{Body}
               ->{createReaderResponse}
               ->{label};
}

sub deleteReader {
    my $self = shift;
    my %data = @_;

    croak("Need at least an id for the group")
        unless $data{id};

    my $method = join "#", $self->{namespaces}->{reader}, "deleteReaderRequest";
    my $body   = qq(<reader:deleteReaderRequest zoneName="$self->{domain}">);
    
    $body .= qq(<reader:id>$data{id}</reader:id>);
    $body .= qq(</reader:deleteReaderRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub getReader {
    my $self = shift;
    my %data = @_;

    croak("Need at least an id for the group")
        unless $data{id};

    my $method = join "#", $self->{namespaces}->{reader}, "getReaderRequest";
    my $body   = qq(<reader:getReaderRequest zoneName="$self->{domain}">);
    
    $body .= qq(<reader:id>$data{id}</reader:id>);
    $body .= qq(</reader:getReaderRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    
    my $xml  = XMLin( $res->content, RemoveNS => 1 );
    my $data = $xml->{Body}->{getReaderResponse};

    $data{groups} = [ split / /, $data{groups} ] if defined $data{groups};

    return $data;
}

sub listReader {
    my $self = shift;

    my $method = join "#", $self->{namespaces}->{reader}, "listReaderRequest";
    my $body   = qq(<reader:listReaderRequest zoneName="$self->{domain}" />);
    
    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    
    my $xml  = XMLin( $res->content, RemoveNS => 1 );
    return $xml->{Body}->{listReaderResponse};
}

1;
