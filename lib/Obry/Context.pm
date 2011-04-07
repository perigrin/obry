package Obry::Context;
use Moose;
use namespace::autoclean;

with qw(MooseX::Param);

has output => (
    isa => 'Str',
    is  => 'rw',
);

1;
__END__
