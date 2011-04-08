package Obry::Context::Simple;
use Moose;

has [
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
] => ( is => 'rw' );

with qw(Obry::API::Context);
1;
__END__
