=head1 NAME

  PDL::Graphics::PLplotOO - Object-oriented interface from perl/PDL to the PLPLOT plotting library

=head1 SYNOPSIS

  use PDL;
  use PDL::Graphics::PLplotOO;

  my $pl = PDL::Graphics::PLplotOO->new (DEV => "png", FILE => "test.png");
  my $x  = sequence(10);
  my $y  = $x**2;
  $pl->line($x, $y);
  $pl->close;

For more information on PLplot, see

 http://plplot.sourceforge.net

Also see the test file, test.pl in this distribution for some working examples.

=head1 DESCRIPTION

This is the PDL interface to the PLplot graphics library.  It is
designed to be simple and light weight with a familiar 'perlish'
Object Oriented interface.

=head1 OPTIONS

The following options are supported.  Most options can be used
with any function.  A few are only supported on the call to 'new'.

=head2 Options used upon creation of a PLplot object (with 'new'):

=head2 BACKGROUND

Set the color for index 0, the plot background

=head2 DEV

Set the output device type.  To see a list of allowed types, try:

  PDL::Graphics::PLplotOO->new();

=for example

   PDL::Graphics::PLplotOO->new(DEV => 'png', FILE => 'test.png');

=head2 FILE

Set the output file or display.  For file output devices, sets
the output file name.  For graphical displays (like 'xwin') sets
the name of the display, eg ('hostname.foobar.com:0')

=for example

   PDL::Graphics::PLplotOO->new(DEV => 'png',  FILE => 'test.png');
   PDL::Graphics::PLplotOO->new(DEV => 'xwin', FILE => ':0');

=head2 FRAMECOLOR

Set color index 1, the frame color

=head2 JUST

A flag used to specify equal scale on the axes.  If this is
not specified, the default is to scale the axes to fit best on
the page.

=for example

  PDL::Graphics::PLplotOO->new(DEV => 'png',  FILE => 'test.png', JUST => 1);

=head2 PAGESIZE

Set the size in pixels of the output page.

=for example

  # PNG 500 by 600 pixels
  PDL::Graphics::PLplotOO->new(DEV => 'png',  FILE => 'test.png', PAGESIZE => [500,600]);

=head2 SUBPAGES

Set the number of sub pages in the plot, [$nx, $ny]

=for example

  # PNG 300 by 600 pixels
  # Two subpages stacked on top of one another.
  PDL::Graphics::PLplotOO->new(DEV => 'png',  FILE => 'test.png', PAGESIZE => [300,600], 
                                              SUBPAGES => [1,2]);
=head2 Options used after initialization (after 'new')

=head2 BOX

Set the plotting box in world coordinates.  Used to explicitly
set the size of the plotting area.

=for example

 my $pl = PDL::Graphics::PLplotOO->new(DEV => 'png',  FILE => 'test.png');
 $pl->xyplot ($x, $y, BOX => [0,100,0,200]);

=head2 CHARSIZE

Set the size of text in multiples of the default size.  CHARSIZE => 1.5
gives characters %150 the normal size.

=head2 COLOR

Set the current color for plotting and character drawing.
Colors are specified not as color indices but as RGB triples.
Some pre-defined triples are included:

  BLACK        GREEN        WHEAT        BLUE       
  RED          AQUAMARINE   GREY         BLUEVIOLET 
  YELLOW       PINK         BROWN        CYAN       
  TURQUOISE    MAGENTA      SALMON       WHITE      

=for example

 # These two are equivalent:
 $pl->xyplot ($x, $y, COLOR => 'YELLOW');
 $pl->xyplot ($x, $y, COLOR => [0,255,0]);

=head2 LINEWIDTH

Set the line width for plotting.  Values range from 1 to a device dependent maximum.

=head2 PALETTE

Load pre-defined color map 1 color ranges.  Currently, values include:

  RAINBOW   -- from Red to Violet through the spectrum
  GREYSCALE -- from black to white via grey.

=for example

 # Plot x/y points with the z axis in color
 $pl->xyplot ($x, $y, PALETTE => 'RAINBOW', PLOTTYPE => 'POINTS', COLORMAP => $z);
 
=head2 PLOTTYPE

Specify which type of XY plot is desired:

  LINE       -- A line
  POINTS     -- A bunch of symbols
  LINEPOINTS -- both

=head2 SUBPAGE

Set which subpage to plot on.  Subpages are numbered 1 to N.  
A zero can be specified meaning 'advance to the next subpage' (just a call to pladv()).

=for example

  my $pl = PDL::Graphics::PLplotOO->new(DEV      => 'png',  
                                        FILE     => 'test.png', 
                                        SUBPAGES => [1,2]);
  $pl->xyplot ($x, $y, SUBPAGE => 1);
  $pl->xyplot ($a, $b, SUBPAGE => 2);


=head2 SYMBOL

Specify which symbol to use when plotting PLOTTYPE => 'POINTS'.
Special plotting symbols range from 0 to 31, 32 - 127 are ASCII characters.

=head2 SYMBOLSIZE

Specify the size of symbols plotted in multiples of the default size (1).
Value are real numbers from 0 to large.

=head2 TEXTPOSITION

Specify the placement of text.  Either relative to border, specified as:
 [$side, $disp, $pos, $just]

 Where side = 't', 'b', 'l', or 'r' for top, bottom, left and right
       disp is the number of character heights out from the edge
       pos  is the position along the edge of the viewport, from 0 to 1.
       just tells where the reference point of the string is: 0 = left, 1 = right, 0.5 = center.

or inside the plot window, specified as:
 [$x, $y, $dx, $dy, $just]

 Where:
  x  = x coordinate of reference point of string. 
  y  = y coordinate of reference point of string. 
  dx   Together with dy, this specifies the inclination of the string. 
       The baseline of the string is parallel to a line joining (x, y) to (x+dx, y+dy). 
  dy   Together with dx, this specifies the inclination of the string. 
  just Specifies the position of the string relative to its reference point. 
       If just=0, the reference point is at the left and if just=1, 
       it is at the right of the string. Other values of just give
       intermediate justifications.

=for example

 # Plot text on top of plot
 $pl->text ("Top label",  TEXTPOSITION => ['t', 4.0, 0.5, 0.5]);

 # Plot text in plotting area
 $pl->text ("Line label", TEXTPOSITION => [50, 60, 5, 5, 0.5]);

=head2 TITLE

Add a title on top of a plot.

=for example

 # Plot text on top of plot
 $pl->xyplot ($x, $y, TITLE => 'X vs. Y');

=head2 VIEWPORT

Set the location of the plotting window on the page.
Takes a four element array ref specifying:

 xmin The coordinate of the left-hand edge of the viewport. (0 to 1)
 xmax The coordinate of the right-hand edge of the viewport. (0 to 1)
 ymin The coordinate of the bottom edge of the viewport. (0 to 1)
 ymax The coordinate of the top edge of the viewport. (0 to 1)

=for example

 # Make a small plotting window in the lower left of the page
 $pl->xyplot ($x, $y, VIEWPORT => [0.1, 0.5, 0.1, 0.5]);

 # Also useful in creating color keys:
 $pl->xyplot   ($x, $y, PALETTE => 'RAINBOW', PLOTTYPE => 'POINTS', COLORMAP => $z);
 $pl->colorkey ($z, 'v', VIEWPORT => [0.93, 0.96, 0.15, 0.85]);

=head2 XBOX

Specify how to label the X axis of the plot as a string of option letters:

  a: Draws axis, X-axis is horizontal line (y=0), and Y-axis is vertical line (x=0). 
  b: Draws bottom (X) or left (Y) edge of frame. 
  c: Draws top (X) or right (Y) edge of frame. 
  f: Always use fixed point numeric labels. 
  g: Draws a grid at the major tick interval. 
  h: Draws a grid at the minor tick interval. 
  i: Inverts tick marks, so they are drawn outwards, rather than inwards. 
  l: Labels axis logarithmically. This only affects the labels, not the data, 
     and so it is necessary to compute the logarithms of data points before 
     passing them to any of the drawing routines.
  m: Writes numeric labels at major tick intervals in the 
     unconventional location (above box for X, right of box for Y). 
  n: Writes numeric labels at major tick intervals in the conventional location 
     (below box for X, left of box for Y). 
  s: Enables subticks between major ticks, only valid if t is also specified.
  t: Draws major ticks.

The default is 'BCNST' which draws lines around the plot, draws major and minor
ticks and labels major ticks.

=for example

 # plot two lines in a box with independent X axes labeled
 # differently on top and bottom
$pl->xyplot($x1, $y, XBOX  => 'bnst',  # bottom line, bottom numbers, ticks, subticks
	             YBOX  => 'bnst'); # left line, left numbers, ticks, subticks
$pl->xyplot($x2, $y, XBOX => 'cmst', # top line, top numbers, ticks, subticks
	             YBOX => 'cst',  # right line, ticks, subticks
	             BOX => [$x2->minmax, $y->minmax]);


=head2 YBOX

Specify how to label the Y axis of the plot as a string of option letters.
See XBOX.

=head2 YLAB

Specify a label for the Y axis.

=head2 XLAB

Specify a label for the X axis.

=head1 FUNCTIONS

=head2 new

=for ref

Create an object representing a plot.

=for usage

 Arguments:
 none.

 Supported options:
 BACKGROUND
 DEV
 FILE
 FRAMECOLOR
 JUST
 PAGESIZE
 SUBPAGES

=for example

  my $pl = PDL::Graphics::PLplotOO->new(DEV => 'png',  FILE => 'test.png');


=head2 set

=for ref

Set options for a plot object.

=for usage

 Arguments:
 none.

 Supported options:
 All options except:

 BACKGROUND
 DEV
 FILE
 FRAMECOLOR
 JUST
 PAGESIZE
 SUBPAGES

 (These must be set in call to 'new'.)

=for example

  $pl->set (TEXTSIZE => 2);

=head2 xyplot

=for ref

Plot XY lines and/or points.  Also supports color scales for points.
This function works with bad values.  If a bad value is specified for
a points plot, it is omitted.  If a bad value is specified for a line
plot, the bad value makes a gap in the line.  This is useful for
drawing maps--$x and $y can be continent boundary lat and lon, for
example.

=for usage

 Arguments:
 $x, $y

 Supported options:
 All options except:

 BACKGROUND
 DEV
 FILE
 FRAMECOLOR
 JUST
 PAGESIZE
 SUBPAGES

 (These must be set in call to 'new'.)

=for example

  $pl->xyplot($x, $y, PLOTTYPE => 'POINTS', COLOR => 'BLUEVIOLET', SYMBOL => 1, SYMBOLSIZE => 4);
  $pl->xyplot($x, $y, PLOTTYPE => 'LINEPOINTS', COLOR => [50,230,30]);
  $pl->xyplot($x, $y, PALETTE => 'RAINBOW', PLOTTYPE => 'POINTS', COLORMAP => $z);


=head2 colorkey

=for ref

Plot a color key showing which color represents which value

=for usage

 Arguments:
 $range   : A PDL which tells the range of the color values
 $orientation : 'v' for vertical color key, 'h' for horizontal

 Supported options:
 All options except:

 BACKGROUND
 DEV
 FILE
 FRAMECOLOR
 JUST
 PAGESIZE
 SUBPAGES

 (These must be set in call to 'new'.)

=for example

  # Plot X vs. Y with Z shown by the color.  Then plot
  # vertical key to the right of the original plot.
  $pl->xyplot ($x, $y, PALETTE => 'RAINBOW', PLOTTYPE => 'POINTS', COLORMAP => $z);
  $pl->colorkey ($z, 'v', VIEWPORT => [0.93, 0.96, 0.15, 0.85]);


=head2 shadeplot

=for ref

Create a shaded contour plot of 2D PDL 'z' with 'nsteps' contour levels.
Linear scaling is used to map the coordinates of Z(Y, X) to world coordinates
via the BOX option.

=for usage

 Arguments:
 $z : A 2D PDL which contains surface values at each XY coordinate.
      This PDL is stored in Y, X order, as this is how the C code of PLplot requires it.
 $nsteps : The number of contour levels requested for the plot.

 Supported options:
 All options except:

 BACKGROUND
 DEV
 FILE
 FRAMECOLOR
 JUST
 PAGESIZE
 SUBPAGES

 (These must be set in call to 'new'.)

=for example

  # vertical key to the right of the original plot.
  # The BOX must be specified to give real coordinate values to the $z array.
  $pl->shadeplot ($z, $nsteps, BOX => [-1, 1, -1, 1], PALETTE => 'RAINBOW'); 
  $pl->colorkey  ($z, 'v', VIEWPORT => [0.93, 0.96, 0.15, 0.85]);

=head2 close

=for ref

Close a PLplot object, writing out the file and cleaning up.

=for usage

Arguments:
None

Returns:
Nothing

This closing of the PLplot object can be done explicitly though the
'close' method.  Alternatively, a DESTROY block does an automatic
close whenever the PLplot object passes out of scope.

=for example

  $pl->close;

=head1 AUTHOR

Doug Hunt, dhunt\@ucar.edu.

=head1 SEE ALSO

perl(1), PDL(1), http://plplot.sourceforge.net/

=cut

package PDL::Graphics::PLplotOO;
$VERSION = '0.12';

# pull in low level interface
use PDL::Graphics::PLplot;
use vars qw(%_constants %_actions);

# Colors (from rgb.txt) are stored as RGB triples
# with each value from 0-255
%_constants = (
	       BLACK      => [  0,  0,  0],
	       RED        => [240, 50, 50],
	       YELLOW     => [  0,120,120],
	       GREEN      => [  0,255,  0],
	       AQUAMARINE => [127,255,212],
	       PINK       => [255,192,203],
	       WHEAT      => [245,222,179],
	       GREY       => [190,190,190],
	       BROWN      => [165, 42, 42],
	       BLUE       => [  0,  0,255],
	       BLUEVIOLET => [138, 43,226],
	       CYAN       => [  0,255,255],
	       TURQUOISE  => [ 64,224,208],
	       MAGENTA    => [255,  0,255],
	       SALMON     => [250,128,114],
	       WHITE      => [255,255,255],
	      );

# a hash of subroutines to invoke when certain keywords are specified
# These are called with arg(0) = $self (the plot object)
#                   and arg(1) = value specified for keyword
%_actions =
  (


   # Set color for index 0, the plot background
   BACKGROUND => sub {
     my $self  = shift;
     my $color = _color(shift);
     $self->{COLORS}[0] = $color;
     plscolbg (@$color);
   },

   # set plotting box in world coordinates
   BOX        => sub { 
     my $self  = shift;
     my $box   = shift;
     die "Box must be a ref to a four element array" unless (ref($box) =~ /ARRAY/ and @$box == 4);
     $self->{BOX} = $box;
   },

   CHARSIZE   => sub { plschr   (0, $_[1]) },  # 0 - N

   COLOR =>
   # maintain color map, set to specified rgb triple
   sub {
     my $self  = shift;
     my $color = _color(shift);
     
     my @idx = @{$self->{COLORS}}; # map of color index (0-15) to RGB triples
     my $found = 0;
     for (my $i=0;$i<@idx;$i++) {
       if (_coloreq ($color, $idx[$i])) {
	 $self->{CURRENT_COLOR_IDX} = $i;
	 $found = 1;
	 plscol0 ($self->{CURRENT_COLOR_IDX}, @$color);
       }
     }
     return if ($found);
     
     die "Too many colors used! (max 15)" if (@{$self->{COLORS}} > 14);
     push (@{$self->{COLORS}}, $color);
     $self->{CURRENT_COLOR_IDX} = @{$self->{COLORS}} - 1;
     plscol0 ($self->{CURRENT_COLOR_IDX}, @$color);
   },

   # set output device type
   DEV        => sub { plsdev   ($_[1]) },   # this must be specified with call to new!

   # set output file
   FILE       => sub { plsfnam  ($_[1]) },   # this must be specified with call to new!

   # set color for index 1, the plot frame and text
   FRAMECOLOR =>
   # set color index 1, the frame color
   sub {
     my $self  = shift;
     my $color = _color(shift);
     $self->{COLORS}[0] = $color;
     plscol0 (1, @$color);
   },

   # Set flag for equal scale axes
   JUST => sub {
     my $self  = shift;
     my $just  = shift;
     die "JUST must be 0 or 1 (defaults to 0)" unless ($just == 0 or $just == 1);
     $self->{JUST} = $just;
   },

   LINEWIDTH  => sub { plwid    ($_[1]) },

   # set driver options, example for ps driver, {text => 1} is accepted
   OPTS => sub {
     my $self = shift;
     my $opts = shift;

     foreach my $opt (keys %$opts) {
       plsetopt ($opt, $$opts{$opt});
     }
   },

   PAGESIZE   =>
     # set plot size in mm.  Only useful in call to 'new'
     sub { 
       my $self = shift;
       my $dims = shift;

       die "plot size must be a 2 element array ref:  X size in pixels, Y size in pixels"
	 if ((ref($dims) !~ /ARRAY/) || @$dims != 2);
       $self->{PAGESIZE} = $dims;
     },

   PALETTE =>

   # load some pre-done color map 1 setups
   # currently 'RAINBOW' and 'GREYSCALE'.
   sub {
     my $self = shift;
     my $pal  = shift;

     my %legal = (RAINBOW => 1, GREYSCALE => 1);
     if ($legal{$pal}) {
       $self->{PALETTE} = $pal;
       plscmap1n (128);  # set map 1 to 128 colors (should work for devices with 256 colors)
       if      ($pal eq 'RAINBOW') {
	 plscmap1l (0, 2, PDL->new(0,1), PDL->new(0,300), PDL->new(0.5, 0.5), PDL->new(1,1), PDL->new(0));
       } elsif ($pal eq 'GREYSCALE') {
	 plscmap1l (0, 2, PDL->new(0,1), PDL->new(0,0), PDL->new(0,1), PDL->new(0,0), PDL->new(0));
       }
     } else {
       die "Illegal palette name.  Legal names are: " . join (" ", keys %legal);
     }
   },

   PLOTTYPE =>
   # specify plot type (LINE, POINTS, LINEPOINTS)
   sub {
     my $self = shift;
     my $val  = shift;
     
     my %legal = (LINE => 1, POINTS => 1, LINEPOINTS => 1);
     if ($legal{$val}) {
       $self->{PLOTTYPE} = $val;
     } else {
       die "Illegal plot type.  Legal options are: " . join (" ", keys %legal);
     }
   },

   SUBPAGE =>
   # specify which subpage to plot on 1-N or 0 (meaning 'next')
   sub {
     my $self = shift;
     my $val  = shift;
     my $err  = "SUBPAGE = \$npage where \$npage = 1-N or 0 (for 'next subpage')";
     if ($val >= 0) {
       $self->{SUBPAGE} = $val;
     } else {
       die $err;
     }
   },

   SUBPAGES =>
   # specify number of sub pages [nx, ny]
   sub {
     my $self = shift;
     my $val  = shift;
     my $err  = "SUBPAGES = [\$nx, \$ny] where \$nx and \$ny are between 1 and 127";
     if (ref($val) =~ /ARRAY/ and @$val == 2) {
       my ($nx, $ny) = @$val;
       if ($nx > 0 and $nx < 128 and $ny > 0 and $ny < 128) {
	 $self->{SUBPAGES} = [$nx, $ny];
       } else {
	 die $err;
       }
     } else {
       die $err;
     }
   },

   SYMBOL =>
   # specify type of symbol to plot
   sub {
     my $self = shift;
     my $val  = shift;
     
     if ($val > 0 && $val < 128) {
       $self->{SYMBOL} = $val;
     } else {
       die "Illegal symbol number.  Legal symbols are between 1 and 127";
     }
   },

   SYMBOLSIZE => sub { 
     my ($self, $size) = @_;
     die "symbol size must be a real number from 0 to (large)" unless ($size >= 0);
     $self->{SYMBOLSIZE} = $size;
   },

   TEXTPOSITION =>
   # specify placement of text.  Either relative to border, specified as:
   # [$side, $disp, $pos, $just]
   # or
   # inside plot window, specified as:
   # [$x, $y, $dx, $dy, $just] (see POD doc for details)
   sub {
     my $self = shift;
     my $val  = shift;
     
     die "TEXTPOSITION value must be an array ref with either:
          [$side, $disp, $pos, $just] or [$x, $y, $dx, $dy, $just]" 
       unless ((ref($val) =~ /ARRAY/) and ((@$val == 4) || (@$val == 5)));

     if (@$val == 4) {
       $self->{TEXTMODE} = 'border';
     } else {
       $self->{TEXTMODE} = 'plot';
     }
     $self->{TEXTPOSITION} = $val;
   },

   # draw a title for the graph
   TITLE      => sub {
     my $self = shift;
     my $text = shift;
     plcol0  (1); # set to frame color
     plmtex   (4, 0.5, 0.5, 't', $text);
     plcol0  ($self->{CURRENT_COLOR_IDX}); # set back
   },

   # set the location of the plotting window on the page
   VIEWPORT => sub { 
     my $self  = shift;
     my $vp    = shift;
     die "Viewport must be a ref to a four element array"
       unless (ref($vp) =~ /ARRAY/ and @$vp == 4);
     $self->{VIEWPORT} = $vp;
   },

   XBOX       =>
     # set X axis label options.  See pod for definitions.
     sub { 
       my $self = shift;
       my $opts = lc shift;

       my @opts = split '', $opts;
       map { 'abcfghilmnst' =~ /$_/i || die "Illegal option $_.  Only abcfghilmnst permitted" } @opts;

       $self->{XBOX} = $opts;
     },

   # draw an X axis label for the graph
   XLAB       => sub {
     my $self = shift;
     my $text = shift;
     plcol0  (1); # set to frame color
     plmtex   (3.5, 0.5, 0.5, 'b', $text);
     plcol0  ($self->{CURRENT_COLOR_IDX}); # set back
   },

   YBOX       =>
     # set Y axis label options.  See pod for definitions.
     sub { 
       my $self = shift;
       my $opts = shift;

       my @opts = split '', $opts;
       map { 'abcfghilmnstv' =~ /$_/i || die "Illegal option $_.  Only abcfghilmnstv permitted" } @opts;

       $self->{YBOX} = $opts;
     },

   # draw an Y axis label for the graph
   YLAB       => sub {
     my $self = shift;
     my $text = shift;
     plcol0  (1); # set to frame color
     plmtex   (3.5, 0.5, 0.5, 'l', $text);
     plcol0  ($self->{CURRENT_COLOR_IDX}); # set back
   },

);


#
## Internal utility routines
#

# handle color as string in _constants hash or [r,g,b] triple
# Input:  either color name or [r,g,b] array ref
# Output: [r,g,b] array ref or exception
sub _color {
  my $c = shift;
  if      (ref($c) =~ /ARRAY/) {
    return $c;
  } elsif ($c = $_constants{$c}) {
    return $c;
  } else {
    die "Color $c not defined";
  }
}

# return 1 if input [r,g,b] triples are equal.
sub _coloreq { 
  my ($a, $b) = @_;
  for (my $i=0;$i<3;$i++) { return 0 if ($$a[$i] != $$b[$i]); }
  return 1;
}

# Initialize plotting window given the world coordinate box and
# a 'justify' flag (for equal axis scales).
sub _setwindow {

  my $self = shift;

  # choose correct subwindow
  pladv ($self->{SUBPAGE}) if (exists ($self->{SUBPAGE}));
  delete ($self->{SUBPAGE});  # get rid of SUBPAGE so future plots will stay on same
                              # page unless user asks for specific page

  my $box  = $self->{BOX} || [0,1,0,1]; # default window

  sub MAX { ($_[0] > $_[1]) ? $_[0] : $_[1]; }

  # get subpage offsets from page left/bottom of image
  my ($spxmin, $spxmax, $spymin, $spymax) = (PDL->new(0),PDL->new(0),PDL->new(0),PDL->new(0));
  plgspa($spxmin, $spxmax, $spymin, $spymax);
  $spxmin = $spxmin->at(0);
  $spxmax = $spxmax->at(0);
  $spymin = $spymin->at(0);
  $spymax = $spymax->at(0);
  my $xsize = $spxmax - $spxmin;
  my $ysize = $spymax - $spymin;

  my @vp = @{$self->{VIEWPORT}};  # view port xmin, xmax, ymin, ymax in fraction of image size

  # if JUSTify is zero, set to the user specified (or default) VIEWPORT
  if ($self->{JUST} == 0) {
    plvpor(@vp);

  # compute viewport to allow the same scales for both axes
  } else {
    my $p_def = PDL->new(0);
    my $p_ht  = PDL->new(0);
    plgchr ($p_def, $p_ht);
    $p_def = $p_def->at(0);
    my $lb = 8.0 * $p_def;
    my $rb = 5.0 * $p_def;
    my $tb = 5.0 * $p_def;
    my $bb = 5.0 * $p_def;
    my $dx = $$box[1] - $$box[0];
    my $dy = $$box[3] - $$box[2];
    my $xscale = $dx / ($xsize - $lb - $rb);
    my $yscale = $dy / ($ysize - $tb - $bb);
    my $scale  = MAX($xscale, $yscale);
    my $vpxmin = MAX($lb, 0.5 * ($xsize - $dx / $scale));
    my $vpxmax = $vpxmin + ($dx / $scale);
    my $vpymin = MAX($bb, 0.5 * ($ysize - $dy / $scale));
    my $vpymax = $vpymin + ($dy / $scale);
    plsvpa($vpxmin, $vpxmax, $vpymin, $vpymax);
    $self->{VIEWPORT} = [$vpxmin/$xsize, $vpxmax/$xsize, $vpymin/$ysize, $vpymax/$ysize];
  }

  # set up world coords in window
  plwind (@$box);

}

#
## user-visible routines
#

# This routine starts out a plot.  Generally one specifies
# DEV and FILE (device and output file name) as options.
sub new {
  my $type = shift;
  my $self = {};

  # set up object
  $self->{PLOTTYPE} = 'LINE';
  # $self->{CURRENT_COLOR_IDX} = 1;

  # set defaults, allow input options to override
  my %opts = (COLOR      => 'BLACK',
	      BACKGROUND => 'WHITE',
	      FRAMECOLOR => 'BLACK',
	      XBOX       => 'BCNST',
	      YBOX       => 'BCNST',
	      JUST       => 0,
	      SUBPAGES   => [1,1],
	      VIEWPORT   => [0.1, 0.87, 0.1, 0.85],
	      SUBPAGE    => 0,
	      PAGESIZE   => [600, 500],
	      @_);


  bless $self, $type;

  # apply options
  $self->setparm(%opts);

  # Do initial setup
  plspage (0, 0, @{$self->{PAGESIZE}}, 0, 0) if (defined($self->{PAGESIZE}));
  plssub (@{$self->{SUBPAGES}});
  plinit ();

  # set up plotting box
  $self->_setwindow;

  return $self;
}

# set parameters.  Called from user directly or from other routines.
sub setparm {
  my $self = shift;

  my %opts = @_;

  # apply all options
 OPTION:
  foreach my $o (keys %opts) {
    unless (exists($_actions{$o})) {
      warn "Illegal option $o, ignoring";
      next OPTION;
    }
    &{$_actions{$o}}($self, $opts{$o});
  }
}

# handle 2D plots
sub xyplot {
  my $self = shift;
  my $x    = shift;
  my $y    = shift;

  my %opts = @_;

  # only process COLORMAP entries once
  my $z = $opts{COLORMAP};
  delete ($opts{COLORMAP});

  # apply options
  $self->setparm(%opts);

  unless (exists($self->{BOX})) {
    $self->{BOX} = [$x->minmax, $y->minmax];
  }

  # set up viewport, subpage, world coordinates
  $self->_setwindow;

  # plot box
  plcol0  (1); # set to frame color
  plbox (0, 0, 0, 0, $self->{XBOX}, $self->{YBOX}); # !!! note out of order call

  # set the color according to the color specified in the object
  # (we don't do this as an option, because then the frame might
  # get the color requested for the line/points
  plcol0  ($self->{CURRENT_COLOR_IDX});

  # Plot lines if requested
  if  ($self->{PLOTTYPE} =~ /LINE/) {
    plline ($x, $y);
  }

  # plot points if requested
  if ($self->{PLOTTYPE} =~ /POINTS/) {
    my $c = $self->{SYMBOL};
    unless (defined($c)) {

      # the default for $c is a PDL of ones with shape
      # equal to $x with the first dimension removed
      my $z = PDL->zeroes($x->nelem);
      $c = PDL->ones($z->zcover) unless defined($c);
    }
    plssym   (0, $self->{SYMBOLSIZE}) if (defined($self->{SYMBOLSIZE}));


    if (defined($z)) {  # if a color range plot requested
      plcolorpoints ($x, $y, $z, $c);
    } else {
      plpoin ($x->nelem, $x, $y, $c);
    }
  }

}


# Draw a color key or wedge showing the scale of map1 colors
sub colorkey {
  my $self = shift;
  my $var  = shift;
  my $orientation = shift; # 'v' (for vertical) or 'h' (for horizontal)

  my %opts = @_;

  # apply options
  $self->setparm(%opts);

  # set up viewport, subpage, world coordinates
  $self->_setwindow;

  my @box;

  plcol0  (1); # set to frame color

  # plot box
  if      ($orientation eq 'v') {
    # set world coordinates based on input variable
    @box = (0, 1, $var->minmax);
    plwind (@box);
    plbox (0, 0, 0, 0, '', 'TM');  # !!! note out of order call
  } elsif ($orientation eq 'h') {
    @box = ($var->minmax, 0, 1);
    plwind (@box);
    plbox (0, 0, 0, 0, 'TM', '');  # !!! note out of order call
  } else {
    die "Illegal orientation value: $orientation.  Should be 'v' (vertical) or 'h' (horizontal)";
  }

  # restore color setting
  plcol0  ($self->{CURRENT_COLOR_IDX});

  my $ncols = 128;  # set when PALETTE set
  if ($orientation eq 'v') {
    my $yinc = ($box[3] - $box[2])/$ncols;
    my $y0 = $box[2];
    for (my $i=0;$i<$ncols;$i++) {
      $y0 = $box[2] + ($i * $yinc);
      my $y1 = $y0 + $yinc;
      PDL::Graphics::PLplot::plcol1($i/$ncols);
      PDL::Graphics::PLplot::plfill (4, PDL->new($box[0],$box[1],$box[1],$box[0]),
				        PDL->new($y0,$y0,$y1,$y1));
    }
  } else {
    my $xinc = ($box[1] - $box[0])/$ncols;
    my $x0 = $box[0];
    for (my $i=0;$i<$ncols;$i++) {
      $x0 = $box[0] + ($i * $xinc);
      my $x1 = $x0 + $xinc;
      PDL::Graphics::PLplot::plcol1($i/$ncols);
      PDL::Graphics::PLplot::plfill (4, PDL->new($x0,$x0,$x1,$x1),
				        PDL->new($box[2],$box[3],$box[3],$box[2]));
    }
  }
}

# handle shade plots of gridded (2D) data
sub shadeplot {
  my $self   = shift;
  my $z      = shift;
  my $nsteps = shift;

  my %opts = @_;

  # apply options
  $self->setparm(%opts);

  my ($ny, $nx) = $z->dims;

  unless (exists($self->{BOX})) {
    $self->{BOX} = [0, $nx, 0, $ny];
  }

  # set up plotting box
  $self->_setwindow;

  # plot box
  plcol0  (1); # set to frame color
  plbox (0, 0, 0, 0, $self->{XBOX}, $self->{YBOX}); # !!! note out of order call

  my ($min, $max) = $z->minmax;
  my $clevel = ((PDL->sequence($nsteps)*(($max - $min)/($nsteps-1))) + $min);

  # may add as options later.  Now use constants
  my $fill_width = 2;
  my $cont_color = 0;
  my $cont_width = 0;

  my $rectangular = 1; # only false for non-linear coord mapping (not done yet in perl)

  # map X coords linearly to X range, Y coords linearly to Y range
  my $xmap = ((PDL->sequence($nx)*(($self->{BOX}[1] - $self->{BOX}[0])/($nx - 1))) + $self->{BOX}[0]); 
  my $ymap = ((PDL->sequence($ny)*(($self->{BOX}[3] - $self->{BOX}[2])/($ny - 1))) + $self->{BOX}[2]); 

  plshades($z, @{$self->{BOX}}, $clevel, $fill_width,
           $cont_color, $cont_width, $rectangular, $xmap, $ymap);
}

# handle histograms
sub histogram {
  my $self   = shift;
  my $x      = shift;
  my $nbins  = shift;

  my %opts = @_;

  # apply options
  $self->setparm(%opts);

  my ($min, $max) = $x->minmax;

  unless (exists($self->{BOX})) {
    $self->{BOX} = [$min, $max, 0, $x->nelem]; # box probably too tall!
  }

  # set up plotting box
  $self->_setwindow;

  # plot box
  plcol0  (1); # set to frame color
  plbox (0, 0, 0, 0, $self->{XBOX}, $self->{YBOX}); # !!! note out of order call

  plhist ($x->nelem, $x, $min, $max, $nbins, 1);  # '1' is oldbins parm:  dont call plenv!
}


# Add text to a plot
sub text {
  my $self = shift;
  my $text = shift;

  # apply options
  $self->setparm(@_);

  # set the color according to the color specified in the object
  plcol0  ($self->{CURRENT_COLOR_IDX});

  # plot either relative to border, or inside view port
  if      ($self->{TEXTMODE} eq 'border') {
    my ($side, $disp, $pos, $just) = @{$self->{TEXTPOSITION}};
    plmtex ($disp, $pos, $just, $side, $text); # !!! out of order parms
  } elsif ($self->{TEXTMODE} eq 'plot') {
    my ($x, $y, $dx, $dy, $just) = @{$self->{TEXTPOSITION}};
    plptex ($x, $y, $dx, $dy, $just, $text);
  }

}


# Explicitly close a plot and free the object
sub close {
  my $self = shift;
  plend ();
  return;
}

# Close a plot when the object passes out of scope
sub DESTROY {
  my $self = shift;
  # print "Destroying $self\n";
  $self->close;
}


# Exit with OK status

1;
