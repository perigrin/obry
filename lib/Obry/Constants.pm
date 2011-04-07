package Obry::Constants;
use Moose;
use namespace::autoclean;

sub import {
    my $pkg = caller();

    $pkg->can('meta') || confess "I need a Moose-ish ->meta()";

    my %exports = (
        OK            => sub () { 'OK' },
        DECLINE       => sub () { 'DECLINE' },
        DONE          => sub () { 'DONE' },
        OUTPUT        => sub () { 'OUTPUT' },
        SERVER_ERROR  => sub () { 'SERVER_ERROR' },
        HANDLER_ERROR => sub () { 'HANDLER_ERROR' },
        QUEUE_ERROR   => sub () { 'QUEUE_ERROR' },
    );

    $pkg->meta->add_method( $_ => $exports{$_} ) for keys %exports;
}

1;
__END__
