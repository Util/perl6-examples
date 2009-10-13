#
# p09 - Pack consecutive duplicates of list elements into sublists.
#
# Robert Eaglestone  22 sept 09
#
#   My first Perl6 script - I'm sure this can be done better
#
my @in = <a a a a b c c a a d e e e e>;

my @out = p09( @in );

@out.perl.say;


#
#  Here's where the work is done.
#
sub p09
{
   my @in = @_;
   my @out = [ @in.shift ];


   for @in -> $elem
   {
      push @out, [] if $elem ne @out[-1][0]; 
      push @out[-1], $elem;
   }
   return @out;
}
   
