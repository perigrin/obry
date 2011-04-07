package Obry::Machine;
use Moose;
use Obry::Event;
use Obry::Constants qw(:all);

symbols(qw(next_in_pipe load_handler run_handler));

use Moose::Util::TypeConstraints;

role_type 'Obry::Event::API';
my $ObryPipeline = subtype as 'ArrayRef[Obry::Event::API]';
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
    does      => 'Obry::Event::API',
    is        => 'rw',
    predicate => 'has_current_handler',
    handles   => { run_current_handler => 'run', }
);

#after pipeline => sub { use Data::Dumper; warn Dumper \@_ };

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

no Moose;
1;
__END__
