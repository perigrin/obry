package Obry::Constants;
use Moose;

sub import {
    my $pkg = caller();
    return if $pkg eq 'main';

    ( $pkg->can('meta') )
      || confess "This package can only be used in Moose based classes";

    my %exports = (
        OK            => sub () { 'OK' },
        DECLINE       => sub () { 'DECLINE' },
        DONE          => sub () { 'DONE' },
        OUTPUT        => sub () { 'OUTPUT' },
        SERVER_ERROR  => sub () { 'SERVER_ERROR' },
        HANDLER_ERROR => sub () { 'HANDLER_ERROR' },
        QUEUE_ERROR   => sub () { 'QUEUE_ERROR' },
    );

    for my $symbol ( keys %exports ) {
        $pkg->meta->add_method( $symbol => $exports{$symbol} );
    }
}

no Moose;
1;
__END__