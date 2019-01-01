use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Applications;

ok( request('/applications')->is_redirect, 'Request should succeed' );
done_testing();
