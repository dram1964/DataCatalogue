use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Category2;

ok( request('/category2')->is_redirect, 'Request should succeed' );
done_testing();
