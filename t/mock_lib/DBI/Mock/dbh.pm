############################################

#  Mock class - for testing only

package DBI::Mock::dbh;
use strict;
use warnings;

our $VERSION = 0.01;

sub errstr { }

sub prepare_cached {
    my ( $self, $sql ) = @_;
    return if ( $sql eq 'TEST_FAILURE' );
    my $sth = { sql => $sql, };
    bless $sth, 'DBI::Mock::sth';
    return $sth;
}

sub disconnect { }

1;
