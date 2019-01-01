use strict;
use warnings;
use Test::More;

BEGIN { use_ok( "Test::WWW::Mechanize::Catalyst" => "Catalogue" ) }

my $ua1         = Test::WWW::Mechanize::Catalyst->new;
my $ua2         = Test::WWW::Mechanize::Catalyst->new;
my $welcome_msg = "Welcome to the ";
my $page_title  = "BRC Clinical Research Informatics Unit";

$_->get_ok( "/", "Request root page" ) for $ua1, $ua2;
$_->title_is( $page_title, "Check for Welcome page title" ) for $ua1, $ua2;

$ua1->get_ok( "/login?username=test01&password=mypass", "Login test01" );
$ua2->get_ok( "/login?username=test04&password=mypass", "Login test04" );
$_->content_contains( $welcome_msg, "Welcome Page displayed after login" )
    for $ua1, $ua2;

$_->get_ok( "/login", "Return to '/login'" ) for $ua1, $ua2;
$_->title_is( "Metadata Catalogue Login", "Check for login title" )
    for $ua1, $ua2;
$_->content_contains("Username") for $ua1, $ua2;
$_->content_contains("Password") for $ua1, $ua2;
$_->content_contains( "Logout", "Logout link available" ) for $ua1, $ua2;
$_->content_contains( "Already logged-in", "Already logged-in message" )
    for $ua1, $ua2;

$_->get_ok( "/logout", "Logout via URL" ) for $ua1, $ua2;
$_->content_contains( $welcome_msg, "Welcome Page displayed after logout" )
    for $ua1, $ua2;

done_testing;
