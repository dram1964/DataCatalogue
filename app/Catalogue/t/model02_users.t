use strict;
use warnings;
use Test::More;
use Catalogue::Schema;

my $dsn = "dbi:mysql:catalogue_test";
my $schema = Catalogue::Schema->connect( $dsn, 'tutorial', 'thispassword' );

my $account01_details = {
    username      => "testaccount01",
    password      => 'mypassword',
    email_address => 'test@example.com',
    first_name    => 'Test',
    last_name     => 'Account',
    active        => 1,
};
ok( my $user01_rs = $schema->resultset('User'), 'User ResultSet Requested' );
isa_ok( $user01_rs, 'DBIx::Class::ResultSet', 'ResultSet Type' );
ok( my $user01 = $user01_rs->create($account01_details),
    'User Create Requested' );
isa_ok( $user01, 'Catalogue::Schema::Result::User', 'User Object Type' );
ok( $user01->delete, 'User ' . $user01->username . ' Deleted' );

my $account02_details = {
    username      => "testaccount02",
    password      => 'mypassword',
    email_address => 'test@example.com',
    first_name    => 'Test',
    last_name     => 'Account',
    active        => 1,
    user_roles    => [ { role_id => 1 }, { role_id => 2 }, { role_id => 3 } ],
};
my $user02_rs = $schema->resultset('User');
ok( my $user02 = $user02_rs->create($account02_details),
    'User Create with user_roles Requested' );
ok( $user02->has_role('curator'), 'User has curator Role' );
ok( $user02->has_role('admin'),   'User has admin Role' );
ok( $user02->has_role('user'),    'User has user Role' );

my $user03_rs = $schema->resultset('User');
ok( my $user03 = $user03_rs->find_or_create($account02_details),
    'Find or Create Existing Account' );
is( $user03->id, $user02->id, 'New account matches exisiting account id' );
is( $user03->username, 'testaccount02',
    'user03 username matches user02 username' );
ok( $user03->update( { username => 'testaccount03' } ),
    'Update user03 name' );
ok( $user03 = $schema->resultset('User')->find( $user03->id ),
    'Check database for user03 update' );
ok( $user02 = $schema->resultset('User')->find( $user02->id ),
    'Check database for user02 update' );
is( $user03->username, 'testaccount03',   'Check update to test03 username' );
is( $user02->username, $user03->username, 'Check update to test02 username' );

my $account04_details = {
    username      => "testaccount03",
    password      => 'mypassword',
    email_address => 'update.or.create@example.com',
    first_name    => 'Updated',
    last_name     => 'Account',
    active        => 1,
};

$user03
    = $schema->resultset('User')->search( { username => 'testaccount03' } )
    ->single;
my $user04 = $schema->resultset('User')->update_or_create($account04_details);
is( $user04->username,
    $account04_details->{username},
    "Account has correct username"
);
is( $user04->id, $user03->id, "Id matches existing account" );
is( $user04->email_address,
    $account04_details->{email_address},
    "Email updated"
);
ok( $user04->delete, 'User ' . $user04->username . ' deleted' );

ok( my $user05
        = $schema->resultset('User')
        ->find_or_create( $account04_details, key => 'username' ),
    'user05 added'
);
ok( $user05->delete, 'User ' . $user05->username . ' deleted' );

$account04_details->{user_roles}
    = [ { role_id => 1 }, { role_id => 2 }, { role_id => 3 } ];
ok( $user05
        = $schema->resultset('User')
        ->find_or_new( $account04_details, key => 'username' ),
    'user05 new object created'
);
my $check_rs
    = $schema->resultset('User')->find( { username => $user05->username } );
is( $check_rs, undef, "User05 not yet inserted" );
ok( $user05->insert,              'user05 record inserted' );
ok( $user05->has_role('curator'), 'User has curator Role' );
ok( $user05->has_role('admin'),   'User has admin Role' );
ok( $user05->has_role('user'),    'User has user Role' );
ok( $user05->delete,              'User ' . $user05->username . ' deleted' );

done_testing();
