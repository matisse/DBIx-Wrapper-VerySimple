# -*- perl -*-
###############################################################################

use strict;
use warnings;
use English qw(-no_match_vars);
use Test::More;

eval 'use Test::Pod 1.00';    ## no critic
if ($EVAL_ERROR) {
    plan skip_all => 'Test::Pod 1.00 required for testing POD';
}
else {
    all_pod_files_ok();       
}
