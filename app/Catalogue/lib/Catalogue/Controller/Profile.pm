package Catalogue::Controller::Profile;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Catalogue::Controller::Profile - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched Catalogue::Controller::Profile in Profile.');
}

=head2 base

Can place common logic to start a chained dispatch here

=cut 

sub object : Chained('/') : PathPart('profile') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $user = $c->user->get_object;
    $c->stash( object => $c->model('DB::User')->find( $user->id ) );

    $c->load_status_msgs;
}

=head2 show

Shows current users profile data in form

=cut

sub show : Chained('object') : PathPart('show') : Args(0) {
    my ( $self, $c ) = @_;
    my $profile = $c->stash->{object};
    $c->stash(
        template => 'profile/show.tt2',
        user     => $profile
    );
}

=head2 update

Updates the current user from form data submitted 

=cut 

sub update : Chained('object') : PathPart('update') : Args(0) {
    my ( $self, $c ) = @_;
    my $profile = $c->stash->{object};

    my $registration = $c->request->params;

    $profile->update(
        {   email_address => $registration->{email_address},
            first_name    => $registration->{first_name},
            last_name     => $registration->{last_name},
            job_title     => $registration->{job_title},
            department    => $registration->{department},
            organisation  => $registration->{organisation},
            address1      => $registration->{address1},
            address2      => $registration->{address2},
            address3      => $registration->{address3},
            postcode      => $registration->{postcode},
            city          => $registration->{city},
            telephone     => $registration->{telephone},
            mobile        => $registration->{mobile},
        }
    );

    $c->stash(
        template   => 'profile/show.tt2',
        user       => $profile,
        status_msg => 'Profile Updated'
    );
}

=head2 change_password

allows user to change their password

=cut

sub change_password : Chained('object') : PathPart('change_password') :
    Args(0) {
    my ( $self, $c ) = @_;
    my $profile  = $c->stash->{object};
    my $username = $profile->username;
    my $password = $c->request->params->{password};

    if ($c->authenticate(
            {   username => $username,
                password => $password
            }
        )
        )
    {
        $profile->update( { password => $c->req->params->{password1} } );
        $c->stash( status_msg => 'Password Updated' );
    }
    else {
        $c->stash(
            error_msg => 'Password Not Updated: Incorrect Current Password' );
    }

    $c->stash(
        template => 'profile/show.tt2',
        user     => $profile,
    );
}

=encoding utf8

=head1 AUTHOR

David Ramlakhan,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
