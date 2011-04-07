package Obry::Event;
use Moose();
use Moose::Exporter;

Moose::Exporter->setup_import_methods(
    with_meta        => ['symbols'],
    base_class_roles => ['Obry::Event::API'],
    class_metaroles  => { class => ['Obry::Meta::Trait::Class'] },
    also             => ['Moose'],
);

sub symbols { shift->symbols( \@_ ) }

1;
__END__
