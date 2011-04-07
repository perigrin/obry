package Obry::Meta::Trait::Class;
use Moose::Role;
use namespace::autoclean;

has symbols => (
    isa        => 'ArrayRef[Str]',
    is         => 'rw',
    lazy_build => 1,
);

sub _build_symbols { return [] }

1;
__END__