# $Header: /Users/matisse/Desktop/CVS2GIT/matisse.net.cvs/perl-modules/DBIx-Wrapper-VerySimple/Attic/Wrapper.pm,v 1.2 2003/10/01 19:42:20 matisse Exp $
#
#
###############################################################################

package DBI::Wrapper;
use 5.006;
use strict;
use DBI;
use Carp qw(cluck confess);
our $VERSION = '0.01';


=head1 NAME

DBI::Wrapper

=head1 SYNOPSIS

  use DBI::Wrapper;
  my $DB = DBI::Wrapper->new( $dsn, @other_args ); 
  my $hashref = $DB->FetchHash($sql, @bind_values);
  my $arrayref = $DB->FetchAll($sql, @bind_values);
  my $rv       = $DB->Do($sql, @bind_values);

=head1 DESCRIPTION

Provides a wrapper around DBI.

Note: the reason we don't test the connection and attempt to reconnect
is that this module is most likely used in a web environment with
mod_perl and Apache::DBI, and Apache::DBI will attempt to reconnect
if the database connection dies.

=cut

sub new {
    my $class = shift;
    my $self = {};
    $self->{'args'} = \@_;  # So we can use them to reconnect if needed
    $self->{'dbh'} = DBI->connect( @_ ) ||
       confess("Could not connect using DSN: '@_'");;
    bless( $self, $class );
    return $self;
}


=head1 Per-Method Documentation

These are the public methods provided.

=head2 new

	my $db = DBI::Wrapper->new($dsn,$user,password);

$dsn is a B<DBI> DSN, for example:

	my $dsn = "DBI:mysql:database='Accounting'";

or a more complex exmaple:

	my $database = 'Accounting';
	my $host     = 'data.ourdomain.com';  # Default is usually 'localhost'
	my $port     = '4200';  # 3306 is the MySQl default
	my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";

=head2 FetchHash

	my $hashref = FetchHash( $sql, @bind_values );

Returns a hash-ref for one row.

=cut

sub FetchHash {
    my( $self, $sql, @bind_values ) = @_;
    my $sth = $self->{'dbh'}->prepare_cached($sql) or confess("SQL: {$sql}", $self->{'dbh'}->errstr);
    $sth->execute(@bind_values) or confess("SQL: {$sql}");
    my $row = $sth->fetchrow_hashref;
    $sth->finish;
    return  $row;
}


=head2 FetchAll

    my $arrayref = FetchAll( $sql, @bind_values );

Returns an array-ref of hash-refs. @bind_values are optional.

=cut

sub FetchAll {
    my( $self, $sql, @bind_values ) = @_;
    my @rows;
    my $sth = $self->{'dbh'}->prepare_cached($sql) or confess("SQL: {$sql}");
    $sth->execute(@bind_values) or confess( "SQL: {$sql}");
    while ( my $row = $sth->fetchrow_hashref ) {
        push( @rows, $row );
    }
    $sth->finish;
    return \@rows;
}

=head2 Do

    my $result_code = Do( $sql, @bind_values );

Executes a non-select SQL statement

=cut

sub Do {
    my( $self, $sql, @bind_values ) = @_;
    my $sth = $self->{'dbh'}->prepare_cached($sql) or confess("SQL: {$sql}");
    my $result_code = $sth->execute(@bind_values) or confess( "SQL: {$sql}" );
    $sth->finish;
    return $result_code;
}

sub DESTROY {
    my($self) = @_;
    # warn ref $self, " executing DESTROY method. Disconnecting from database";
    $self->{'dbh'}->disconnect;
}

###########################################################################
1;

=head1 SEE ALSO

L<DBI>, L<Apache::DBI>

=head1 AUTHOR

Matisse Enzer E<lt>matisse@matisse.netE<gt>

=head1 COPYRIGHT

Copyright (c)2001 by Matisse Enzer

This package is free software and is provided "as is"
without express or implied warranty.  It may be used,
redistributed and/or modified under the terms of the Perl
Artistic License (see http://www.perl.com/perl/misc/Artistic.html)

=cut

