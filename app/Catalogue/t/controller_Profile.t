use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Profile;

ok( request('/profile')->is_redirect, 'Request should succeed' );
done_testing();
