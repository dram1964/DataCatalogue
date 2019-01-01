use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Registration;

ok( request('/registration')->is_redirect, 'Request should succeed' );
done_testing();
