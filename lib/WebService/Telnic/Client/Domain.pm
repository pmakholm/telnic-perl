package WebService::Telnic::Client::Domain;

use WebService::Telnic::Util qw(XMLin);

our $VERSION = '0.2';

sub createZone {
    my $self = shift;
    my %data = @_;

    croak("Need at least one of nameserverCount or nameservers")
        unless $data{nameserverCount} || $data{nameservers};

    $data{nameservers} ||= [];

    my $method = join "#", $self->{namespaces}->{domain}, "createZoneRequest";
    my $body   = qq(<domain:createZoneRequest zoneName="$self->{domain}">);
    
    $body .= qq(<domain:nameservers) . ($data{nameserverCount} ? qq( count="$data{nameserverCount}">) : ">");
    $body .= qq(<domain:host>$_</domain:host>) for @{ $data{nameservers} };
    $body .= qq(</domain:nameservers></domain:createZoneRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub updateZone {
    my $self = shift;
    my %data = @_;

    croak("Need at least one of nameserverCount or nameservers")
        unless $data{nameserverCount} || $data{nameservers};

    $data{nameservers} ||= [];

    my $method = join "#", $self->{namespaces}->{domain}, "updateZoneRequest";
    my $body   = qq(<domain:updateZoneRequest zoneName="$self->{domain}">);
    
    $body .= qq(<domain:nameservers) . ($data{nameserverCount} ? qq( count="$data{nameserverCount}">) : ">");
    $body .= qq(<domain:host>$_</domain:host>) for @{ $data{nameservers} };
    $body .= qq(</domain:nameservers></domain:updateZoneRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub deleteZone {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{domain}, "deleteZoneRequest";
    my $body   = qq(<domain:deleteZoneRequest zoneName="$self->{domain}" />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub getZone {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{domain}, "getZoneRequest";
    my $body   = qq(<domain:getZoneRequest zoneName="$self->{domain}" />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml  = XMLin( $res->content, RemoveNS => 1, ForceArray => [qw(keyword)] );

    return $xml->{Body}
               ->{getZoneResponse};
}

sub listZones {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{domain}, "listZonesRequest";
    my $body   = qq(<domain:listZonesRequest />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml  = XMLin( $res->content, RemoveNS => 1, ForceArray => [qw(keyword)] );
    return $xml->{Body}
               ->{listZonesResponse};
}

sub createDomain {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{domain}, "createDomainRequest";
    my $body   = qq(<domain:createDomainRequest domainName="$self->{domain}" />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub deleteDomain {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{domain}, "deleteDomainRequest";
    my $body   = qq(<domain:deleteDomainRequest domainName="$self->{domain}" />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub getDomain {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{domain}, "getDomainRequest";
    my $body   = qq(<domain:getDomainRequest domainName="$self->{domain}" />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml  = XMLin( $res->content, RemoveNS => 1, ForceArray => [qw(keyword)] );
    return $xml->{Body}
               ->{getDomainResponse}
}

sub listDomains {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{domain}, "listDomainsRequest";
    my $body   = qq(<domain:listDomainsRequest />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml  = XMLin( $res->content, RemoveNS => 1, ForceArray => [qw(keyword)] );
    return $xml->{Body}
               ->{listDomainsResponse};
}

1;
