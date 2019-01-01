use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::DataRequest;

ok( request('/datarequest')->is_redirect, 'Request should succeed' );
done_testing();
