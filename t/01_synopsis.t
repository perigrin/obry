use strict;
use Test::More;

{

    package MyEventHandler;
    use Obry::Event;

    symbols(qw(event_foo event_bar));

    sub event_foo {
        my ( $self, $ctxt ) = @_;
        ::pass('foo');
        $self->output('FOO!');
        return 'OK';
    }

    sub event_bar {
        my ( $self, $ctxt ) = @_;
        $self->output('Bar!');
        return 'OK';
    }
}
{

    package MyOutputHandler;
    use Obry::Event;

    symbols(qw(print_output));

    sub print_output {
        my ( $self, $ctxt ) = @_;
        print $self->output;
        return 'OK';
    }
}
{

    package MyApp;
    use Obry;
    my $app = Obry->new();
    $app->pipeline( [qw(MyEventHandler MyOutputHandler)] );
    warn $app->dump;
    $app->run();
}
done_testing;
