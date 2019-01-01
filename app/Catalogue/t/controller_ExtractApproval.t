use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::ExtractApproval;

ok( request('/extractapproval')->is_redirect, 'Request should succeed' );
done_testing();
