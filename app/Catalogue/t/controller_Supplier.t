use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Supplier;

ok( request('/supplier')->is_redirect, 'Request should succeed' );
done_testing();
