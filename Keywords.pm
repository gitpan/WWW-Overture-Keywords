# -*-cperl-*-
#
# WWW::Overture::Keywords - Query Overture keyword suggestion tool.
# Copyright (c) 2005 Ashish Gulhati <ashish at neomailbox.com>
#
# All rights reserved. This code is free software; you can
# redistribute it and/or modify it under the same terms as Perl
# itself.
#
# $Id: Keywords.pm,v 1.2 2005/07/25 09:48:00 hash Exp $

package WWW::Overture::Keywords;

use Carp qw(croak);
use LWP::UserAgent;
use vars qw( $VERSION $AUTOLOAD );

( $VERSION ) = '$Revision: 1.2 $' =~ /\s+([\d\.]+)/;

sub new {
  my $class = shift;
  my %par = @_;
  my $self;
  $self->{ua} = LWP::UserAgent->new(agent => $par{agent} ||
				    'Mozilla/4.0 (compatible; GoogleToolbar 2.0.111-big; Windows XP 5.1)')
    or return;
  $self->{ua}->proxy('http', $par{proxy}) if $par{proxy};
  $self->{mkt} = $par{mkt} || 'us';
  $self->{lang} = $par{mkt} || 'en_US';
  bless($self, $class);
}

sub get {
  my ($self, $keyword) = @_;
  return unless defined $keyword;
  my $query = "http://inventory.overture.com/d/searchinventory/suggestion/?term=$keyword&mkt=$self->{mkt}&lang=$self->{lang}";
  my $resp = $self->{ua}->get($query);
  if ($resp->is_success) {
    if (wantarray) {
      my @kw = $resp->{_content} =~ /size=1\>\&nbsp\;(\d+)\<\/td\>.+?size=1 color=#000000>([^\<]+)/sg;
      unshift(@kw, $resp->{_content} =~ /size=2 color=E8E8E8\>&nbsp;(\d+)<\/td>.+?color=E8E8E8>&nbsp;([^\<]+)/s);
      my $i; my $l;
      return (map { if ($i++ % 2) { ($_, $l) } else { $l = $_; () } } @kw);
    } else {
      return { map { if ($i++ % 2) { ($_, $l) } else { $l = $_; () } } @kw };
    }
  } else {
    if (wantarray) {
      return (undef, $resp);
    } else {
      return;
    }
  }
}

sub AUTOLOAD {
  my $self = shift; (my $auto = $AUTOLOAD) =~ s/.*:://;
  if ($auto =~ /^(mkt|lang)$/) {
    return $self->{"\u$auto"};
  }
  elsif ($auto eq 'DESTROY') {
  }
  else {
    croak "Could not AUTOLOAD method $auto.";
  }
}

'True Value';
__END__

=head1 NAME 

WWW::Overture::Keywords - Query Overture keyword suggestion tool.

=head1 VERSION

 $Revision: 1.2 $
 $Date: 2005/07/25 09:48:00 $

=head1 SYNOPSIS

  use WWW::Overture::Keywords;
  my $ov = new WWW::Overture::Keywords;

  my %keywords = $ov->get('keywords');

=head1 DESCRIPTION

The WWW::Overture::Keywords module provides a method to query the
Overture keyword suggestion tool and return a list of related key
phrases, along with the frequency of searches for each key phrase.

=head1 CONSTRUCTOR

=over 2

=item B<new()>

Creates and returns a new WWW::Overture::Keywords object.

=back

=head1 OBJECT METHODS

=over 2

=item B<get($keyword)>

Get related key phrases (with search counts) for B<$keyword>. 

In scalar context, returns a hash reference with the keyword info. In
list context, returns a hash with the same info.

On failure in scalar context, returns undef. On failure in list
context, returns a list containing undef and the LWP response object
that resulted from the Overture query.

=back

=head1 BUGS

=over 2

=item * 

If you find any, please let me know!

=back

=head1 CHANGELOG

=over 2

$Log: Keywords.pm,v $

Revision 1.1  2005/07/25 09:45:16  hash
Initial commit

=back

=head1 AUTHOR

WWW::Overture::Keywords is Copyright (c) 2005 Ashish Gulhati
<ashish at neomailbox.com>. All Rights Reserved.

=head1 ACKNOWLEDGEMENTS

Thanks to Barkha, my sunshine, and to Neomailbox -
http://neomailbox.com/

=head1 LICENSE

This code is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
