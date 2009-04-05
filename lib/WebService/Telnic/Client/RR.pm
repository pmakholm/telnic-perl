package WebService::Telnic::Client::RR;

=head1 NAME

WebService::Telnic::Client::RR - Enhanced Net::DNS::RR records

=head1 SYNOPSIS

    my $rr = Net::DNS::RR->new( ... );
    WebService::Telnic::Client::RR->upgrade($rr);

    $rr->id(12345);

=head1 DESCRIPTION

WebService::Telnic::Client::RR enhances L<Net::DNS::RR> records with
information available within the Tel Hosting system. At the moment LOC,
NAPTR, and TXT records are supported.
  
=over 4

=item WebService::Telnic::Client::RR->upgrade($rr)

Upgrades a Net::DNS::RR object to this class

=item $rr->downgrade()

Downgrades an object to a Net::DNS::RR object

=item $rr->id()

Getter/setter for the id attribute of records. For editing records this
should be set to an existing id in the Tel Hosting system

=item $rr->owner()

Getter/setter for the owner attribute

=item $rr->profiles()

Getter/setter for the profile attribute

=item $rr->groups()

Getter/setter for the groups attribute

=head1 AUTHOR

Peter Makholm, C<< <peter at makholm.net> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Peter Makholm, all rights reserved.

This software is released under the MIT license cited in L<WebService::Telnic>.

=cut


use base (Net::DNS::RR);
our %TypeMap;

our $VERSION = '0.2';

sub new {
    my $class = shift;
    my $self  = Net::DNS::RR->new(@_);

    $class->upgrade($self);
    return $self;
}

sub upgrade {
    my $class = shift;
    my $self  = shift;

    bless $self, $TypeMap{$self->type} if exists $TypeMap{$self->type};
    return $self;
}

sub downgrade {
    my $self = shift;

    bless $self, "Net::DNS::RR::$self->type";
}

sub DESTROY {
    my $self = shift;
    
    # After downgrading the super class can destroy at will
    $self->downgrade();
}

sub as_xml {
    my $self = shift;
    my $xml;
    my $attributes = $self->_attributes;

    $xml  = qq(<record:) . lc($self->type);
    $xml .= qq( $attributes) if $attributes;
    $xml .= qq(>);

    for my $field ($self->Fields) {
        my $method = $self->_method($field);
	my @data   = $self->$method;
	next unless @data;

	for my $val (@data) {
            $xml .= qq(<record:$field>);

            $xml .= $val unless ref $val;
            $xml .= _href2xml($val) if ref $val eq 'HASH';            

            $xml .= qq(</record:$field>);
        }
    }

    $xml .= qq(</record:) . lc($self->type) . qq(>);

    return $xml;
} 

sub _method {
    my $self = shift;
    return     shift;
}

sub _href2xml {
    my $ref = shift;
    my $xml;

    for my $key (keys %$ref) {
        $xml .= qq(<record:$key>);

        $xml .= $ref->{$key} unless ref $ref->{$key};
        $xml .= _href2xml($ref->{key}) if ref $ref->{$key} eq 'HASH';
    }            

    return $xml;
}

sub _attributes {
    my $self = shift;

    # the lc call is purely to get IN lowercased. Might break something
    return join " ", map { exists $self->{$_} ? qq($_=").lc $self->{$_} . qq(") : () } qw( id owner class ttl profiles groups );
}


sub from_xmlsimple {
    my $class  = shift;
    my $domain = shift;
    my $type   = shift; 
    my $xml    = shift;

    my $text   = $xml->{'{http://xmlns.telnic.org/ws/nsp/client/record/types-1.0}text'};
    $text      = [ $text ] unless ref $text eq 'ARRAY';
    delete $xml->{'{http://xmlns.telnic.org/ws/nsp/client/record/types-1.0}text'};


    my $self = $class->new(
        type => uc($type),
        name => $domain,
        map {s!^\Q{http://xmlns.telnic.org/ws/nsp/client/record/types-1.0}!!; $_} %{ $xml }
    );

    $self->{'char_str_list'} = $text;

    return $self;
}

for my $field (qw( id owner profiles groups )) {
    no strict 'refs';

    *{$field} = sub {
        my $self = shift;
        $self->{$field} = shift if @_;
        return $self->{$field};
    };
}
  

package WebService::Telnic::Client::RR::NAPTR;

use base qw(Net::DNS::RR::NAPTR WebService::Telnic::Client::RR);
$WebService::Telnic::Client::RR::TypeMap{NAPTR} = __PACKAGE__;

sub Fields {
    return qw(order preference flags services regexp replacement);
}

package WebService::Telnic::Client::RR::TXT;

use base qw(Net::DNS::RR::TXT WebService::Telnic::Client::RR);
$WebService::Telnic::Client::RR::TypeMap{TXT} = __PACKAGE__;

sub Fields {
    return qw(text);
}

sub _method {
    my $self  = shift;
    my $field = shift;
    return 'char_str_list' if $field eq 'text';
    return $field;
} 

package WebService::Telnic::Client::RR::LOC;

use base qw(Net::DNS::RR::LOC WebService::Telnic::Client::RR);
$WebService::Telnic::Client::RR::TypeMap{LOC} = __PACKAGE__;


