# Makefile.PL for a package defined by PP code.

use PDL::Core::Dev;            # Pick up development utilities
use ExtUtils::MakeMaker;
use Config;


# 
## Search for plplot library and include file
#

foreach my $libdir (
                    '/usr/local/plplot/lib',
		    '/usr/local/lib',
		    '/opt/local/lib',
		    '/usr/lib',
		    '/opt/lib',
		    '/ops/tools/lib',
		                  # Add new library paths here!!
		    ) {

  if (-e "$libdir/libplplotd.a") {
    $plplot_lib_path = $libdir;
    print "Found libplplotd.a at $libdir/libplplot.a\n";
    last;
  }

  if (-e "$libdir/libplplotd.so") {
    $plplot_lib_path = $libdir;
    print "Found libplplotd.so at $libdir/libplplot.so\n";
    last;
  }


}

die "Cannot find plplot library (libplplotd.so).
Please add the correct library path to Makefile.PL or install PLplot and try again"
  unless defined ($plplot_lib_path);

foreach my $incdir (
                    '/usr/local/plplot/include',
                    '/usr/local/plplot/include/plplot',
		    '/usr/local/include/plplot',
		    '/usr/local/include',
		    '/opt/local/include',
		    '/usr/include',
		    '/opt/include',
		    '/ops/tools/include/plplot',
		    '/ops/tools/include',
		                  # Add new header paths here!!
		    ) {

  if (-e "$incdir/plplot.h") {
    $plplot_include_path = "-I$incdir";
    if ($incdir =~ m|/plplot$|) {
      $inc2 = $incdir;
      $inc2 =~ s|/plplot$||;
      $plplot_include_path .= " -I$inc2";
    }
    print "Found plplot.h at $incdir/plplot.h\n";
    print "Include switches: $plplot_include_path\n";
    last;
  }
}

die "Cannot find plplot header file, plplot.h.
Please add the correct library path to Makefile.PL or install Plplot" 
  unless defined ($plplot_include_path);

# Test that PLplot was compiled --with-double (IE, a PLFLT is a double)
my $size = compileAndRun ("$plplot_include_path", <<'EOC');
#include <plplot.h>
main () {  printf  ("%d", sizeof (PLFLT)); }
EOC

print "Test compile of plplot program reveals sizeof(PLFLT) = $size";
die "Sizeof(PLFLT) must be 8. PLplot must be compiled --with-double (IE ./configure --with-double)" unless ($size == 8);
print " (OK)\n";

# Try linking with library.  New if blocks should be added
my $libs;
print "Trying out different library combinations\n";
foreach my $l (
	       "-L$plplot_lib_path -lplplotd -lX11",
	       "-L$plplot_lib_path -lplplotd",
	       # New lib combinations should be added here!
	       ) {
  print "  $l: ";

  if (trylink( '', '#include <plplot.h>', 'plinit();', "$l $plplot_include_path")) {
    print "Yes.\n"; 
    $libs = $l;
    print "Succeeded linking with $libs\n";
    last;
  } else {
    print "No.\n"; 
  }
}
die "Cannot find good set of libraries for linking.  
If you can figure out a good combination for your machine, 
please add it to the 'library combination' block
in Makefile.PL and email me:  dhunt\@ucar.edu" unless (defined($libs));

$package = ["plplot.pd",PLplot,PDL::Graphics::PLplot];
WriteMakefile(
	      'NAME'  	     => 'PDL::Graphics::PLplot',
	      'CCFLAGS'      => "-g",
	      'VERSION_FROM' => 'PLplotOO.pm',
	      'TYPEMAPS'     => [&PDL_TYPEMAP()],
	      'OBJECT'       => 'PLplot.o ',
	      'PM'           => { 'PLplot.pm'   => '$(INST_LIBDIR)/PLplot.pm',
				  'PLplotOO.pm' => '$(INST_LIBDIR)/PLplotOO.pm'
				},
              'INC'          => &PDL_INCLUDE()." $plplot_include_path", 
              'LIBS'         => [$libs],  
	      'clean'        => {'FILES'  => 
				   'PLplot.pm PLplot.xs PLplot.o PLplot.c PLplot.bs'},
	      'dist'         => { COMPRESS => 'gzip', SUFFIX => 'gz' },	
	      );

sub MY::postamble { pdlpp_postamble($package); }	

sub compileAndRun {
 my $flags = shift;
 my $code  = shift;
 
 open (OUT, ">temp.c");
 print OUT $code;
 close OUT;

 my $cc = $Config{cc};
 my $ccflags = $Config{ccflags};
 print "Trying: $cc $ccflags $flags temp.c -o temp\n";
 system "$cc $ccflags $flags temp.c -o temp";
 die "Cannot compile test program: $code" unless (-e 'temp');
 return `./temp`;
}





