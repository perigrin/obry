package Obry::Event;
use Moose;
use Obry::Constants;
use Obry::Meta::Class;
use Obry::Context;

use MooseX::AttributeHelpers;
use MooseX::LogDispatch;

use Sub::Name 'subname';
use Sub::Exporter;

BEGIN {
    my $CALLER;

    my %exports = (
        symbols => sub {
            my $class = $CALLER;
            return subname 'Obry::Event::symbols' => sub (@) {
                my (@symbols) = @_;
                confess "Must specify at least one symbol" unless @symbols;
                my $attr = $class->meta->symbols( \@symbols );
            };
        },
    );

    my $exporter = Sub::Exporter::build_exporter(
        {
            exports => \%exports,
            groups  => { default => [':all'] }
        }
    );

    sub import {
        $CALLER = caller();

        strict->import;
        warnings->import;

        # we should never export to main
        return if $CALLER eq 'main';
        Moose::init_meta( $CALLER, 'Obry::Event', 'Obry::Meta::Class' );
        Moose->import( { into => $CALLER } );

        # Do my custom framework stuff
        goto $exporter;
    }
}

has _symbols => (
    metaclass  => 'Collection::Array',
    isa        => 'ArrayRef[Str]',
    is         => 'rw',
    clearer    => 'reset_symbols',
    lazy_build => 1,
    provides   => {
        'push'    => 'add_to_queue',
        'pop'     => 'remove_last_symbol',
        'shift'   => 'remove_first_symbol',
        'unshift' => 'insert_symbol',
        'get'     => 'get_symbol_at',
        'set'     => 'set_symbol_at',
        'count'   => 'num_symbols',
        'empty'   => 'has_symbols',
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

no Moose;
1;
__END__
