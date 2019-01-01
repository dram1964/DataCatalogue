use strict;
use warnings;
use Test::More;
use List::MoreUtils qw(any);

BEGIN { use_ok( "Test::WWW::Mechanize::Catalyst" => "Catalogue" ) }

my $ua1 = Test::WWW::Mechanize::Catalyst->new;
$ua1->get_ok( '/login?username=test06&password=mypass',
    'Login in with user role' );

my @list_allowed = qw(dataextract datasets);

my $controller_message = {
    applications     => 'List of all Applications on the Metadata Catalogue',
    category2        => 'Category2s',
    columns          => 'Columns for all tables',
    databases        => 'Showing Databases for all Systems',
    dataextract      => 'Data Requests with Completed IG Review',
    datarequest      => 'List of Data Requests',
    datareview       => 'List of Data Requests',
    datasets         => 'This page contains a list of datasets',
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

note('Testing access to list pages for "extractor" role');
for my $controller ( keys %$controller_message ) {
    if ( any { $_ eq $controller } @list_allowed ) {
        $ua1->get_ok( "/$controller/list",
            "Request /$controller/list for extractor" );
        $ua1->content_contains( $controller_message->{$controller},
            'Access granted' );
    }
    else {
        $ua1->get_ok( "/$controller/list",
            "Request /$controller/list for extractor" );
        $ua1->content_contains( 'Permission Denied',
            'Redirect to Permission Denied' );
        $ua1->content_lacks(
            $controller_message->{$controller},
            'Requested content not available'
        );
    }
}

done_testing;
