package Obry::Machine;
use Obry::Event;
use Obry::Constants;
use Moose::Util::TypeConstraints;

symbols(qw(next_in_pipe load_handler run_handler));

subtype ObryPipeline => as 'ArrayRef[Obry::Event]';

coerce 'ObryPipeline'
    => from 'ArrayRef[Str]'
        => via {
            [ map { 
                Class::MOP::load_class($_);
                $_->new
            } @$_ ]
        }
    => from 'ArrayRef[ClassName]'
        => via {
            [ map { $_->new } @$_ ]        
        };

has pipeline => (
    metaclass => 'Collection::Array',
    isa       => 'ObryPipeline',
    is        => 'rw',

    coerce    => 1,
    default  => sub { [] },
    provides => {
        'push'    => 'add_handler',
        'pop'     => 'remove_last_handler',
        'shift'   => 'remove_first_handler',
        'unshift' => 'insert_handler',
        'get'     => 'get_handler_at',
        'set'     => 'set_handler_at',
        'count'   => 'num_handlers',
        'empty'   => 'has_handlers',
    },
);



has current_handler => (
    isa       => 'Obry::Event',
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
