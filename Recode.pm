package Convert::Recode;

use Carp;
use strict;

use vars qw($VERSION $DEBUG);
$VERSION = sprintf("%d.%02d", q$Revision$ =~ /(\d+)\.(\d+)/);


sub import
{
    my $class = shift;
    my $pkg = caller;

    my $subname;
    for $subname (@_) {
	unless ($subname =~ /^(\w+)_to_(\w+)/) {
	    croak("recode routine name must be on the form: xxx_to_yyy");
	}
	local(*RECODE, $_);
	open(RECODE, "recode -h $1:$2 2>/dev/null|") or die;
	my @codes;
	while (<RECODE>) {
	    push(@codes, /(\d+),/g);
	}
	close(RECODE);
	die "Can't recode $subname, 'recode -l' for available charsets\n"
	  unless @codes == 256;

	my $impl = 'sub { my $tmp = shift; $tmp =~ tr/\x00-\xFF/' .
	           join("", map sprintf("\\x%02X", $_), @codes) .
	           '/; $tmp }';
	print $impl if $DEBUG;
	my $sub = eval $impl;
	die if $@;
	no strict 'refs';
	*{$pkg . "::" . $subname} = $sub;
    }
}

1;

__END__

=head1 NAME

Convert::Recode - make mapping functions between character sets

=head1 SYNOPSIS

  use Convert::Recode qw(ebcdic_to_ascii);

  while (<>) {
     print ebcdic_to_ascii($_);
  }

=head1 DESCRIPTION

The Convert::Recode module can provide mapping functions between
character sets on demand.  It depends on GNU recode to provide the raw
mapping data, i.e. GNU recode must be installed first.  The names of
the mapping functions are found by taking the name of the two charsets
and then joining them with the string "_to_".  If you want to convert
between the "mac" and the "latin1" charsets, then you just import the
mac_to_latin1() function.

Running the command C<recode -l> should give you the list of character
sets available.

=head1 AUTHOR

© 1997 Gisle Aas.

=cut
