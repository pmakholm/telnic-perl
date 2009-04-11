package WebService::Telnic::Util;

use strict;
use warnings;

use XML::Simple ();

use Exporter qw(import);
our @EXPORT_OK = qw(XMLin removeNS);

sub XMLin {
    my $data = shift;
    my %args = @_;

    my $removeNS = $args{RemoveNS};
    delete $args{RemoveNS};

    $args{NSExpand}      = 1  unless defined $removeNS;
    $args{NSExpand}      = 1  unless defined $args{NSExpand};
    $args{KeyAttr}       = [] unless defined $args{KeyAttr};
    $args{SuppressEmpty} = '' unless defined $args{SuppressEmpty};

    my $xml = XML::Simple::XMLin( $data, %args );

    $xml = removeNS($xml) if $removeNS;

    return $xml;
}

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
	next if defined($1) && $1 eq 'http://www.w3.org/2000/xmlns/';

	$new->{$2} = $value;
    }
 
    return $new;
}

1;
