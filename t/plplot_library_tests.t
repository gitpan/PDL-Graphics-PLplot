# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

use PDL;
use PDL::Config;
use PDL::Graphics::PLplot;
use Test::More;

######################### End of black magic.

# These tests are taken from the plplot distribution.  The reference results
# are also from the plplot distribution--they are the results of running
# the C language test suite.  D. Hunt May 6, 2011

# Determine if we are running these tests from the build directory
# or the 't' directory.
my $cwd = '.';
my @scripts = glob ("./x??.pl");
unless (@scripts) {
  @scripts = glob ("./t/x??.pl");
  $cwd = 't';
}

my $maindir = '..' if (-s "../OPTIONS!");
   $maindir = '.'  if (-s "./OPTIONS!");
open (OPT, "$maindir/OPTIONS!");
my @opts = <OPT>;
close OPT;

my $pllegend = 1;
$pllegend = 0 if (grep /NOPLLEGEND!/, @opts);

if ($pllegend) {
  plan qw(no_plan);
} else {
  plan skip_all => 'pllegend not found--plplot version not recent enough';
}



foreach my $plplot_test_script (@scripts) {
  my ($num) = ($plplot_test_script =~ /x(\d\d)\.pl/);
  system "$plplot_test_script -dev svg -o x${num}p.svg -fam";
  ok ($? == 0, "Script $plplot_test_script ran successfully");
  my @output = glob ("x${num}p.svg*");
  foreach my $outfile (@output) {
    (my $reffile = $outfile) =~ s/x(\d\d)p/x${1}c/;
    my $perldata = do { local( @ARGV, $/ ) = $outfile; <> } ; # slurp!
    my $refdata  = do { local( @ARGV, $/ ) = "$cwd/ref_svg_c_output/$reffile"; <> } ; # slurp!
    ok ($perldata eq $refdata, "Output file $outfile matches reference C output");
  }
}


# comment this out for testing!!!
unlink glob ("x??p.svg.*");

# Local Variables:
# mode: cperl
# End:
