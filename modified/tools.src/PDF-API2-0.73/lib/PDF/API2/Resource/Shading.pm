#=======================================================================
#    ____  ____  _____              _    ____ ___   ____
#   |  _ \|  _ \|  ___|  _   _     / \  |  _ \_ _| |___ \
#   | |_) | | | | |_    (_) (_)   / _ \ | |_) | |    __) |
#   |  __/| |_| |  _|    _   _   / ___ \|  __/| |   / __/
#   |_|   |____/|_|     (_) (_) /_/   \_\_|  |___| |_____|
#
#   A Perl Module Chain to faciliate the Creation and Modification
#   of High-Quality "Portable Document Format (PDF)" Files.
#
#   Copyright 1999-2005 Alfred Reibenschuh <areibens@cpan.org>.
#
#=======================================================================
#
#   This library is free software; you can redistribute it and/or
#   modify it under the terms of the GNU Lesser General Public
#   License as published by the Free Software Foundation; either
#   version 2 of the License, or (at your option) any later version.
#
#   This library is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   Lesser General Public License for more details.
#
#   You should have received a copy of the GNU Lesser General Public
#   License along with this library; if not, write to the
#   Free Software Foundation, Inc., 59 Temple Place - Suite 330,
#   Boston, MA 02111-1307, USA.
#
#   $Id: Shading.pm,v 2.0 2005/11/16 02:16:04 areibens Exp $
#
#=======================================================================

package PDF::API2::Resource::Shading;

BEGIN {

    use strict;
    use vars qw(@ISA $VERSION);
    use PDF::API2::Resource;
    use PDF::API2::Basic::PDF::Utils;
    use PDF::API2::Util;
    use Math::Trig;

    @ISA = qw(PDF::API2::Resource);

    ( $VERSION ) = sprintf '%i.%03i', split(/\./,('$Revision: 2.0 $' =~ /Revision: (\S+)\s/)[0]); # $Date: 2005/11/16 02:16:04 $

}
no warnings qw[ deprecated recursion uninitialized ];

=item $cs = PDF::API2::Resource::Shading->new $pdf, $key, %parameters

Returns a new shading object. base class for all shadings.

=cut

sub new {
    my ($class,$pdf,$key,%opts)=@_;

    $class = ref $class if ref $class;
    $self=$class->SUPER::new($pdf,$key || pdfkey());
    $pdf->new_obj($self) unless($self->is_obj($pdf));
    $self->{' apipdf'}=$pdf;

#    $self->{ColorSpace}=PDFName($opts{-colorspace}||'DeviceRGB');
#
#    $sh->{ShadingType}=PDFNum(2);
#    $sh->{Coords}=PDFArray(PDFNum(0),PDFNum(0),PDFNum(1),PDFNum(1));
#    $sh->{Function}=PDFDict();
#    $sh->{Function}->{FunctionType}=PDFNum(2);
#    $sh->{Function}->{Domain}=PDFArray(PDFNum(0),PDFNum(1));
#    $sh->{Function}->{C0}=PDFArray(PDFNum(1),PDFNum(1),PDFNum(1));
#    $sh->{Function}->{C1}=PDFArray(PDFNum(0),PDFNum(0),PDFNum(1));
#    $sh->{Function}->{N}=PDFNum(1);

    return($self);
}

=item $cs = PDF::API2::Resource::Shading->new_api $api, $name

Returns a shading object. This method is different from 'new' that
it needs an PDF::API2-object rather than a Text::PDF::File-object.

=cut

sub new_api {
    my ($class,$api,@opts)=@_;

    my $obj=$class->new($api->{pdf},@opts);
    $self->{' api'}=$api;

    return($obj);
}

sub outobjdeep {
    my ($self, @opts) = @_;
    foreach my $k (qw/ api apipdf /) {
        $self->{" $k"}=undef;
        delete($self->{" $k"});
    }
    $self->SUPER::outobjdeep(@opts);
}

1;

__END__

=head1 AUTHOR

alfred reibenschuh

=head1 HISTORY

    $Log: Shading.pm,v $
    Revision 2.0  2005/11/16 02:16:04  areibens
    revision workaround for SF cvs import not to screw up CPAN

    Revision 1.2  2005/11/16 01:27:48  areibens
    genesis2

    Revision 1.1  2005/11/16 01:19:25  areibens
    genesis

    Revision 1.12  2005/06/17 19:44:03  fredo
    fixed CPAN modulefile versioning (again)

    Revision 1.11  2005/06/17 18:53:34  fredo
    fixed CPAN modulefile versioning (dislikes cvs)

    Revision 1.10  2005/03/14 22:01:06  fredo
    upd 2005

    Revision 1.9  2004/12/16 00:30:53  fredo
    added no warn for recursion

    Revision 1.8  2004/06/22 00:38:44  fredo
    fixed ISA

    Revision 1.7  2004/06/21 22:33:37  fredo
    added basic pattern/shading handling

    Revision 1.6  2004/06/15 09:14:41  fredo
    removed cr+lf

    Revision 1.5  2004/06/07 19:44:36  fredo
    cleaned out cr+lf for lf

    Revision 1.4  2003/12/08 13:05:33  Administrator
    corrected to proper licencing statement

    Revision 1.3  2003/11/30 17:28:55  Administrator
    merged into default

    Revision 1.2.2.1  2003/11/30 16:56:35  Administrator
    merged into default

    Revision 1.2  2003/11/30 11:44:49  Administrator
    added CVS id/log


=cut
