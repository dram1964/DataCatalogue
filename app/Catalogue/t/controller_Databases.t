use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Databases;

ok( request('/databases')->is_redirect, 'Request should succeed' );
done_testing();
