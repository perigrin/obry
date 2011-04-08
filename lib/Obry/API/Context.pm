package Obry::API::Context;
use Moose::Role;
use namespace::autoclean;

requires qw(
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
);


1;
__END__