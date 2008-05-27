package Obry::Context;
use strict;
use Moose;

with qw(MooseX::Param);

has output => (
    isa => 'Str',
    is  => 'rw',
);

no Moose;
1;
__END__
