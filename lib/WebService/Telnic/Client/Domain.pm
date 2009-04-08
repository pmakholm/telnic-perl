package WebService::Telnic::Client::Domain;

use XML::Simple;

our $VERSION = '0.2';

sub removeNS {
    my $data = shift;

    return $data
        unless ref $data;

    return [ map { removeNS($_) } @{ $data } ]
        if ref $data eq 'ARRAY';

    return do { my $ref = removeNS($$data); \$ref }
        if ref $data eq 'SCALAR';

    return $data
        if ref $data ne 'HASH';

    my $new = {};
    for my $key (keys %{ $data }) {
        next if $key eq 'xmlns';

        my $value = removeNS( $data->{$key} );

        $key =~ /^(?:\{([^}]+)\})?(.*)/;
	next if $1 eq 'http://www.w3.org/2000/xmlns/';

	$new->{$2} = $value;
    }
 
    return $new;
}

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

    my $xml  = XMLin( $res->content, NSExpand => 1, KeyAttr => [], ForceArray => [qw(keyword)], SuppressEmpty =>'' );
    my $data = $xml->{'{http://www.w3.org/2003/05/soap-envelope}Body'}
                   ->{'{http://xmlns.telnic.org/ws/nsp/client/domain/types-1.0}getZoneResponse'};

    return removeNS($data);
}

sub listZones {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{domain}, "listZonesRequest";
    my $body   = qq(<domain:listZonesRequest />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml  = XMLin( $res->content, NSExpand => 1, KeyAttr => [], ForceArray => [qw(keyword)], SuppressEmpty =>'' );
    my $data = $xml->{'{http://www.w3.org/2003/05/soap-envelope}Body'}
                   ->{'{http://xmlns.telnic.org/ws/nsp/client/domain/types-1.0}listZonesResponse'};

    return removeNS($data);
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

    my $xml  = XMLin( $res->content, NSExpand => 1, KeyAttr => [], ForceArray => [qw(keyword)], SuppressEmpty =>'' );
    my $data = $xml->{'{http://www.w3.org/2003/05/soap-envelope}Body'}
                   ->{'{http://xmlns.telnic.org/ws/nsp/client/domain/types-1.0}getDomainResponse'};

    return removeNS($data);
}

sub listDomains {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{domain}, "listDomainsRequest";
    my $body   = qq(<domain:listDomainsRequest />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml  = XMLin( $res->content, NSExpand => 1, KeyAttr => [], ForceArray => [qw(keyword)], SuppressEmpty =>'' );
    my $data = $xml->{'{http://www.w3.org/2003/05/soap-envelope}Body'}
                   ->{'{http://xmlns.telnic.org/ws/nsp/client/domain/types-1.0}listDomainsResponse'};

    return removeNS($data);
}

sub getSearchData {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{domain}, "getSearchDataRequest";
    my $body   = qq(<domain:getSearchDataRequest domainName="$self->{domain}" />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml  = XMLin( $res->content, NSExpand => 1, KeyAttr => [], ForceArray => [qw(keyword)], SuppressEmpty =>'' );
    my $data = $xml->{'{http://www.w3.org/2003/05/soap-envelope}Body'}
                   ->{'{http://xmlns.telnic.org/ws/nsp/client/domain/types-1.0}getSearchDataResponse'}
                   ->{'{http://xmlns.telnic.org/ws/nsp/client/domain/types-1.0}searchData'};

    return xml2data($data);
}
1;
