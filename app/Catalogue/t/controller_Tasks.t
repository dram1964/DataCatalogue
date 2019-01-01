use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::Tasks;

ok( request('/task')->is_redirect, 'Redirect request for task' );

done_testing();
