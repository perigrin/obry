package Obry::Constants;
use strict;
use Sub::Exporter -setup => {
    exports => [
        qw(
          OK
          DECLINE
          DONE
          OUTPUT
          SERVER_ERROR
          HANDLER_ERROR
          QUEUE_ERROR
          )
    ],
};

sub OK            { 'OK' }
sub DECLINE       { 'DECLINE' }
sub DONE          { 'DONE' }
sub OUTPUT        { 'OUTPUT' }
sub SERVER_ERROR  { 'SERVER_ERROR' }
sub HANDLER_ERROR { 'HANDLER_ERROR' }
sub QUEUE_ERROR   { 'QUEUE_ERROR' }

1;
__END__
