package Obry::Event::Simple;
use Obry::Event;



before run => sub {
    shift->next_symbol()
}
1;
__END__
