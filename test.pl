print "1..2\n";

use Convert::Recode qw(iso646no_to_latin1 latin1_to_iso646no);

print "not " unless iso646no_to_latin1("v}re norske tegn b|r {res") eq
                                       "v�re norske tegn b�r �res";
print "ok 1\n";

print "not " unless latin1_to_iso646no("������") eq "[\\]{|}";
print "ok 2\n";
