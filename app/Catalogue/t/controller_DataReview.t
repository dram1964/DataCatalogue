use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::DataReview;

ok( request('/datareview')->is_redirect, 'Request should succeed' );
done_testing();
