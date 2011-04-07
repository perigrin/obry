package Obry::Event::API;
use Moose::Role;

use namespace::autoclean;

use Obry::Constants qw(:all);
use Obry::Context;

has _symbols => (
    isa        => 'ArrayRef[Str]',
    traits     => ['Array'],
    is         => 'rw',
    clearer    => 'reset_symbols',
    lazy_build => 1,
    handles    => {
        'add_to_queue'        => 'push',
        'remove_last_symbol'  => 'pop',
        'remove_first_symbol' => 'shift',
        'insert_symbol'       => 'unshift',
        'get_symbol_at'       => 'get',
        'set_symbol_at'       => 'set',
        'num_symbols'         => 'count',
        'has_symbols'         => 'is_empty',
    },
);

sub _build__symbols {
    return (shift)->meta->symbols;
}

has next_symbol => (
    isa     => 'Str',
    is      => 'rw',
    writer  => 'yield',
    lazy    => 1,
    clearer => 'symbol_done',
    default => sub { $_[0]->remove_first_symbol },
);

has context => (
    isa        => 'Obry::Context',
    is         => 'ro',
    lazy_build => 1,
    handles    => [qw(output)],
);

sub _build_context {
    Obry::Context->new(),;
}

sub run {
    my ( $self, $ctxt ) = @_;
    my $ret;
    while ( my $symbol = $self->next_symbol ) {
        ( $ret = $self->$symbol($ctxt) ) || confess "no return from $symbol";
        $self->symbol_done;
        last unless $ret eq OK;
    }
    return $ret;
}

1;
__END__
