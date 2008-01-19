package Obry::Meta::Class;
use Moose;
extends qw(Moose::Meta::Class);

has symbols => (
    isa        => 'ArrayRef[Str]',
    is         => 'rw',
    lazy_build => 1,
);

sub _build_symbols { return [] }

no Moose;
1;
__END__
