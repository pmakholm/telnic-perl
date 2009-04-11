package WebService::Telnic::Client::SearchData;

use WebService::Telnic::Util qw(XMLin);

our $VERSION = '0.2';

our %keywordsShort = (
    nameLabel             => 'nl',
    salutation            => 's',
    firstName             => 'fn',
    lastName              => 'ln',
    nickName              => 'nn',
    commonName            => 'cn',
    dateOfBirth           => 'dob',
    gender                => 'g',
    maritalStatus         => 'ms',
    postalAddress         => 'pa',
    addressLine1          => 'a1',
    addressLine2          => 'a2',
    addressLine3          => 'a3',
    townCity              => 'tc',
    postalCode            => 'pc',
    latitudeLongitude     => 'll',
    dirctoryInformation   => 'di',
    organization          => 'o',
    department            => 'd',
    jobTitle              => 'jt',
    hobbiesInterests      => 'hi',
    freeText              => 'ft',
    businessPostalAddress => 'bpa',
    businessInformation   => 'bi',
    businessName          => 'bn',
    businessArea          => 'ba',
    businessSubArea       => 'bsa',
    serviceArea           => 'sa',
);

our %keywordsLong = reverse %keywordsShort;

sub setSearchData {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{searchdata}, "setSearchDataRequest";
    my $body   = qq(<searchdata:setSearchDataRequest domainName="$self->{domain}"><searchdata:searchData>);

    $body .= data2xml(%data);
    $body .= qq(</searchdata:searchData></searchdata:setSearchDataRequest>);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub data2xml {
    my %data = @_;
    my $xml;

    for my $key (keys %data) {
        $key = $keywordsShort{$key} if defined $keywordsShort{$key};

        if (ref $data{$key} eq 'ARRAY') {
            my $value = shift @{ $data{$key} };
            $xml .= qq(<searchdata:keyword field="$key" value="$value">);
            $xml .= data2xml(%{ $data{$key}[0] }) if ref $data{$key}[0] eq 'HASH';
            $xml .= data2xml(@{ $data{$key}    }) if ref $data{$key}[0] ne 'HASH';
            $xml .= qq(</searchdata:keyword>);
        } else {
            $xml .= qq(<searchdata:keyword field="$key" value="$data{$key}" />);
        }
    }
    return $xml;
}

sub getSearchData {
    my $self = shift;
    my %data = @_;

    my $method = join "#", $self->{namespaces}->{searchdata}, "getSearchDataRequest";
    my $body   = qq(<searchdata:getSearchDataRequest domainName="$self->{domain}" />);

    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml  = XMLin( $res->content, RemoveNS => 1, ForceArray => [qw(keyword)], );
    my $data = $xml->{'Body'}
                   ->{'getSearchDataResponse'}
                   ->{'searchData'};

    return xml2data($data);
}

sub xml2data {
    my $xml  = shift;
    my @data; 

    my @keywords = ref $xml->{"keyword"} eq 'ARRAY' ? @{ $xml->{"keyword"} } : $xml->{"keyword"};
    for my $keyword (@keywords) {
        my $key   = $keyword->{"field"};
        my $value = $keyword->{"value"};

        $key = $keywordsLong{$key} if defined $keywordsLong{$key};

	if (defined $keyword->{"keyword"}) {
            $value = [ $value, { xml2data($keyword) } ];
        }

        push @data, $key => $value;
    }

    return @data;        
}

1;
