use strict;
use warnings;

use Catalogue::Schema;

my $schema = Catalogue::Schema->connect('dbi:mysql:catalogue', 'tutorial', 'thispassword');

my @applications = $schema->resultset('Application')->all;

foreach my $application (@applications) {
  my $name = $application->name;
  if (defined($name)) {
    if ($name =~ /&amp;/) {
      $name =~ s/&amp;/&/g;
      $application->name($name);
      $application->update;
    }
    if ($name =~ /&quot;/) {
      $name =~ s/&quot;/'/g;
      $application->name($name);
      $application->update;
    }
    if ($name =~ /&#10;/) {
      $name =~ s/&#10;/\n/g;
      $application->name($name);
      $application->update;
    }
    if ($name =~ /\s*$/) {
      $name =~ s/\s*$//g;
      $application->name($name);
      $application->update;
    }
  }
  my $description = $application->description;
  if (defined($description)) {
    if ($description =~ /&amp;/) {
      $description =~ s/&amp;/&/g;
      $application->description($description);
      $application->update;
    }
    if ($description =~ /&quot;/) {
      $description =~ s/&quot;/'/g;
      $application->description($description);
      $application->update;
    }
    if ($description =~ /&#10;/) {
      $description =~ s/&#10;/\n/g;
      $application->description($description);
      $application->update;
    }
    if ($description =~ /\s*$/) {
      $description =~ s/\s*$//g;
      $application->description($description);
      $application->update;
    }
  }
}

my @systems = $schema->resultset('CatalogueSystem')->all;

foreach my $system (@systems) {
  my $name = $system->name;
  if (defined($name)) {
    if ($name =~ /&amp;/) {
      $name =~ s/&amp;/&/g;
      $system->name($name);
      $system->update;
    }
    if ($name =~ /&quot;/) {
      $name =~ s/&quot;/'/g;
      $system->name($name);
      $system->update;
    }
    if ($name =~ /&#10;/) {
      $name =~ s/&#10;/\n/g;
      $system->name($name);
      $system->update;
    }
    if ($name =~ /\s*$/) {
      $name =~ s/\s*$//g;
      $system->name($name);
      $system->update;
    }
  }
  my $description = $system->description;
  if (defined($description)) {
    if ($description =~ /&amp;/) {
      $description =~ s/&amp;/&/g;
      $system->description($description);
      $system->update;
    }
    if ($description =~ /&quot;/) {
      $description =~ s/&quot;/'/g;
      $system->description($description);
      $system->update;
    }
    if ($description =~ /&#10;/) {
      $description =~ s/&#10;/\n/g;
      $system->description($description);
      $system->update;
    }
    if ($description =~ /\s*$/) {
      $description =~ s/\s*$//g;
      $system->description($description);
      $system->update;
    }
  }
}
