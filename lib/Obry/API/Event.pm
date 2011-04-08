package Obry::API::Event;
use Moose::Role;
use namespace::autoclean;

use Obry::Constants qw(:all);

has queue => (
    isa     => 'ArrayRef[Str]',
    traits  => ['Array'],
    is      => 'rw',
    clearer => 'reset_symbols',
    lazy    => 1,
    builder => '_build_queue',
    handles => {
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

sub _build_queue {
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
    does    => 'Obry::API::Context',
    is      => 'ro',
    lazy    => 1,
    builder => '_build_context',
    handles => 'Obry::API::Context',
);

sub _build_context { ( (shift)->meta->context_class )->new() }

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
