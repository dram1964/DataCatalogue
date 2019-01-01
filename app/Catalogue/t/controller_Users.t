use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Users;

ok( request('/users')->is_redirect, 'Request should succeed' );
done_testing();
