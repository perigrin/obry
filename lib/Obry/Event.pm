package Obry::Event;
use Moose();
use Moose::Exporter;
use Moose::Util::MetaRole;

Moose::Exporter->setup_import_methods(
    with_meta => ['symbols'],
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
        roles => ['Obry::Event::API'],
    );

    return $args{for_class}->meta();
}

sub symbols { shift->symbols( \@_ ) }

1;
__END__
