# -*- perl -*-

use strict;
use warnings;
use English qw(-no_match_vars);
use Test::More;

eval {
	use Test::Pod::Coverage 1.04;
};

if ( $EVAL_ERROR ) {
    plan skip_all => 'Test::Pod::Coverage required to test POD';
}
else {
    plan tests => 1;
}

pod_coverage_ok( 'DBIx::Wrapper::VerySimple' );
