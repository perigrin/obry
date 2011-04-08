package Obry::Meta::Trait::Class;
use Moose::Role;
use namespace::autoclean;

use Obry::Context::Simple;

has symbols => (
    isa        => 'ArrayRef[Str]',
    is         => 'rw',
    lazy_build => 1,
);

sub _build_symbols { return [] }

has context_class => (
    isa     => 'ClassName',
    is      => 'ro',
    default => 'Obry::Context::Simple'
);

1;
__END__
