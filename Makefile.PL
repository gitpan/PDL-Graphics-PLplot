# Makefile.PL for a package defined by PP code.

use PDL::Core::Dev;            # Pick up development utilities
use ExtUtils::MakeMaker;
use Config;

# 
## Search for plplot library and include file
#

foreach my $libdir (
		    '/usr/local/lib',
		    '/opt/local/lib',
		    '/usr/lib',
		    '/opt/lib',
		    '/ops/tools/lib',
		                  # Add new library paths here!!
		    ) {

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
    $plplot_include_path = $incdir;
    print "Found plplot.h at $incdir/plplot.h\n";
    last;
  }
}

die "Cannot find plplot header file, plplot.h.
Please add the correct library path to Makefile.PL or install Plplot" 
  unless defined ($plplot_include_path);

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
	      'INC'          => &PDL_INCLUDE()." -I$plplot_include_path", 
	      'LIBS'         => ["-L$plplot_lib_path -lplplotd "],  
	      'clean'        => {'FILES'  => 
				   'PLplot.pm PLplot.xs PLplot.o PLplot.c PLplot.bs'},
	      'dist'         => { COMPRESS => 'gzip', SUFFIX => 'gz' },	
	      );

sub MY::postamble { pdlpp_postamble($package); }	





