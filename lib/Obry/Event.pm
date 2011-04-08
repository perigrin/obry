package Obry::Event;
use Moose();
use Moose::Exporter;
use Moose::Util::MetaRole;

Moose::Exporter->setup_import_methods(
    with_meta => [qw(register_events context_class)],
    also      => ['Moose'],
);

sub init_meta {
    shift;
    my %args = @_;

    Moose->init_meta(%args);
    Moose::Util::MetaRole::apply_metaroles(
        for             => $args{for_class},
        class_metaroles => { class => ['Obry::Meta::Trait::Class'] },
    );

    Moose::Util::MetaRole::apply_base_class_roles(
        for   => $args{for_class},
        roles => ['Obry::API::Event'],
    );

    return $args{for_class}->meta();
}

sub register_events       { shift->symbols( \@_ ) }
sub context_class { shift->context_class(@_) }

1;
__END__
