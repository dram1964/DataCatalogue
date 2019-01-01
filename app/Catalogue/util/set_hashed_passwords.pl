use strict;
use warnings;

use Catalogue::Schema;

my $schema = Catalogue::Schema->connect('dbi:mysql:catalogue_test', 'tutorial', 'thispassword');

my @users = $schema->resultset('User')->search({id => 19});

foreach my $user (@users) {
  $user->password('mypass');
  $user->update;
}
