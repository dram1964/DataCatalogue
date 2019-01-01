use strict;
use warnings;
use Test::More;

use_ok( "Test::WWW::Mechanize::Catalyst" => "Catalogue" );

SKIP: {
    skip "These links are not currently implemented", 1;

    my $ua1 = Test::WWW::Mechanize::Catalyst->new;
    my $ua2 = Test::WWW::Mechanize::Catalyst->new;
    my $ua3 = Test::WWW::Mechanize::Catalyst->new;

    $ua1->get_ok( "/login?username=test01&password=mypass", "Login test01" );
    $ua1->content_lacks( "kpe/list",       "No KPE list for test01" );
    $ua1->content_lacks( "erid/list",      "No ERID list for test01" );
    $ua1->content_lacks( "supplier/list",  "No supplier list for test01" );
    $ua1->content_lacks( "category2/list", "No category2 list for test01" );
    $ua1->content_lacks( "tasks/list",     "No tasks list for test01" );

    $ua2->get_ok( "/login?username=test02&password=mypass", "Login test02" );
    $ua2->content_contains( "kpe/list",       "KPE list for test02" );
    $ua2->content_contains( "erid/list",      "ERID list for test02" );
    $ua2->content_contains( "supplier/list",  "Supplier list for test02" );
    $ua2->content_contains( "category2/list", "Category2 list for test02" );
    $ua2->content_contains( "tasks/list",     "Tasks list for test02" );

    $ua3->get_ok( "/login?username=test03&password=mypass", "Login test03" );
    $ua3->content_contains( "kpe/list",       "KPE list for test03" );
    $ua3->content_contains( "erid/list",      "ERID list for test03" );
    $ua3->content_contains( "supplier/list",  "Supplier list for test03" );
    $ua3->content_contains( "category2/list", "Category2 list for test03" );
    $ua3->content_contains( "tasks/list",     "Tasks list for test03" );
}

done_testing();
