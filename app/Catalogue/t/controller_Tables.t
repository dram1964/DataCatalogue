use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Tables;

ok( request('/tables')->is_redirect, 'Request should succeed' );
done_testing();
