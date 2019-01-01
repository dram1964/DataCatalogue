use strict;
use warnings;
use Test::More;

BEGIN { use_ok( "Test::WWW::Mechanize::Catalyst" => "Catalogue" ) }

my $ua1         = Test::WWW::Mechanize::Catalyst->new;
my $ua2         = Test::WWW::Mechanize::Catalyst->new;
my $welcome_msg = "Welcome to the ";
my $page_title  = "BRC Clinical Research Informatics Unit";

my $controller_message = {
    applications     => 'List of all Applications on the Metadata Catalogue',
    category2        => 'Category2s',
    columns          => 'Columns for all tables',
    databases        => 'Showing Databases for all Systems',
    dataextract      => 'Data Requests with Completed IG Review',
    datarequest      => 'Data Requests',
    datareview       => 'List of Data Requests',
    erid             => 'ERIDs',
    extract_approval => 'Data Requests with Completed IG Review',
    igadmin          => 'List of Data Requests',
    kpe              => 'Key Production Environments',
    registration     => 'List of Requests for Registration',
    schemas          => 'Showing Schemas for all Databases',
    supplier         => 'Suppliers',
    tables           => 'Tables for all schemas',
    tasks            => 'List of outstanding tasks to be completed',
    users            => 'Current Metadata Catalogue Users',
};

note('Testing that Controller List actions require Logged-On User');
for my $controller ( keys %$controller_message ) {
    $ua2->get_ok( '/logout', 'Logout via URL' );
    $ua2->get_ok( "/$controller/list",
        "Request /$controller/list for empty user" );
    $ua2->content_contains( 'You need to logon',
        'Redirect to Login for empty user' );
    $ua2->get_ok( '/login?username=test04&password=mypass',
        'Log back in for test04' );
    $ua2->content_contains(
        $controller_message->{$controller},
        "Redirect to /$controller/list after login"
    );
}

$ua2->get_ok('/logout');
$ua2->get_ok( '/datasets/list', 'Request /datasets/list for empty user' );
$ua2->content_lacks( 'You need to logon',
    'No login redirect for datasets list' );
$ua2->content_contains( 'list of datasets available',
    'Datasets list page displayed' );

done_testing;
