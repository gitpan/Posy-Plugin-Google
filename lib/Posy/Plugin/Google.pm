package Posy::Plugin::Google;

#
# $Id: Google.pm,v 1.2 2005/03/04 02:00:56 blair Exp $
#

use 5.008001;
use strict;
use warnings;

=head1 NAME

Posy::Plugin::Google - Provide Google "I'm Feeling Lucky" search links

=head1 VERSION

This document describes Posy::Plugin::Google version B<0.1>.

=cut

our $VERSION = '0.1';

=head1 SYNOPSIS

  @plugins = qw(
    Posy::Core
    ...
    Posy::Plugin::Google
  );
  @entry_actions = qw(header
    ...
    parse_entry
    google
    render_entry
    ...
  );

  And in one's entry files:

  {{google:Your Search Term(s) Here}}

=head1 DESCRIPTION

This module allows one to easily insert "I'm Feeling Lucky" searches
from Google in one's entry files.

=head1 INTERFACE

=head2 google()

  $self->google($flow_state, $current_entry, $entry_state)

Alters C<$current_entry->{body}> by adding Google "I'm Feeling Lucky"
search links wherever a properly formatted string is encountered in the
body.

=cut
sub google {
  my ($self, $flow_state, $current_entry, $entry_state) = @_;
  my $body = $current_entry->{body};
  # TODO The string should probably be configurable
  if ($body and ($body =~ m|{{google:(.+?)}}|)) {
    $body =~ s|{{google:(.+?)}}|_create_link($1)|ego; 
    $current_entry->{body} = $body;
  }
  1;
} # google()

sub _create_link {
  my $query = shift;
  my $rv = "";
  if ($query) {
    # Perform naive encoding
    if ($query =~ m|^"(.+?)"$|) {
      $query  = $1; # Should this be configurable?
      $rv     = "%22${1}%22";
    } elsif ($query =~ /\s/) {
      $rv = "%22${query}%22";
    } else {
      $rv = $query;
    }
    $rv =~ s|\s+|%20|g;
    $rv = '<a href="http://www.google.com/search?&q=' . 
          $rv . '&btnI=yes">' . $query . '</a>';
  }
  return $rv;
} # _create_link()

=head1 SEE ALSO

L<Perl>, L<Posy>

=head1 AUTHOR

blair christensen., E<lt>blair@devclue.comE<gt>

<http://devclue.com/blog/code/posy/Posy::Plugin::Google/>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by blair christensen.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 DISCLAIMER OF WARRANTY                                                                                               

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO
WARRANTY FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE
LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS
AND/OR OTHER PARTIES PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE
OF THE SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE,
YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA
BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES
OR A FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY
OF SUCH DAMAGES.

=cut

1;

