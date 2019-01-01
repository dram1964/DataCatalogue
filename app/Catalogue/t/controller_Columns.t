use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Columns;

ok( request('/columns')->is_redirect, 'Request should succeed' );
done_testing();
