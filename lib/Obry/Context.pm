package Obry::Context::Plack;
use Moose;
use namespace::autoclean;
use Plack::Response;

has response => (
    isa     => 'Plack::Response',
    is      => 'ro',
    lazy    => 1,
    builder => '_build_response',
    handles => [
        qw(
          body
          content_encoding
          content_length
          content_type
          cookies
          header
          headers
          location
          redirect
          status
          )
    ],
);

sub _build_response { Plack::Response->new(200); }

sub output { shift->body(@_) }

1;
__END__
