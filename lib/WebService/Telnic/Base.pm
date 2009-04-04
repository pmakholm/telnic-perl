package WebService::Telnic::Base;

use warnings;
use strict;

use LWP::UserAgent;
use HTTP::Request;

our $VERSION = '0.1';

sub new {
    my $class = shift;
    my %args  = @_;

    my $uri = URI->new($args{endpoint});

    my $ua  = LWP::UserAgent->new(
        agent => "WebService::Telnic/$VERSION",
    );

    $ua->credentials( $uri->host_port, 'client-api', $args{user}, $args{pass});
    my $req = HTTP::Request->new( POST => $args{endpoint} );
    $req->header( Accept => 'application/soap+xml' );
    $req->content_type( 'application/soap+xml' );


    return bless {
	args       => \%args,
        ua         => $ua,
	req        => $req,
        namespaces => {}
    }, $class;
}

sub soap {
    my $self   = shift;
    my $method = shift;
    my $body   = shift;

    my $req = $self->{req}->clone();

    my $namespaces;
    $namespaces .= qq( xmlns:$_="$self->{namespaces}->{$_}" ) for keys %{$self->{namespaces}}; 

    $req->header( SOAPAction => $method );
    $req->content(<<EOF);
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:soapenc="http://www.w3.org/2003/05/soap-encoding"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
               soap:encodingStyle="http://www.w3.org/2003/05/soap-encoding"
               xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
               $namespaces>
  <soap:Body>
    $body
  </soap:Body>
</soap:Envelope>
EOF

    my $response = $self->{ua}->request($req);

    return $response;
}

1; # End of WebService::Telnic::Base
