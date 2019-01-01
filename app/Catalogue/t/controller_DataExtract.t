use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Catalogue';
use Catalogue::Controller::DataExtract;

ok( request('/dataextract')->is_redirect, 'Request should succeed' );
done_testing();
