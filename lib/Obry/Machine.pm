package Obry::Machine;
use Obry::Event;
use namespace::autoclean;

use Obry::Constants qw(:all);
use Moose::Util::TypeConstraints;

register_events qw(next_in_pipe load_handler run_handler);

role_type 'Obry::Event::API';
my $ObryPipeline = subtype as 'ArrayRef[Obry::API::Event]';
coerce $ObryPipeline => from 'ArrayRef[ClassName]' => via {
    [ map { $_->new } @$_ ];
};

has pipeline => (
    isa     => $ObryPipeline,
    coerce  => 1,
    traits  => ['Array'],
    is      => 'rw',
    lazy    => 1,
    default => sub { [] },
    handles => {
        'add_handler'          => 'push',
        'remove_last_handler'  => 'pop',
        'remove_first_handler' => 'shift',
        'insert_handler'       => 'unshift',
        'get_handler_at'       => 'get',
        'set_handler_at'       => 'set',
        'num_handlers'         => 'count',
        'has_handlers'         => 'is_empty',
    },
);

has current_handler => (
    does      => 'Obry::API::Event',
    is        => 'rw',
    predicate => 'has_current_handler',
    handles   => { run_current_handler => 'run', }
);

sub next_in_pipe {
    my ($self) = @_;
    return DONE unless $self->has_handlers;
    $self->current_handler( $self->remove_first_handler );
    return OK;
}

sub load_handler {
    my ($self) = @_;

    # we're done unless we have a current handler
    return DONE unless $self->has_current_handler;

    return OK;
}

sub run_handler {
    my ( $self, $ctxt ) = @_;

    # run the handler, and warn if we don't have a valid return value
    ( my $ret = $self->run_current_handler($ctxt) )
      || $self->error( "no return from " . $self->current_handler );

    # if we still have handlers, reset our state machine
    $self->reset_symbols if $self->has_handlers;
    return $ret;
}

1;
__END__
