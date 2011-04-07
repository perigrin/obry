# Obry

A Simple API for Web Applications in Moose

## VERSION

This document describes Obry version 0.0.1

## SYNOPSIS

        package MyEventHandler
        use Moose;
        extends qw(Obry::Event);
    
        has '+symbols' => (
            default =>  sub { [ qw(event_foo event_bar) ]; }, 
        );

        sub event_foo {
            my ($self, $ctxt) = @_;
            $self->output('FOO!');
            return 'OK';
        }
    
        sub event_bar {
            my ($self, $ctxt) = @_;
            $self->output('Bar!');
            return 'OK';
        }

        package MyOutputHandler
        use Moose;
        extends qw(Obry::Event);
    
        has '+symbols' => (
            default => sub { [ qw( print_output )]}
        );

        sub print_output {
            my ($self, $ctxt) = @_;
            print $self->output;
            return 'OK';
        }

        package MyApp;
        use Obry;
        my $app = Obry->new();
        $opp->pipeline(qw(
            MyEventHandler
            MyOutputHandler
        ));
        $app->run();

## DESCRIPTION

Obry is an attempt to re-think the SAWA Web Framework. Obry is in no way
an attempt to replace SAWA, but is instead an experiemental
re-implementation of the idea with modern tools.

## DEPENDENCIES

* Moose
* MooseX::LogDispatch
* MooseX::Param
* Test::More

## AUTHOR

Chris Prather "<chris@prather.org>"

## LICENCE AND COPYRIGHT

Copyright (c) 2007, Chris Prather "<perigrin@cpan.org>". All rights
reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See perlartistic.

## DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE LIABLE
TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
DAMAGES.

