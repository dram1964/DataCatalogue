use strict;
use warnings;
use Test::More;
use Test::WWW::Mechanize::Catalyst "Catalogue";

my $basic_user            = Test::WWW::Mechanize::Catalyst->new;
my $requestor_user        = Test::WWW::Mechanize::Catalyst->new;
my $curator_user          = Test::WWW::Mechanize::Catalyst->new;
my $admin_user            = Test::WWW::Mechanize::Catalyst->new;
my $igadmin_user          = Test::WWW::Mechanize::Catalyst->new;
my $extractor_user        = Test::WWW::Mechanize::Catalyst->new;
my $extract_approver_user = Test::WWW::Mechanize::Catalyst->new;

my @all_users = (
    $basic_user, $requestor_user, $curator_user, $admin_user, $igadmin_user,
    $extractor_user, $extract_approver_user
);

my $page_title = "BRC Clinical Research Informatics Unit";

$basic_user->get_ok( "/login?username=test01&password=mypass",
    "Login for basic_user" );
$requestor_user->get_ok( "/login?username=test02&password=mypass",
    "Login for requestor_user" );
$curator_user->get_ok( "/login?username=test03&password=mypass",
    "Login for curator_user" );
$admin_user->get_ok( "/login?username=test04&password=mypass",
    "Login for admin_user" );
$igadmin_user->get_ok( "/login?username=test05&password=mypass",
    "Login for igadmin_user" );
$extractor_user->get_ok( "/login?username=test06&password=mypass",
    "Login for igadmin_user" );
$extract_approver_user->get_ok( "/login?username=test07&password=mypass",
    "Login for igadmin_user" );
$_->title_is( $page_title, "Check for login/index title" ) for @all_users;

$_->get_ok( "/datasets/list", "get datasets list" ) for @all_users;
$_->title_is( 'Catalogue Datasets', "datasets list title" ) for @all_users;
$_->content_contains( "a list of datasets available for research",
    "Check Datasets List content" )
    for @all_users;

$_->get_ok( "/databases/list", "get databases list" ) for @all_users;
$_->content_contains( "Permission Denied",
    "basic, requestor and igadmin denied Database List" )
    for $basic_user, $requestor_user, $igadmin_user, $extractor_user,
    $extract_approver_user;
$_->title_is( 'System Databases', "curator and admin databases list title" )
    for $curator_user, $admin_user;
$_->content_contains( "Showing Databases for all Systems",
    "Check Databases List content" )
    for $curator_user, $admin_user;

$_->get_ok( "/applications/list", "get applications list" ) for @all_users;
$_->content_contains( "Permission Denied",
    "basic, igadmin, extractor and requestor denied Applications List" )
    for $basic_user, $requestor_user, $igadmin_user, $extractor_user,
    $extract_approver_user;
$_->title_is( 'Application List',
    "curator and admin applications list title" )
    for $curator_user, $admin_user;
$_->content_contains( "List of all Applications on the Metadata Catalogue",
    "Check Applications List content" )
    for $curator_user, $admin_user;
$_->content_lacks( "delete</a>",
    "Check Applications list has no delete llnk" )
    for $curator_user, $admin_user;

$_->get_ok( "/schemas/list", "get schema list" ) for @all_users;
$_->content_contains( "Permission Denied",
    "basic, igadmin, extractor and requestor denied Schemas List" )
    for $basic_user, $requestor_user, $igadmin_user, $extractor_user,
    $extract_approver_user;
$_->title_is( 'Database Schemas', "curator and admin schemas list title" )
    for $curator_user, $admin_user;
$_->content_contains( "Showing Schemas for all Databases",
    "Check Schemas List content" )
    for $curator_user, $admin_user;
$_->content_lacks( "delete</a>", "Check Schemas list has no delete link" )
    for $curator_user, $admin_user;

$_->get_ok( "/tables/list", "get table list" ) for @all_users;
$_->content_contains( "Permission Denied",
    "basic, igadmin, extractor and requestor denied Tables List" )
    for $basic_user, $requestor_user, $igadmin_user, $extractor_user,
    $extract_approver_user;
$_->title_is( 'Database Tables', "curator and admin tables list title" )
    for $curator_user, $admin_user;
$_->content_contains( "Tables for all schemas", "Check Tables List content" )
    for $curator_user, $admin_user;
$_->content_lacks( "delete</a>", "Check Tables list has no delete link" )
    for $curator_user, $admin_user;

$_->get_ok( "/columns/list", "get column list" ) for @all_users;
$_->content_contains( "Permission Denied",
    "basic, igadmin, extractor and requestor denied Columns List" )
    for $basic_user, $requestor_user, $igadmin_user, $extractor_user,
    $extract_approver_user;
$_->title_is( 'Table Columns', "curator and admin columns list title" )
    for $curator_user, $admin_user;
$_->content_contains( "Columns for all tables", "Check Columns List content" )
    for $curator_user, $admin_user;
$_->content_lacks( "delete</a>", "Check Columns list has no delete link" )
    for $curator_user, $admin_user;

$_->get_ok( "/tasks/list", "get column list" ) for @all_users;
$_->content_contains( "Permission Denied",
    "basic, igadmin, curator, extractor and requestor denied Tasks List" )
    for $basic_user, $requestor_user, $curator_user, $igadmin_user,
    $extractor_user,
    $extract_approver_user;
$_->title_is( 'Project Task List', "curator and admin task list title" )
    for $admin_user;
$_->content_contains( "outstanding tasks to be completed",
    "Check Tasks List content" )
    for $admin_user;
$_->content_lacks( "delete</a>", "Check Tasks list has no delete link" )
    for $admin_user;

$basic_user->get_ok( "/tasks/list", "'test01' tasks list" );
$basic_user->content_contains( "Permission Denied",
    "Test01 denied Task List" );

# use 'diag $basic_user->content' to see content of current response

done_testing();
